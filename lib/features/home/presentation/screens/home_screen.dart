import 'package:flutter/foundation.dart';
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
import '../widgets/image_slider.dart';

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
                  // Header with logo and title
                  Row(
                    children: [
                      // EcoCura Logo
                      Container(
                        width: 60,
                        height: 60,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryGreen,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.eco,
                                  color: Colors.white,
                                  size: 36,
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      // Title
                      const Text(
                        'EcoCura',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Subtitle with eco message
                  Container(
                    width: double.infinity,
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
                      textAlign: TextAlign.center,
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
                    // FIXED: Add Image Slider at the top (matching original iOS app)
                    const ImageSlider(),
                    const SizedBox(height: 24),

                    // Upcycling Process Card (matching the circular diagram in reference)
                  

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

                    // Waste Categories Horizontal Scroll
                    SizedBox(
                      height: 140,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _wasteCategories.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: SizedBox(
                              width: 120,
                              child: WasteCategoryCard(
                                category: _wasteCategories[index],
                                onTap: () => _onCategoryTap(_wasteCategories[index]),
                              ),
                            ),
                          );
                        },
                      ),
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

                    // Popular Products Horizontal Scroll
                    popularProductsAsync.when(
                      data: (products) {
                        final displayProducts = products.isEmpty
                            ? ProductService.getSampleProducts()
                            : products;

                        return SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: displayProducts.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: SizedBox(
                                  width: 150,
                                  child: PopularProductCard(
                                    product: displayProducts[index],
                                    onTap: () => _onProductTap(displayProducts[index]),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                      loading: () => const SizedBox(
                        height: 200,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      error: (error, stack) {
                        final sampleProducts = ProductService.getSampleProducts();
                        return SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: sampleProducts.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: SizedBox(
                                  width: 150,
                                  child: PopularProductCard(
                                    product: sampleProducts[index],
                                    onTap: () => _onProductTap(sampleProducts[index]),
                                  ),
                                ),
                              );
                            },
                          ),
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
    return SizedBox(
      width: 50,
      child: Column(
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
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w500,
              color: AppTheme.textPrimary,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
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
