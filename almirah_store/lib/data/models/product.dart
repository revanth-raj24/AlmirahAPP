class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final String imageUrl; // Dart standard: camelCase
  final String category;
  final String brand;
  final double? discountPrice; // Nullable because it might be null in DB
  final double rating; // Rating field from backend

  // Base URL for the server (set by repository)
  static String? baseUrl;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.brand,
    this.discountPrice,
    this.rating = 0.0,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Get the raw image URL from JSON
    String rawImageUrl = json['image_url'] ?? '';

    // If the URL starts with /static/, prepend the base URL
    String finalImageUrl = rawImageUrl;
    if (rawImageUrl.startsWith('/static/') && baseUrl != null) {
      // Remove leading slash from baseUrl if present, and ensure proper joining
      String cleanBaseUrl = baseUrl!.endsWith('/')
          ? baseUrl!.substring(0, baseUrl!.length - 1)
          : baseUrl!;
      finalImageUrl = '$cleanBaseUrl$rawImageUrl';
    }
    // If it's already a full URL (http:// or https://), use it as is

    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      // Handle int-to-double conversion safely
      price: (json['price'] as num).toDouble(),
      // Use the processed image URL (with server address if needed)
      imageUrl: finalImageUrl,
      category: json['category'] ?? 'General',
      brand: json['brand'] ?? 'Generic',
      discountPrice: json['discount_price'] != null
          ? (json['discount_price'] as num).toDouble()
          : null,
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : 0.0,
    );
  }
}
