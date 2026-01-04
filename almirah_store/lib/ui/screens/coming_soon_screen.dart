import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Coming Soon',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
      ),
      body: const Center(
        child: Text(
          'This category is coming soon!',
          style: TextStyle(
            fontSize: 18,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

