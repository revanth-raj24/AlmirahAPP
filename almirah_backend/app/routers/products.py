from fastapi import APIRouter, Depends, HTTPException, File, UploadFile, Form
from sqlmodel import Session, select
from typing import List, Optional
import uuid
from pathlib import Path

from app.core.database import get_session
from app.models.product import Product
from app.schemas.product import ProductPublic

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

# 1. CREATE: Add a new product to the database (FormData with file upload - for admin frontend)
@router.post("/", response_model=ProductPublic)
async def create_product(
    name: str = Form(...),
    brand: str = Form(...),
    category: str = Form(...),
    price: float = Form(...),
    description: Optional[str] = Form(None),
    discount_price: Optional[float] = Form(None),
    image: UploadFile = File(...),
    session: Session = Depends(get_session)
):
    """Create a product with file upload from admin panel"""
    # Validate file type
    if not image.content_type or not image.content_type.startswith("image/"):
        raise HTTPException(status_code=400, detail="File must be an image")
    
    try:
        # Save the uploaded file
        image_url = save_uploaded_file(image)
        
        # Create product
        db_product = Product(
            name=name,
            brand=brand,
            category=category,
            price=price,
            description=description,
            discount_price=discount_price,
            image_url=image_url,
            rating=0.0
        )
        
        session.add(db_product)
        session.commit()
        session.refresh(db_product)
        return db_product
    except HTTPException:
        # Re-raise HTTP exceptions (like from save_uploaded_file)
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error creating product: {str(e)}")

# 1b. CREATE: Add a new product with file upload (multipart/form-data - for mobile devices)
@router.post("/upload", response_model=ProductPublic)
async def create_product_with_file(
    name: str = Form(...),
    brand: str = Form(...),
    category: str = Form(...),
    price: float = Form(...),
    description: Optional[str] = Form(None),
    discount_price: Optional[float] = Form(None),
    image: UploadFile = File(...),
    session: Session = Depends(get_session)
):
    """Create a product with file upload from mobile devices"""
    # Validate file type
    if not image.content_type or not image.content_type.startswith("image/"):
        raise HTTPException(status_code=400, detail="File must be an image")
    
    try:
        # Save the uploaded file
        image_url = save_uploaded_file(image)
        
        # Create product
        db_product = Product(
            name=name,
            brand=brand,
            category=category,
            price=price,
            description=description,
            discount_price=discount_price,
            image_url=image_url,
            rating=0.0
        )
        
        session.add(db_product)
        session.commit()
        session.refresh(db_product)
        return db_product
    except HTTPException:
        # Re-raise HTTP exceptions (like from save_uploaded_file)
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error creating product: {str(e)}")

# 2. READ: Get all products (with optional category filter)
@router.get("/", response_model=List[ProductPublic])
def read_products(
    category: Optional[str] = None,
    session: Session = Depends(get_session)
):
    """Get all products, optionally filtered by category name"""
    if category:
        # Filter products by category name
        products = session.exec(
            select(Product).where(Product.category == category)
        ).all()
    else:
        # Return all products if no category filter
        products = session.exec(select(Product)).all()
    return products

# 3. DELETE: Delete a product by ID
@router.delete("/{product_id}")
def delete_product(product_id: int, session: Session = Depends(get_session)):
    product = session.get(Product, product_id)
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")
    session.delete(product)
    session.commit()
    return {"message": "Product deleted successfully"}