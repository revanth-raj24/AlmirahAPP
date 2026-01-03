from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager
from app.core.database import create_db_and_tables
from app.routers import products # Import the router

@asynccontextmanager
async def lifespan(app: FastAPI):
    create_db_and_tables()
    yield

app = FastAPI(lifespan=lifespan)

# Create static directory structure if it doesn't exist
from pathlib import Path
static_dir = Path("static/images")
static_dir.mkdir(parents=True, exist_ok=True)

# Serve static files from the "static" directory
app.mount("/static", StaticFiles(directory="static"), name="static")

# Add CORS middleware to allow frontend requests
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow all origins (for development)
    # In production, specify exact origins:
    # allow_origins=["http://localhost:3000", "http://127.0.0.1:3000"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Register the router
# prefix="/products" means all endpoints in that file will start with /products
app.include_router(products.router, prefix="/products", tags=["Products"])

@app.get("/")
def read_root():
    return {"message": "Almirah API is running"}