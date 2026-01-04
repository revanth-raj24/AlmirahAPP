import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductRepository {
  // ANDROID EMULATOR: Use 'http://10.0.2.2:8000'
  // iOS SIMULATOR: Use 'http://127.0.0.1:8000'
  // PHYSICAL DEVICE: Use your PC's LAN IP (e.g., 'http://192.168.1.5:8000')
  static const String baseUrl = 'http://192.168.31.164:8000';

  // Connection timeout duration (10 seconds)
  static const Duration timeoutDuration = Duration(seconds: 10);

  Future<List<Product>> getProducts() async {
    try {
      final uri = Uri.parse('$baseUrl/products');
      print("🔗 Attempting to connect to: $uri");

      final response = await http
          .get(uri)
          .timeout(
            timeoutDuration,
            onTimeout: () {
              throw Exception(
                'Connection timeout. Please check:\n'
                '1. Backend server is running (uvicorn app.main:app --host 0.0.0.0 --port 8000)\n'
                '2. Server is accessible at $baseUrl\n'
                '3. Both devices are on the same network\n'
                '4. Windows Firewall allows port 8000',
              );
            },
          );

      if (response.statusCode == 200) {
        print("✅ Successfully fetched products");
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
    } on http.ClientException catch (e) {
      print("❌ Network error: $e");
      final errorMessage = e.toString();
      String troubleshooting = '';

      if (errorMessage.contains('Connection closed') ||
          errorMessage.contains('Connection refused')) {
        troubleshooting =
            '''
⚠️ Connection Error: Server may not be running or unreachable

Troubleshooting steps:
1. ✅ Start the backend server:
   cd almirah_backend
   uvicorn app.main:app --host 0.0.0.0 --port 8000

2. ✅ Test server in browser:
   Open http://$baseUrl/docs (Swagger UI)
   Or http://$baseUrl/products (should return JSON)

3. ✅ Verify IP address:
   - Check your PC's IP: ipconfig (Windows) or ifconfig (Mac/Linux)
   - Update baseUrl in this file if IP changed
   - Current IP: ${baseUrl.replaceAll('http://', '').replaceAll(':8000', '')}

4. ✅ Network connectivity:
   - Ensure phone/emulator and PC are on same WiFi
   - For Android Emulator: Use http://10.0.2.2:8000
   - For iOS Simulator: Use http://127.0.0.1:8000
   - For Physical Device: Use PC's LAN IP (e.g., http://192.168.1.28:8000)

5. ✅ Firewall:
   - Windows: Allow port 8000 in Windows Firewall
   - Check antivirus isn't blocking the connection
''';
      } else {
        troubleshooting =
            '''
Cannot connect to server at $baseUrl

Troubleshooting steps:
1. Ensure backend is running: uvicorn app.main:app --host 0.0.0.0 --port 8000
2. Verify server is accessible: Open http://$baseUrl/docs in browser
3. Check if both devices are on the same WiFi network
4. Verify your PC's IP address matches: $baseUrl
5. Check Windows Firewall settings for port 8000
''';
      }

      throw Exception('$troubleshooting\nOriginal error: $e');
    } catch (e) {
      print("❌ FATAL ERROR FETCHING DATA: $e");
      throw Exception('Error connecting to server: $e');
    }
  }
}
