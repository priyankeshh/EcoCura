import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/product_model.dart';

class PopularProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;

  const PopularProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.lightGreen.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Product Image
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: product.imageUrls.isNotEmpty
                      ? Image.asset(
                          product.imageUrls.first,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(
                                color: AppTheme.lightGreen.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                _getProductIcon(product.name),
                                size: 40,
                                color: AppTheme.primaryGreen,
                              ),
                            );
                          },
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: AppTheme.lightGreen.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            _getProductIcon(product.name),
                            size: 40,
                            color: AppTheme.primaryGreen,
                          ),
                        ),
                ),
              ),
            ),

            // Product Details
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Product Name
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 2),

                    // Price
                    Text(
                      '₹${product.price.toInt()}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Buy Button
                    SizedBox(
                      width: double.infinity,
                      height: 28,
                      child: ElevatedButton(
                        onPressed: onTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryGreen,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: EdgeInsets.zero,
                          elevation: 0,
                        ),
                        child: const Text(
                          'Buy',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getProductIcon(String productName) {
    switch (productName.toLowerCase()) {
      case 'bag':
        return Icons.shopping_bag;
      case 'shoes':
        return Icons.directions_walk;
      case 't-shirt':
        return Icons.checkroom;
      case 'watch':
        return Icons.watch;
      default:
        return Icons.shopping_cart;
    }
  }
}
