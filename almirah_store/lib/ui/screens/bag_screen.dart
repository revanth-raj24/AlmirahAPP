import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class BagScreen extends StatefulWidget {
  const BagScreen({super.key});

  @override
  State<BagScreen> createState() => _BagScreenState();
}

class _BagScreenState extends State<BagScreen> {
  // Dummy cart items data
  List<Map<String, dynamic>> _cartItems = [
    {
      'id': 1,
      'name': 'Classic White T-Shirt',
      'brand': 'H&M',
      'imageUrl': 'https://via.placeholder.com/150',
      'price': 29.99,
      'mrp': 39.99,
      'quantity': 2,
    },
    {
      'id': 2,
      'name': 'Slim Fit Jeans',
      'brand': 'Levi\'s',
      'imageUrl': 'https://via.placeholder.com/150',
      'price': 79.99,
      'mrp': 99.99,
      'quantity': 1,
    },
    {
      'id': 3,
      'name': 'Running Shoes',
      'brand': 'Nike',
      'imageUrl': 'https://via.placeholder.com/150',
      'price': 119.99,
      'mrp': 149.99,
      'quantity': 1,
    },
  ];

  // Toggle between empty and active state
  bool _isEmpty = false; // Set to true to see empty state

  double _calculateTotal() {
    if (_isEmpty) return 0.0;
    double subtotal = 0.0;
    for (var item in _cartItems) {
      subtotal += (item['price'] as double) * (item['quantity'] as int);
    }
    return subtotal;
  }

  double _calculateMRP() {
    if (_isEmpty) return 0.0;
    double mrp = 0.0;
    for (var item in _cartItems) {
      mrp += (item['mrp'] as double) * (item['quantity'] as int);
    }
    return mrp;
  }

  double _calculateDiscount() {
    return _calculateMRP() - _calculateTotal();
  }

  void _updateQuantity(int itemId, int change) {
    setState(() {
      final item = _cartItems.firstWhere((item) => item['id'] == itemId);
      final newQuantity = (item['quantity'] as int) + change;
      if (newQuantity > 0) {
        item['quantity'] = newQuantity;
      } else {
        _cartItems.removeWhere((item) => item['id'] == itemId);
        if (_cartItems.isEmpty) {
          _isEmpty = true;
        }
      }
    });
  }

  void _removeItem(int itemId) {
    setState(() {
      _cartItems.removeWhere((item) => item['id'] == itemId);
      if (_cartItems.isEmpty) {
        _isEmpty = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'My Bag',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
      ),
      body: _isEmpty
          ? _buildEmptyState()
          : _buildActiveState(),
      bottomNavigationBar: _isEmpty
          ? null
          : _buildBottomBar(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_bag_outlined,
                size: 80,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Your bag is empty',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Looks like you haven\'t added anything to your bag yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Navigate to home or categories
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Shop Now',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveState() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _cartItems.length,
            itemBuilder: (context, index) {
              final item = _cartItems[index];
              return _CartItemCard(
                item: item,
                onQuantityChange: (change) =>
                    _updateQuantity(item['id'] as int, change),
                onRemove: () => _removeItem(item['id'] as int),
              );
            },
          ),
        ),
        // Price Details Section
        _buildPriceDetails(),
      ],
    );
  }

  Widget _buildPriceDetails() {
    final mrp = _calculateMRP();
    final discount = _calculateDiscount();
    final deliveryFee = 0.0; // Free delivery
    final total = _calculateTotal() + deliveryFee;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Price Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _PriceRow(label: 'MRP', amount: mrp),
          const SizedBox(height: 8),
          _PriceRow(
            label: 'Discount',
            amount: -discount,
            isDiscount: true,
          ),
          const SizedBox(height: 8),
          _PriceRow(
            label: 'Delivery Fee',
            amount: deliveryFee,
            isFree: deliveryFee == 0,
          ),
          const Divider(height: 24),
          _PriceRow(
            label: 'Total Amount',
            amount: total,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    final total = _calculateTotal();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Order placed for \$${total.toStringAsFixed(2)}'),
                backgroundColor: AppColors.primary,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: Text(
            'Place Order • \$${total.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final Function(int) onQuantityChange;
  final VoidCallback onRemove;

  const _CartItemCard({
    required this.item,
    required this.onQuantityChange,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item['imageUrl'] as String,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['brand'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['name'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '\$${(item['price'] as double).toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (item['mrp'] != null &&
                              (item['mrp'] as double) > (item['price'] as double))
                            Text(
                              '\$${(item['mrp'] as double).toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 12,
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey[400],
                              ),
                            ),
                        ],
                      ),
                      // Quantity Counter
                      Row(
                        children: [
                          InkWell(
                            onTap: () => onQuantityChange(-1),
                            borderRadius: BorderRadius.circular(4),
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Icon(
                                Icons.remove,
                                size: 16,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${item['quantity']}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 12),
                          InkWell(
                            onTap: () => onQuantityChange(1),
                            borderRadius: BorderRadius.circular(4),
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 16,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Remove Button
            IconButton(
              icon: const Icon(Icons.close, size: 20),
              color: Colors.grey[400],
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool isDiscount;
  final bool isFree;
  final bool isTotal;

  const _PriceRow({
    required this.label,
    required this.amount,
    this.isDiscount = false,
    this.isFree = false,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          isFree
              ? 'FREE'
              : '\$${amount.abs().toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isDiscount
                ? Colors.green
                : isTotal
                    ? AppColors.primary
                    : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

