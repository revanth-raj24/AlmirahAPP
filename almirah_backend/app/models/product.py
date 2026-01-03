from typing import Optional
from sqlmodel import Field, SQLModel

class Product(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    brand: str
    name: str
    description: Optional[str] = None
    price: float
    image_url: str
    category: str
    discount_price: Optional[float] = None
    rating: float = 0.0