from sqlmodel import SQLModel

# Base schema with shared properties
class ProductBase(SQLModel):
    name: str
    description: str | None = None
    price: float
    image_url: str
    category: str
    brand: str
    discount_price: float | None = None

# Schema for creating a product (Client -> Server)
# We don't need 'id' here because the DB creates it.
class ProductCreate(ProductBase):
    pass

# Schema for reading a product (Server -> Client)
# We MUST have 'id' here so the frontend knows which product is which.
class ProductPublic(ProductBase):
    id: int
    rating: float = 0.0