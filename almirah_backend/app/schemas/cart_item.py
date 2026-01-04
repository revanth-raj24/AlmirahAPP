from sqlmodel import SQLModel, Field
from typing import Optional
from datetime import datetime

# Base schema for cart item operations
class CartItemBase(SQLModel):
    product_id: int
    quantity: int = 1

# Schema for adding item to cart (Client -> Server)
class CartItemCreate(CartItemBase):
    user_id: int

# Schema for updating cart item quantity
class CartItemUpdate(SQLModel):
    quantity: int = Field(ge=1)  # Minimum quantity is 1

# Schema for reading cart item with product details (Server -> Client)
class CartItemPublic(SQLModel):
    id: int
    product_id: int
    quantity: int
    # Product details (will be populated by service)
    product_name: str
    product_brand: str
    product_image_url: str
    product_price: float
    product_discount_price: Optional[float] = None
    # Calculated fields
    item_total: float  # price * quantity
    item_mrp: float  # (discount_price or price) * quantity

# Schema for complete bag/cart details response
class BagDetailsResponse(SQLModel):
    user_id: int
    items: list[CartItemPublic]
    # Summary calculations
    total_mrp: float  # Sum of all item MRPs
    total_discount: float  # Total discount amount
    total_amount: float  # Final amount to pay
    delivery_fee: float = 0.0  # Can be calculated based on business rules
    final_total: float  # total_amount + delivery_fee

