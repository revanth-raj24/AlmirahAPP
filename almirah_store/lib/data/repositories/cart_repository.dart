import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cart_item.dart';

class CartRepository {
  // ANDROID EMULATOR: Use 'http://10.0.2.2:8000'
  // iOS SIMULATOR: Use 'http://127.0.0.1:8000'
  // PHYSICAL DEVICE: Use your PC's LAN IP (e.g., 'http://192.168.1.5:8000')
  static const String baseUrl = 'http://192.168.31.164:8000';

  // Connection timeout duration (10 seconds)
  static const Duration timeoutDuration = Duration(seconds: 10);

  /// Add a product to the bag
  Future<CartItem> addToBag({
    required int userId,
    required int productId,
    int quantity = 1,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/cart/add');
      print("🔗 Adding to bag: $uri");

      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'user_id': userId,
              'product_id': productId,
              'quantity': quantity,
            }),
          )
          .timeout(timeoutDuration, onTimeout: () {
        throw Exception(
          'Connection timeout. Please check:\n'
          '1. Backend server is running\n'
          '2. Server is accessible at $baseUrl\n'
          '3. Both devices are on the same network',
        );
      });

      if (response.statusCode == 200) {
        print("✅ Successfully added to bag");
        CartItem.baseUrl = baseUrl;
        Map<String, dynamic> body = jsonDecode(response.body);
        return CartItem.fromJson(body);
      } else {
        throw Exception(
          'Failed to add to bag: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print("❌ Error adding to bag: $e");
      throw Exception('Error adding to bag: $e');
    }
  }

  /// Remove an item from the bag
  Future<void> removeFromBag({
    required int cartItemId,
    required int userId,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/cart/remove/$cartItemId?user_id=$userId');
      print("🔗 Removing from bag: $uri");

      final response = await http
          .delete(uri)
          .timeout(timeoutDuration, onTimeout: () {
        throw Exception('Connection timeout');
      });

      if (response.statusCode == 200) {
        print("✅ Successfully removed from bag");
      } else {
        throw Exception(
          'Failed to remove from bag: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print("❌ Error removing from bag: $e");
      throw Exception('Error removing from bag: $e');
    }
  }

  /// Update the quantity of an item in the bag
  Future<CartItem> updateQuantity({
    required int cartItemId,
    required int userId,
    required int quantity,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/cart/update/$cartItemId?user_id=$userId');
      print("🔗 Updating quantity: $uri");

      final response = await http
          .put(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'quantity': quantity}),
          )
          .timeout(timeoutDuration, onTimeout: () {
        throw Exception('Connection timeout');
      });

      if (response.statusCode == 200) {
        print("✅ Successfully updated quantity");
        CartItem.baseUrl = baseUrl;
        Map<String, dynamic> body = jsonDecode(response.body);
        return CartItem.fromJson(body);
      } else {
        throw Exception(
          'Failed to update quantity: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print("❌ Error updating quantity: $e");
      throw Exception('Error updating quantity: $e');
    }
  }

  /// Get complete bag details with all calculations
  Future<BagDetails> getBagDetails({required int userId}) async {
    try {
      final uri = Uri.parse('$baseUrl/cart/details?user_id=$userId');
      print("🔗 Fetching bag details: $uri");

      final response = await http.get(uri).timeout(timeoutDuration, onTimeout: () {
        throw Exception(
          'Connection timeout. Please check:\n'
          '1. Backend server is running\n'
          '2. Server is accessible at $baseUrl\n'
          '3. Both devices are on the same network',
        );
      });

      if (response.statusCode == 200) {
        print("✅ Successfully fetched bag details");
        CartItem.baseUrl = baseUrl;
        Map<String, dynamic> body = jsonDecode(response.body);
        return BagDetails.fromJson(body);
      } else {
        throw Exception(
          'Failed to load bag details: ${response.statusCode} - ${response.body}',
        );
      }
    } on http.ClientException catch (e) {
      print("❌ Network error: $e");
      throw Exception('Error connecting to server: $e');
    } catch (e) {
      print("❌ FATAL ERROR FETCHING BAG DETAILS: $e");
      throw Exception('Error fetching bag details: $e');
    }
  }

  /// Get all items in the bag (simpler endpoint)
  Future<List<CartItem>> getBagItems({required int userId}) async {
    try {
      final uri = Uri.parse('$baseUrl/cart/items?user_id=$userId');
      print("🔗 Fetching bag items: $uri");

      final response = await http.get(uri).timeout(timeoutDuration, onTimeout: () {
        throw Exception('Connection timeout');
      });

      if (response.statusCode == 200) {
        print("✅ Successfully fetched bag items");
        CartItem.baseUrl = baseUrl;
        List<dynamic> body = jsonDecode(response.body);
        return body
            .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'Failed to load bag items: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print("❌ Error fetching bag items: $e");
      throw Exception('Error fetching bag items: $e');
    }
  }
}

