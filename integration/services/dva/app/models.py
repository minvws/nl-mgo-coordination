from pydantic import BaseModel
from sqlalchemy import JSON
from sqlmodel import Field, SQLModel

class Patient(SQLModel, table=True):
    id: int | None = Field(default=None, primary_key=True)
    bsn: str = Field(index=True, unique=True)
    pdn: str | None = Field(index=True, unique=True, nullable=True)
    patient_info: dict = Field(sa_type=JSON)
