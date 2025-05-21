import http.client
import json
from typing import Annotated, Any, AsyncGenerator, Dict, List, Sequence

from fastapi import Depends, FastAPI, Form
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse, RedirectResponse
from hashlib import sha256
from sqlmodel import Session, delete, select

from app.models import Patient

from .db import create_db_and_tables, get_session

app = FastAPI()


async def lifespan(app: FastAPI) -> AsyncGenerator[Any, Any]:
    create_db_and_tables()

    with next(get_session()) as session:
        import_patients(session)

    yield


app = FastAPI(title="dva", lifespan=lifespan)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_headers=["*"],
)

# For the Demo app we just use a hardcoded client id
CLIENT_ID = "87221a55-4cef-4bde-adf6-f968195679be"
MOCK_PRS = True
RID_TO_PDN = {}

@app.get("/", include_in_schema=False)
async def root():
    return RedirectResponse("/docs")

class APIRequestException(Exception):
    def __init__(self, status_code: int, message: str):
        self.status_code = status_code
        self.message = message
        super().__init__(f"API request failed with status code {status_code}: {message}")

@app.post("/patient")
def patient(
    rid: Annotated[str, Form()],
    session: Annotated[Session, Depends(get_session)],
) -> JSONResponse:
    try:
        pdn = exchange_rid_for_pdn(rid)
    except APIRequestException as e:
        return JSONResponse({"error": e.message}, 422)

    patient = session.exec(select(Patient).where(Patient.pdn == pdn)).first()
    if not patient:
        return JSONResponse({"error": "Patient not found"}, 422)

    return JSONResponse(patient.patient_info)


def import_patients(session: Session) -> None:
    raw_patients = read_patients_json()
    if not raw_patients:
        return

    with session.begin():
        delete_all_patients(session)
        create_patients(session, raw_patients)

        patients = get_all_patients(session)
        bsn_list = [patient.bsn for patient in patients]

        bsn_pdn_mapping = create_pseudonyms(bsn_list)

        """ When mocking the PRS, we create a local RID to PDN@DVA mapping, deriving the RID from the BSN.
            The way to do this, is to first hash the BSN and then hash that hash, which is how VAD creates a mock RID.
            This is used to simulate the PRS response when exchanging a RID for a PDN. """
        if MOCK_PRS:
            create_rid_to_pdn_mapping(bsn_pdn_mapping)

        assign_pseudonyms_to_patients(session, patients, bsn_pdn_mapping)

        session.commit()


def create_rid_to_pdn_mapping(bsn_pdn_mapping: Dict[str, str]) -> None:
    for bsn, pdn in bsn_pdn_mapping.items():
        vad_pdn = sha256(bsn.encode("utf-8")).hexdigest()
        rid = sha256(vad_pdn.encode("utf-8")).hexdigest()
        RID_TO_PDN.update({rid: pdn})


def assign_pseudonyms_to_patients(
    session: Session,
    patients: Sequence[Patient],
    bsn_to_pdn_mapping: Dict[str, str],
) -> None:
    for patient in patients:
        if pdn := bsn_to_pdn_mapping.get(patient.bsn):
            patient.pdn = pdn
            session.add(patient)


def create_pseudonyms(bsn_list: List[str]) -> Dict[str, str]:
    return {bsn: create_org_pseudonym(bsn) for bsn in bsn_list}


def get_all_patients(session: Session) -> Sequence[Patient]:
    return session.exec(select(Patient)).all()


def delete_all_patients(session: Session) -> None:
    session.exec(delete(Patient))


def read_patients_json() -> Dict[str, str]:
    with open("patients.json", "r") as file:
        return json.load(file)


def create_patients(session: Session, raw_patients: Dict[str, str]) -> None:
    for bsn, patient_info in raw_patients.items():
        patient = Patient(bsn=bsn, patient_info=patient_info)
        session.add(patient)


def create_org_pseudonym(bsn: str) -> str:
    conn = http.client.HTTPConnection("prs:6502")
    conn.request(
        "POST", f"/org_pseudonym?bsn={bsn}&org_id={CLIENT_ID}"
    )
    response: http.client.HTTPResponse = conn.getresponse()
    data = response.read()
    result: str = data.decode()
    result_json = json.loads(result)
    pdn: str = result_json.get("pdn")
    conn.close()
    return pdn


def exchange_rid_for_pdn(rid: str) -> str:
    if MOCK_PRS:
        return RID_TO_PDN.get(rid)

    connection = http.client.HTTPConnection("prs:6502")
    connection.request(
        "POST",
        f"/rid/exchange/pdn?rid={rid}&org_id={CLIENT_ID}",
    )
    response: http.client.HTTPResponse = connection.getresponse()

    data = response.read()
    result_json: str = data.decode()
    result = json.loads(result_json)
    
    if response.status != 200:
        print(f"HTTP request to PRS failed with status code {response.status}: {result_json}")
        connection.close()
        raise APIRequestException(response.status, result.get("error", "Unknown error"))
    
    pdn: str = result.get("pdn")
    connection.close()
    return pdn
