from sqlmodel import Session, select
from fastapi import HTTPException
from typing import List
from app.models.cart_item import CartItem
from app.models.product import Product
from app.schemas.cart_item import CartItemPublic, BagDetailsResponse

class CartService:
    """Business logic for cart operations."""
    
    @staticmethod
    def calculate_item_total(product: Product, quantity: int) -> tuple[float, float]:
        """
        Calculate item total and MRP.
        Returns: (item_total, item_mrp)
        - item_total: The actual price to pay (discount_price if available, else price)
        - item_mrp: The original MRP (price if no discount, else discount_price is the discounted price)
        """
        # If discount_price exists, it's the discounted price, and price is the MRP
        if product.discount_price is not None:
            item_total = product.discount_price * quantity
            item_mrp = product.price * quantity
        else:
            # No discount, price is both total and MRP
            item_total = product.price * quantity
            item_mrp = product.price * quantity
        
        return (item_total, item_mrp)
    
    @staticmethod
    def get_cart_item_with_product(
        session: Session, 
        cart_item: CartItem
    ) -> CartItemPublic:
        """Convert CartItem to CartItemPublic with product details."""
        product = session.get(Product, cart_item.product_id)
        if not product:
            raise HTTPException(status_code=404, detail="Product not found")
        
        item_total, item_mrp = CartService.calculate_item_total(product, cart_item.quantity)
        
        return CartItemPublic(
            id=cart_item.id,
            product_id=cart_item.product_id,
            quantity=cart_item.quantity,
            product_name=product.name,
            product_brand=product.brand,
            product_image_url=product.image_url,
            product_price=product.price,
            product_discount_price=product.discount_price,
            item_total=item_total,
            item_mrp=item_mrp
        )
    
    @staticmethod
    def get_bag_details(session: Session, user_id: int) -> BagDetailsResponse:
        """Get complete bag details with all calculations."""
        # Get all cart items for user
        statement = select(CartItem).where(CartItem.user_id == user_id)
        cart_items = session.exec(statement).all()
        
        if not cart_items:
            return BagDetailsResponse(
                user_id=user_id,
                items=[],
                total_mrp=0.0,
                total_discount=0.0,
                total_amount=0.0,
                delivery_fee=0.0,
                final_total=0.0
            )
        
        # Convert to public format with product details
        items_public: List[CartItemPublic] = []
        total_mrp = 0.0
        total_amount = 0.0
        
        for cart_item in cart_items:
            item_public = CartService.get_cart_item_with_product(session, cart_item)
            items_public.append(item_public)
            total_mrp += item_public.item_mrp
            total_amount += item_public.item_total
        
        total_discount = total_mrp - total_amount
        delivery_fee = 0.0  # Free delivery for now
        final_total = total_amount + delivery_fee
        
        return BagDetailsResponse(
            user_id=user_id,
            items=items_public,
            total_mrp=total_mrp,
            total_discount=total_discount,
            total_amount=total_amount,
            delivery_fee=delivery_fee,
            final_total=final_total
        )

