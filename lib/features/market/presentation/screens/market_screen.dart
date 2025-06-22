import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/custom_search_bar.dart';
import '../../../../shared/models/product_model.dart';
import '../../../../shared/providers/product_provider.dart';

class MarketScreen extends ConsumerStatefulWidget {
  const MarketScreen({super.key});

  @override
  ConsumerState<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends ConsumerState<MarketScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;
  PriceRange? _selectedPriceRange;

  final List<ProductCategory> _categories = ProductCategory.values;
  final List<PriceRange> _priceRanges = PriceRange.values;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchSubmitted(String query) {
    if (query.isNotEmpty) {
      ref.read(productSearchProvider.notifier).searchProducts(query);
    }
  }

  void _onCategorySelected(ProductCategory? category) {
    setState(() {
      _selectedCategory = category?.displayName;
    });
  }

  void _onPriceRangeSelected(PriceRange? priceRange) {
    setState(() {
      _selectedPriceRange = priceRange;
    });
  }

  void _onProductTap(ProductModel product) {
    ref.read(productServiceProvider).updateProductViews(product.id);
    context.push('/product/${product.id}');
  }

  List<ProductModel> _filterProducts(List<ProductModel> products) {
    var filtered = products;

    if (_selectedCategory != null) {
      filtered = filtered.where((p) => p.category == _selectedCategory).toList();
    }

    if (_selectedPriceRange != null) {
      filtered = filtered.where((p) => _selectedPriceRange!.contains(p.price)).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Market'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            CustomSearchBar(
              controller: _searchController,
              hintText: 'Search products...',
              onSubmitted: _onSearchSubmitted,
            ),

            const SizedBox(height: 20),

            // Featured Banner
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryGreen.withOpacity(0.8),
                    AppTheme.lightGreen.withOpacity(0.6),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'WALL art from Old CD\'s...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Active Filters
            if (_selectedCategory != null || _selectedPriceRange != null) ...[
              _buildActiveFilters(),
              const SizedBox(height: 16),
            ],

            // Categories Section
            Text(
              'Categories',
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: 12),

            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = _selectedCategory == category.displayName;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(category.displayName),
                      selected: isSelected,
                      onSelected: (selected) {
                        _onCategorySelected(selected ? category : null);
                      },
                      backgroundColor: AppTheme.lightGreen.withOpacity(0.2),
                      selectedColor: AppTheme.primaryGreen.withOpacity(0.3),
                      labelStyle: TextStyle(
                        color: isSelected ? AppTheme.primaryGreen : AppTheme.darkGreen,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Price Store Section (matching iOS design)
            Text(
              'Price Store',
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: 12),

            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _priceRanges.length,
                itemBuilder: (context, index) {
                  final priceRange = _priceRanges[index];
                  final isSelected = _selectedPriceRange == priceRange;

                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: GestureDetector(
                      onTap: () => _onPriceRangeSelected(isSelected ? null : priceRange),
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.primaryGreen.withOpacity(0.1),
                          border: Border.all(
                            color: isSelected ? Colors.yellow : AppTheme.primaryGreen,
                            width: isSelected ? 3 : 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            priceRange.displayName,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? AppTheme.primaryGreen : AppTheme.darkGreen,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Featured Shops Section
            Text(
              'Featured Shops',
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: 12),

            SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder: (context, index) {
                  final shops = [
                    {'name': 'Reimagine Decor', 'image': 'assets/images/store.png'},
                    {'name': 'Second Life Crafter', 'image': 'assets/images/store1.png'},
                    {'name': 'UpCycled Artisans', 'image': 'assets/images/store2.png'},
                    {'name': 'Greener Goods', 'image': 'assets/images/store3.png'},
                  ];

                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Container(
                      width: 100,
                      height: 140,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            margin: const EdgeInsets.only(top: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                shops[index]['image']!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: AppTheme.lightGreen.withOpacity(0.2),
                                    child: const Icon(
                                      Icons.store,
                                      size: 30,
                                      color: AppTheme.primaryGreen,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              shops[index]['name']!,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Products Section
            Text(
              'All Products',
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: 12),

            productsAsync.when(
              data: (products) {
                final filteredProducts = _filterProducts(products);

                if (filteredProducts.isEmpty) {
                  // Show sample products if no data from Firebase
                  final sampleProducts = ProductService.getSampleProducts();
                  final filteredSamples = _filterProducts(sampleProducts);

                  return _buildProductGrid(filteredSamples);
                }

                return _buildProductGrid(filteredProducts);
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) {
                // Show sample products on error
                final sampleProducts = ProductService.getSampleProducts();
                final filteredSamples = _filterProducts(sampleProducts);
                return _buildProductGrid(filteredSamples);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveFilters() {
    return Wrap(
      spacing: 8,
      children: [
        if (_selectedCategory != null)
          Chip(
            label: Text(_selectedCategory!),
            onDeleted: () => _onCategorySelected(null),
            backgroundColor: AppTheme.primaryGreen.withOpacity(0.2),
          ),
        if (_selectedPriceRange != null)
          Chip(
            label: Text(_selectedPriceRange!.displayName),
            onDeleted: () => _onPriceRangeSelected(null),
            backgroundColor: AppTheme.primaryGreen.withOpacity(0.2),
          ),
      ],
    );
  }

  Widget _buildProductGrid(List<ProductModel> products) {
    if (products.isEmpty) {
      return Container(
        height: 200,
        child: const Center(
          child: Text('No products found'),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductCard(ProductModel product) {
    return GestureDetector(
      onTap: () => _onProductTap(product),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.lightGreen.withOpacity(0.2),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Center(
                  child: product.imageUrls.isNotEmpty
                      ? Image.asset(
                          product.imageUrls.first,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.image,
                              size: 40,
                              color: AppTheme.primaryGreen,
                            );
                          },
                        )
                      : const Icon(
                          Icons.image,
                          size: 40,
                          color: AppTheme.primaryGreen,
                        ),
                ),
              ),
            ),

            // Product Details
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹${product.price.toInt()}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppTheme.primaryGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 14,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          product.rating.toStringAsFixed(1),
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${product.reviewCount})',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
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

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filters'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('More filter options coming soon!'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
