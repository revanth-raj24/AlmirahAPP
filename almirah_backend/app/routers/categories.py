from fastapi import APIRouter, Depends, HTTPException, File, UploadFile, Form
from sqlmodel import Session, select
from typing import List
import uuid
from pathlib import Path

from app.core.database import get_session
from app.models.category import Category
from app.schemas.category import CategoryPublic

router = APIRouter()

# Directory for storing uploaded images
UPLOAD_DIR = Path("static/images")
UPLOAD_DIR.mkdir(parents=True, exist_ok=True)

def save_uploaded_file(file: UploadFile) -> str:
    """Save uploaded file and return the URL path"""
    # Generate unique filename
    file_extension = Path(file.filename).suffix if file.filename else ".jpg"
    unique_filename = f"{uuid.uuid4()}{file_extension}"
    file_path = UPLOAD_DIR / unique_filename
    
    # Save file
    try:
        with open(file_path, "wb") as buffer:
            content = file.file.read()
            buffer.write(content)
        # Reset file pointer for potential reuse
        file.file.seek(0)
    except Exception as e:
        # Clean up if save fails
        if file_path.exists():
            file_path.unlink()
        raise HTTPException(status_code=500, detail=f"Failed to save file: {str(e)}")
    
    # Return URL path (relative to static mount) - stored as /static/images/... for Flutter compatibility
    return f"/static/images/{unique_filename}"

# POST /categories/: To add a category
@router.post("/", response_model=CategoryPublic)
async def create_category(
    name: str = Form(...),
    image: UploadFile = File(...),
    session: Session = Depends(get_session)
):
    """Create a category with file upload"""
    # Validate file type
    if not image.content_type or not image.content_type.startswith("image/"):
        raise HTTPException(status_code=400, detail="File must be an image")
    
    try:
        # Save the uploaded file
        image_url = save_uploaded_file(image)
        
        # Create category
        db_category = Category(
            name=name,
            image_url=image_url
        )
        
        session.add(db_category)
        session.commit()
        session.refresh(db_category)
        return db_category
    except HTTPException:
        # Re-raise HTTP exceptions (like from save_uploaded_file)
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error creating category: {str(e)}")

# GET /categories/: To fetch the list of all categories
@router.get("/", response_model=List[CategoryPublic])
def read_categories(session: Session = Depends(get_session)):
    """Get all categories"""
    categories = session.exec(select(Category)).all()
    return categories

