import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/product.dart';
import '../../logic/providers/cart_provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  // Require the product object to be passed in
  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Transparent AppBar allows image to go behind it (Modern Look)
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          // Best Practice: Always provide a way to go back
          onPressed: () => Navigator.pop(context), 
        ),
        actions: [
           IconButton(icon: const Icon(Icons.share, color: Colors.black), onPressed: () {}),
           IconButton(icon: const Icon(Icons.favorite_border, color: Colors.black), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // 1. Large Hero Image
          Expanded(
            flex: 5, // Takes up 50% of the screen
            child: Image.network(
              product.imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          // 2. Product Details
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)), // Curved top
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand & Name
                  Text(
                    product.brand,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    product.name,
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 20),
                  
                  // Price Block
                  Row(
                    children: [
                      Text("₹${product.effectivePrice.toInt()}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      if (product.discountPrice != null) ...[
                        const SizedBox(width: 10),
                        Text("₹${product.originalPrice.toInt()}", 
                            style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey, fontSize: 16)),
                        const SizedBox(width: 10),
                        Text("${product.discountPercentage}% OFF", 
                            style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ],
                  ),
                  
                  const Spacer(),
                  
                  // 3. Add to Cart Button (Full Width)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // Add product to cart using CartProvider
                        context.read<CartProvider>().addToCart(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("${product.name} added to Bag"),
                            duration: const Duration(seconds: 2),
                            action: SnackBarAction(
                              label: 'View Bag',
                              textColor: Colors.white,
                              onPressed: () {
                                // Navigate to bag screen (index 2 in MainScreen)
                                Navigator.of(context).popUntil((route) => route.isFirst);
                                // Switch to bag tab - this would require accessing MainScreen state
                                // For now, just show a message
                              },
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF3F6C), // Myntra Pink
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("ADD TO BAG", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

