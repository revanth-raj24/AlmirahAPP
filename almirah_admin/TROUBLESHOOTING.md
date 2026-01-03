# Troubleshooting Guide

## Common Issues and Solutions

### 1. CORS Errors
**Error:** `Access to fetch at 'http://127.0.0.1:8000/products' from origin 'http://localhost:3000' has been blocked by CORS policy`

**Solution:** 
- Make sure the backend has CORS middleware configured (already added in `main.py`)
- Restart your FastAPI backend server after adding CORS
- Verify the backend is running at `http://127.0.0.1:8000`

### 2. Backend Not Running
**Error:** `Failed to fetch` or network errors

**Solution:**
- Start your FastAPI backend:
  ```bash
  cd almirah_backend
  uvicorn app.main:app --reload
  ```
- Verify it's running by visiting `http://127.0.0.1:8000` in your browser
- You should see: `{"message": "Almirah API is running"}`

### 3. Frontend Not Starting
**Error:** `npm: command not found` or module errors

**Solution:**
- Make sure Node.js is installed (v16 or higher)
- Install dependencies:
  ```bash
  cd almirah_admin
  npm install
  ```
- Start the dev server:
  ```bash
  npm run dev
  ```

### 4. Products Not Loading
**Error:** Empty product list or loading forever

**Solution:**
- Check browser console for errors (F12)
- Verify the API endpoint: `http://127.0.0.1:8000/products/`
- Test the endpoint directly in browser or Postman
- Check that the database has products

### 5. Form Submission Fails
**Error:** "Failed to create product" toast

**Solution:**
- Check browser console for detailed error messages
- Verify all required fields are filled
- Check that price and discount_price are valid numbers
- Verify image_url is a valid URL
- Check backend logs for server-side errors

### 6. Delete Button Not Working
**Error:** "Failed to delete product" toast

**Solution:**
- The DELETE endpoint has been added to the backend
- Make sure you've restarted the backend after the update
- Check that the product ID exists in the database

### 7. Products Not Loading in Mobile App (Android Emulator)
**Error:** Products added via admin frontend don't appear in mobile app

**Common Causes:**
1. **Database was reset on backend restart** (FIXED)
   - The database was dropping all tables on every server restart
   - This has been fixed - data now persists across restarts
   - **Action:** Restart your backend server to apply the fix

2. **Backend not accessible from emulator**
   - Android emulator uses `10.0.2.2` to access host machine's `127.0.0.1`
   - Make sure backend is running on `http://127.0.0.1:8000`
   - Mobile app should use `http://10.0.2.2:8000` (already configured)

3. **Backend not running**
   - Start backend: `cd almirah_backend && uvicorn app.main:app --reload`
   - Verify it's accessible from emulator

4. **Network connectivity issues**
   - Check if emulator can reach the host machine
   - Try accessing `http://10.0.2.2:8000` in emulator's browser (if available)

**Solution Steps:**
1. Restart your backend server (to apply the database fix)
2. Verify backend is running: Visit `http://127.0.0.1:8000` in browser
3. Add products again via admin frontend (since old data was lost)
4. Check mobile app error messages in Flutter console
5. Verify API endpoint: The app calls `http://10.0.2.2:8000/products`
6. Test API directly from emulator if possible

## Quick Checklist

- [ ] Backend is running on `http://127.0.0.1:8000`
- [ ] Frontend is running on `http://localhost:3000`
- [ ] CORS middleware is configured in backend
- [ ] All dependencies are installed (`npm install` in almirah_admin)
- [ ] Browser console shows no errors
- [ ] Network tab shows successful API calls

## Testing the API Directly

You can test the API endpoints directly:

```bash
# Get all products
curl http://127.0.0.1:8000/products/

# Create a product
curl -X POST http://127.0.0.1:8000/products/ \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test Product",
    "description": "Test Description",
    "price": 99.99,
    "image_url": "https://example.com/image.jpg",
    "category": "Men",
    "brand": "Test Brand"
  }'
```

