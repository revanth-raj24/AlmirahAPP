# Almirah Admin Dashboard

A modern admin dashboard for managing products in the Almirah e-commerce application.

## Features

- ✅ Add new products with form validation
- ✅ View all products in a responsive grid layout
- ✅ Delete products (requires DELETE endpoint on backend)
- ✅ Real-time product preview
- ✅ Toast notifications for success/error messages
- ✅ Clean, modern UI with Tailwind CSS

## Tech Stack

- React 18
- Vite
- Tailwind CSS
- Lucide React (Icons)

## Setup

1. Install dependencies:
```bash
npm install
```

2. Make sure your FastAPI backend is running at `http://127.0.0.1:8000`

3. Start the development server:
```bash
npm run dev
```

4. Open your browser to `http://localhost:3000`

## API Endpoints

The dashboard expects the following endpoints:

- `GET http://127.0.0.1:8000/products/` - Fetch all products
- `POST http://127.0.0.1:8000/products/` - Create a new product
- `DELETE http://127.0.0.1:8000/products/{id}` - Delete a product (optional)

## Product Schema

```json
{
  "name": "string (required)",
  "description": "string (optional)",
  "price": "float (required)",
  "discount_price": "float (optional)",
  "image_url": "string (required)",
  "category": "Men | Women | Kids (required)",
  "brand": "string (required)"
}
```

## Build for Production

```bash
npm run build
```

The built files will be in the `dist` directory.

