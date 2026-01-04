@echo off
echo Starting Almirah Backend Server...
echo.
echo Make sure you're in the backend directory and have activated your virtual environment.
echo.
echo The server will be accessible at:
echo   - http://127.0.0.1:8000 (from your PC)
echo   - http://10.0.2.2:8000 (from Android Emulator)
echo.
uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
pause


