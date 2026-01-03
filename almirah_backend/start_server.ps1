Write-Host "Starting Almirah Backend Server..." -ForegroundColor Green
Write-Host ""
Write-Host "Make sure you're in the backend directory and have activated your virtual environment." -ForegroundColor Yellow
Write-Host ""
Write-Host "The server will be accessible at:" -ForegroundColor Cyan
Write-Host "  - http://127.0.0.1:8000 (from your PC)" -ForegroundColor Cyan
Write-Host "  - http://10.0.2.2:8000 (from Android Emulator)" -ForegroundColor Cyan
Write-Host ""
uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload

