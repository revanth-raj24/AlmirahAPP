from typing import Optional
from sqlmodel import Field, SQLModel
from datetime import datetime

class CartItem(SQLModel, table=True):
    """CartItem model linking Users to Products with quantity."""
    id: Optional[int] = Field(default=None, primary_key=True)
    user_id: int = Field(foreign_key="user.id", index=True)
    product_id: int = Field(foreign_key="product.id", index=True)
    quantity: int = Field(default=1, ge=1)  # Minimum quantity is 1
    created_at: datetime = Field(default_factory=datetime.utcnow)
    updated_at: datetime = Field(default_factory=datetime.utcnow)

