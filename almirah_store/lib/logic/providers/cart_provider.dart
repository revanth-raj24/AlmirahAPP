import 'package:flutter/foundation.dart';
import '../../data/models/product.dart';

/// Local cart item model for state management
class LocalCartItem {
  final Product product;
  int quantity;

  LocalCartItem({
    required this.product,
    this.quantity = 1,
  });

  double get itemTotal {
    final price = product.discountPrice ?? product.price;
    return price * quantity;
  }

  double get itemMrp {
    return product.price * quantity;
  }
}

/// Cart state manager using Provider pattern
class CartProvider extends ChangeNotifier {
  final List<LocalCartItem> _items = [];

  /// Get all cart items
  List<LocalCartItem> get items => List.unmodifiable(_items);

  /// Get total number of items in cart
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  /// Get total price of all items
  double get totalPrice {
    return _items.fold(0.0, (sum, item) => sum + item.itemTotal);
  }

  /// Get total MRP (before discounts)
  double get totalMrp {
    return _items.fold(0.0, (sum, item) => sum + item.itemMrp);
  }

  /// Get total discount
  double get totalDiscount => totalMrp - totalPrice;

  /// Check if cart is empty
  bool get isEmpty => _items.isEmpty;

  /// Add a product to the cart
  /// If the product already exists, increment its quantity
  void addToCart(Product product) {
    final existingItemIndex = _items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingItemIndex >= 0) {
      // Product already in cart, increment quantity
      _items[existingItemIndex].quantity++;
    } else {
      // New product, add to cart
      _items.add(LocalCartItem(product: product, quantity: 1));
    }

    notifyListeners();
  }

  /// Remove a product from the cart
  void removeFromCart(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
  }

  /// Update quantity of a product in the cart
  void updateQuantity(Product product, int quantity) {
    if (quantity <= 0) {
      removeFromCart(product);
      return;
    }

    final existingItemIndex = _items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingItemIndex >= 0) {
      _items[existingItemIndex].quantity = quantity;
      notifyListeners();
    }
  }

  /// Increment quantity of a product
  void incrementQuantity(Product product) {
    final existingItemIndex = _items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingItemIndex >= 0) {
      _items[existingItemIndex].quantity++;
      notifyListeners();
    }
  }

  /// Decrement quantity of a product
  void decrementQuantity(Product product) {
    final existingItemIndex = _items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingItemIndex >= 0) {
      if (_items[existingItemIndex].quantity > 1) {
        _items[existingItemIndex].quantity--;
      } else {
        // Remove if quantity would become 0
        removeFromCart(product);
      }
      notifyListeners();
    }
  }

  /// Clear all items from the cart
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  /// Get quantity of a specific product in cart
  int getQuantity(Product product) {
    final item = _items.firstWhere(
      (item) => item.product.id == product.id,
      orElse: () => LocalCartItem(product: product, quantity: 0),
    );
    return item.quantity;
  }

  /// Check if a product is in the cart
  bool isInCart(Product product) {
    return _items.any((item) => item.product.id == product.id);
  }
}


