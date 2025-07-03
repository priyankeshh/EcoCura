import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/custom_search_bar.dart';
import '../../../../shared/models/waste_category_model.dart';
import '../../../../shared/models/product_model.dart';
import '../../../../shared/providers/product_provider.dart';
import '../widgets/waste_category_card.dart';
import '../widgets/popular_product_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  late List<WasteCategoryModel> _wasteCategories;

  @override
  void initState() {
    super.initState();
    _wasteCategories = WasteCategoryModel.getDefaultCategories();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchSubmitted(String query) {
    if (query.isNotEmpty) {
      ref.read(productSearchProvider.notifier).searchProducts(query);
      context.push('/search?q=$query');
    }
  }

  void _onCategoryTap(WasteCategoryModel category) {
    context.push('/category/${category.id}');
  }

  void _onProductTap(ProductModel product) {
    ref.read(productServiceProvider).updateProductViews(product.id);
    context.push('/product/${product.id}');
  }

  @override
  Widget build(BuildContext context) {
    final popularProductsAsync = ref.watch(popularProductsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section with light green background
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              decoration: const BoxDecoration(
                color: AppTheme.headerColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const Text(
                    'Home',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Subtitle with eco message
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Plastic takes 1000 yrs to decompose...',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Upcycling Process Card (matching the circular diagram in reference)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: AppTheme.lightGreen.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          // Circular Process Diagram
                          Container(
                            height: 120,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Center icon
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryGreen,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.recycling,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                // Process steps around the circle
                                Positioned(
                                  top: 10,
                                  child: _buildProcessStep('🎨', 'UpCycling'),
                                ),
                                Positioned(
                                  right: 10,
                                  child: _buildProcessStep('💡', 'Imagination'),
                                ),
                                Positioned(
                                  bottom: 10,
                                  child: _buildProcessStep('🌱', 'Green Impact'),
                                ),
                                Positioned(
                                  left: 10,
                                  child: _buildProcessStep('♻️', 'Recycle'),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Dots indicator
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(3, (index) => Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: index == 0 ? AppTheme.primaryGreen : Colors.grey[300],
                              ),
                            )),
                          ),
                        ],
                      ),
                    ),

                    // Most Upcycled Waste Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Most Upcycled Waste',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        Icon(
                          Icons.help_outline,
                          color: AppTheme.textSecondary,
                          size: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Waste Categories Grid (2x2)
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: _wasteCategories.length > 4 ? 4 : _wasteCategories.length,
                      itemBuilder: (context, index) {
                        return WasteCategoryCard(
                          category: _wasteCategories[index],
                          onTap: () => _onCategoryTap(_wasteCategories[index]),
                        );
                      },
                    ),

                    const SizedBox(height: 32),

                    // Featured Greenites Section
                    const Text(
                      'Featured Greenites',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Greenites Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildGreeniteCard('Sales\nCaptain', 'assets/images/Suryasen.png'),
                        _buildGreeniteCard('Events\nCaptain', 'assets/images/Ashi.png'),
                        _buildGreeniteCard('Volunteer\nCaptain', 'assets/images/Garry.png'),
                        _buildGreeniteCard('Leaderboard', 'assets/images/Meghana.png'),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Popular Products Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Popular Products',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        Icon(
                          Icons.help_outline,
                          color: AppTheme.textSecondary,
                          size: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Popular Products Grid (2x2)
                    popularProductsAsync.when(
                      data: (products) {
                        final displayProducts = products.isEmpty
                            ? ProductService.getSampleProducts()
                            : products;

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: displayProducts.length > 4 ? 4 : displayProducts.length,
                          itemBuilder: (context, index) {
                            return PopularProductCard(
                              product: displayProducts[index],
                              onTap: () => _onProductTap(displayProducts[index]),
                            );
                          },
                        );
                      },
                      loading: () => const SizedBox(
                        height: 200,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      error: (error, stack) {
                        final sampleProducts = ProductService.getSampleProducts();
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: sampleProducts.length > 4 ? 4 : sampleProducts.length,
                          itemBuilder: (context, index) {
                            return PopularProductCard(
                              product: sampleProducts[index],
                              onTap: () => _onProductTap(sampleProducts[index]),
                            );
                          },
                        );
                      },
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

  Widget _buildProcessStep(String emoji, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildGreeniteCard(String name, String imagePath) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.primaryGreen,
              width: 3,
            ),
          ),
          child: CircleAvatar(
            radius: 27,
            backgroundColor: Colors.grey[200],
            backgroundImage: AssetImage(imagePath),
            onBackgroundImageError: (exception, stackTrace) {},
            child: const Icon(
              Icons.person,
              size: 30,
              color: AppTheme.textSecondary,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
