from typing import Generator

from sqlalchemy import create_engine
from sqlalchemy.engine import Engine
from sqlmodel import Session, SQLModel

database_file_name = "dva.db"
database_url = f"sqlite:///{database_file_name}"

connect_args = {"check_same_thread": False}
engine: Engine = create_engine(database_url, connect_args=connect_args)


def create_db_and_tables() -> None:
    SQLModel.metadata.create_all(engine)


def get_session() -> Generator[Session, None]:
    with Session(engine) as session:
        yield session
