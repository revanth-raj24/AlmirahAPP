from sqlmodel import SQLModel, create_engine, Session

# 1. The Connection String
# For now, we use a simple SQLite file named "almirah.db"
sqlite_file_name = "almirah.db"
sqlite_url = f"sqlite:///{sqlite_file_name}"

# 2. The Engine (The actual connection manager)
# connect_args={"check_same_thread": False} is needed only for SQLite
engine = create_engine(sqlite_url, echo=True, connect_args={"check_same_thread": False})

# 3. Function to create tables (Run this on startup)
def create_db_and_tables():
    # Only create tables if they don't exist
    # This preserves existing data when the server restarts
    # For schema changes in development, manually delete almirah.db
    SQLModel.metadata.create_all(engine)

# 4. Dependency (The "Session")
# Every API request gets its own temporary connection session
def get_session():
    with Session(engine) as session:
        yield session