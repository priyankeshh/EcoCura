import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/custom_search_bar.dart';
import '../../../../shared/models/waste_category_model.dart';
import '../../../../shared/models/product_model.dart';
import '../../../../shared/providers/product_provider.dart';
import '../widgets/image_slider.dart';
import '../widgets/waste_category_card.dart';
import '../widgets/featured_greenite_card.dart';
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
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            CustomSearchBar(
              controller: _searchController,
              hintText: 'Search for products, categories...',
              onSubmitted: _onSearchSubmitted,
            ),

            const SizedBox(height: 16),

            // Image Slider
            const ImageSlider(),

            const SizedBox(height: 24),

            // Most Upcycled Waste Section
            Text(
              'Most Upcycled Waste',
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: 12),

            SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _wasteCategories.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: WasteCategoryCard(
                      category: _wasteCategories[index],
                      onTap: () => _onCategoryTap(_wasteCategories[index]),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Featured Greenites Section
            Text(
              'Featured Greenites',
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: 12),

            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder: (context, index) {
                  final greenites = [
                    {'name': 'Sales Captain', 'image': 'assets/images/Suryasen.png'},
                    {'name': 'Eco Warrior', 'image': 'assets/images/Ashi.png'},
                    {'name': 'Green Leader', 'image': 'assets/images/Garry.png'},
                    {'name': 'Sustainability Expert', 'image': 'assets/images/Meghana.png'},
                  ];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: FeaturedGreeniteCard(
                      name: greenites[index]['name'],
                      imagePath: greenites[index]['image'],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Popular Products Section
            Text(
              'Popular Products',
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: 12),

            popularProductsAsync.when(
              data: (products) {
                if (products.isEmpty) {
                  // Show sample products if no data from Firebase
                  final sampleProducts = ProductService.getSampleProducts();
                  return SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: sampleProducts.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: PopularProductCard(
                            product: sampleProducts[index],
                            onTap: () => _onProductTap(sampleProducts[index]),
                          ),
                        );
                      },
                    ),
                  );
                }

                return SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: PopularProductCard(
                          product: products[index],
                          onTap: () => _onProductTap(products[index]),
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
                // Show sample products on error
                final sampleProducts = ProductService.getSampleProducts();
                return SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: sampleProducts.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: PopularProductCard(
                          product: sampleProducts[index],
                          onTap: () => _onProductTap(sampleProducts[index]),
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
    );
  }
}
