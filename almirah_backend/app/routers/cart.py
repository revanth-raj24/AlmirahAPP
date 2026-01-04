from fastapi import APIRouter, Depends, HTTPException
from sqlmodel import Session, select
from typing import List
from datetime import datetime

from app.core.database import get_session
from app.models.cart_item import CartItem
from app.models.product import Product
from app.schemas.cart_item import (
    CartItemCreate,
    CartItemUpdate,
    CartItemPublic,
    BagDetailsResponse
)
from app.services.cart_service import CartService

router = APIRouter()

@router.post("/add", response_model=CartItemPublic)
def add_to_bag(
    cart_item_data: CartItemCreate,
    session: Session = Depends(get_session)
):
    """
    Add a product to the user's bag.
    If the product already exists in the bag, update the quantity.
    """
    # Validate product exists
    product = session.get(Product, cart_item_data.product_id)
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")
    
    # Check if item already exists in cart
    statement = select(CartItem).where(
        CartItem.user_id == cart_item_data.user_id,
        CartItem.product_id == cart_item_data.product_id
    )
    existing_item = session.exec(statement).first()
    
    if existing_item:
        # Update quantity
        existing_item.quantity += cart_item_data.quantity
        existing_item.updated_at = datetime.utcnow()
        session.add(existing_item)
        session.commit()
        session.refresh(existing_item)
        return CartService.get_cart_item_with_product(session, existing_item)
    else:
        # Create new cart item
        new_cart_item = CartItem(
            user_id=cart_item_data.user_id,
            product_id=cart_item_data.product_id,
            quantity=cart_item_data.quantity
        )
        session.add(new_cart_item)
        session.commit()
        session.refresh(new_cart_item)
        return CartService.get_cart_item_with_product(session, new_cart_item)

@router.delete("/remove/{cart_item_id}")
def remove_from_bag(
    cart_item_id: int,
    user_id: int,  # Query parameter
    session: Session = Depends(get_session)
):
    """
    Remove an item from the bag by cart_item_id.
    Requires user_id to ensure user can only remove their own items.
    """
    cart_item = session.get(CartItem, cart_item_id)
    if not cart_item:
        raise HTTPException(status_code=404, detail="Cart item not found")
    
    # Verify ownership
    if cart_item.user_id != user_id:
        raise HTTPException(
            status_code=403, 
            detail="You can only remove your own cart items"
        )
    
    session.delete(cart_item)
    session.commit()
    return {"message": "Item removed from bag successfully"}

@router.put("/update/{cart_item_id}", response_model=CartItemPublic)
def update_quantity(
    cart_item_id: int,
    cart_item_update: CartItemUpdate,
    user_id: int,  # Query parameter
    session: Session = Depends(get_session)
):
    """
    Update the quantity of an item in the bag.
    Requires user_id to ensure user can only update their own items.
    """
    cart_item = session.get(CartItem, cart_item_id)
    if not cart_item:
        raise HTTPException(status_code=404, detail="Cart item not found")
    
    # Verify ownership
    if cart_item.user_id != user_id:
        raise HTTPException(
            status_code=403,
            detail="You can only update your own cart items"
        )
    
    # Update quantity
    cart_item.quantity = cart_item_update.quantity
    cart_item.updated_at = datetime.utcnow()
    session.add(cart_item)
    session.commit()
    session.refresh(cart_item)
    
    return CartService.get_cart_item_with_product(session, cart_item)

@router.get("/details", response_model=BagDetailsResponse)
def get_bag_details(
    user_id: int,  # Query parameter
    session: Session = Depends(get_session)
):
    """
    Get complete bag details including all items, totals, and calculations.
    Returns empty bag if user has no items.
    """
    return CartService.get_bag_details(session, user_id)

@router.get("/items", response_model=List[CartItemPublic])
def get_bag_items(
    user_id: int,  # Query parameter
    session: Session = Depends(get_session)
):
    """
    Get all items in the user's bag.
    Returns empty list if bag is empty.
    """
    statement = select(CartItem).where(CartItem.user_id == user_id)
    cart_items = session.exec(statement).all()
    
    items_public = []
    for cart_item in cart_items:
        items_public.append(
            CartService.get_cart_item_with_product(session, cart_item)
        )
    
    return items_public

