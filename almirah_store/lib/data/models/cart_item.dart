class CartItem {
  final int id;
  final int productId;
  final int quantity;
  // Product details (populated from backend)
  final String productName;
  final String productBrand;
  final String productImageUrl;
  final double productPrice;
  final double? productDiscountPrice;
  // Calculated fields
  final double itemTotal; // price * quantity
  final double itemMrp; // MRP * quantity

  // Base URL for the server (set by repository)
  static String? baseUrl;

  CartItem({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.productName,
    required this.productBrand,
    required this.productImageUrl,
    required this.productPrice,
    this.productDiscountPrice,
    required this.itemTotal,
    required this.itemMrp,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    // Get the raw image URL from JSON
    String rawImageUrl = json['product_image_url'] ?? '';

    // If the URL starts with /static/, prepend the base URL
    String finalImageUrl = rawImageUrl;
    if (rawImageUrl.startsWith('/static/') && baseUrl != null) {
      // Remove leading slash from baseUrl if present, and ensure proper joining
      String cleanBaseUrl = baseUrl!.endsWith('/')
          ? baseUrl!.substring(0, baseUrl!.length - 1)
          : baseUrl!;
      finalImageUrl = '$cleanBaseUrl$rawImageUrl';
    }

    return CartItem(
      id: json['id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      productName: json['product_name'],
      productBrand: json['product_brand'],
      productImageUrl: finalImageUrl,
      productPrice: (json['product_price'] as num).toDouble(),
      productDiscountPrice: json['product_discount_price'] != null
          ? (json['product_discount_price'] as num).toDouble()
          : null,
      itemTotal: (json['item_total'] as num).toDouble(),
      itemMrp: (json['item_mrp'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'quantity': quantity,
      'product_name': productName,
      'product_brand': productBrand,
      'product_image_url': productImageUrl,
      'product_price': productPrice,
      'product_discount_price': productDiscountPrice,
      'item_total': itemTotal,
      'item_mrp': itemMrp,
    };
  }
}

class BagDetails {
  final int userId;
  final List<CartItem> items;
  final double totalMrp;
  final double totalDiscount;
  final double totalAmount;
  final double deliveryFee;
  final double finalTotal;

  BagDetails({
    required this.userId,
    required this.items,
    required this.totalMrp,
    required this.totalDiscount,
    required this.totalAmount,
    required this.deliveryFee,
    required this.finalTotal,
  });

  factory BagDetails.fromJson(Map<String, dynamic> json) {
    List<dynamic> itemsJson = json['items'] ?? [];
    List<CartItem> items = itemsJson
        .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
        .toList();

    return BagDetails(
      userId: json['user_id'],
      items: items,
      totalMrp: (json['total_mrp'] as num).toDouble(),
      totalDiscount: (json['total_discount'] as num).toDouble(),
      totalAmount: (json['total_amount'] as num).toDouble(),
      deliveryFee: (json['delivery_fee'] as num).toDouble(),
      finalTotal: (json['final_total'] as num).toDouble(),
    );
  }
}

