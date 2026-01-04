class Category {
  final int id;
  final String name;
  final String imageUrl; // Dart standard: camelCase

  // Base URL for the server (set by repository)
  static String? baseUrl;

  Category({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
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

    return Category(
      id: json['id'],
      name: json['name'],
      imageUrl: finalImageUrl,
    );
  }
}

