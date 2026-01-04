from fastapi import APIRouter, Depends, HTTPException
from sqlmodel import Session, select
from app.core.database import get_session
from app.models.user import User

router = APIRouter()

@router.post("/create-default", response_model=dict)
def create_default_user(session: Session = Depends(get_session)):
    """
    Create a default user for testing.
    Returns the user ID that can be used for cart operations.
    """
    # Check if default user already exists
    statement = select(User).where(User.email == "default@almirah.com")
    existing_user = session.exec(statement).first()
    
    if existing_user:
        return {
            "message": "Default user already exists",
            "user_id": existing_user.id,
            "name": existing_user.name
        }
    
    # Create default user
    default_user = User(
        name="Default User",
        email="default@almirah.com"
    )
    session.add(default_user)
    session.commit()
    session.refresh(default_user)
    
    return {
        "message": "Default user created successfully",
        "user_id": default_user.id,
        "name": default_user.name
    }

@router.get("/default", response_model=dict)
def get_default_user(session: Session = Depends(get_session)):
    """
    Get the default user ID.
    Creates one if it doesn't exist.
    """
    statement = select(User).where(User.email == "default@almirah.com")
    existing_user = session.exec(statement).first()
    
    if existing_user:
        return {
            "user_id": existing_user.id,
            "name": existing_user.name
        }
    
    # Create if doesn't exist
    default_user = User(
        name="Default User",
        email="default@almirah.com"
    )
    session.add(default_user)
    session.commit()
    session.refresh(default_user)
    
    return {
        "user_id": default_user.id,
        "name": default_user.name
    }

