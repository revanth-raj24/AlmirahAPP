import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductRepository {
  // ANDROID EMULATOR: Use 'http://10.0.2.2:8000'
  // iOS SIMULATOR: Use 'http://127.0.0.1:8000'
  // PHYSICAL DEVICE: Use your PC's LAN IP (e.g., 'http://192.168.1.5:8000')
  static const String baseUrl = 'http://192.168.31.164:8000';

  Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products'));

      if (response.statusCode == 200) {
        // Set the base URL in Product model so it can prepend server address to relative URLs
        Product.baseUrl = baseUrl;

        List<dynamic> body = jsonDecode(response.body);
        List<Product> products = body
            .map((dynamic item) => Product.fromJson(item))
            .toList();
        return products;
      } else {
        throw Exception(
          'Failed to load products: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      // ADD THIS PRINT STATEMENT
      print("❌ FATAL ERROR FETCHING DATA: $e");
      throw Exception('Error connecting to server: $e');
    }
  }
}
