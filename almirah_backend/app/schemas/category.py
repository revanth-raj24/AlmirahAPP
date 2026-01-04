from sqlmodel import SQLModel

# Base schema with shared properties
class CategoryBase(SQLModel):
    name: str
    image_url: str

# Schema for creating a category (Client -> Server)
# We don't need 'id' here because the DB creates it.
class CategoryCreate(CategoryBase):
    pass

# Schema for reading a category (Server -> Client)
# We MUST have 'id' here so the frontend knows which category is which.
class CategoryPublic(CategoryBase):
    id: int

