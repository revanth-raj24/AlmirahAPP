from typing import Optional
from sqlmodel import Field, SQLModel

class User(SQLModel, table=True):
    """Simple User model for cart ownership.
    Can be extended later with authentication."""
    id: Optional[int] = Field(default=None, primary_key=True)
    name: str
    email: Optional[str] = None

