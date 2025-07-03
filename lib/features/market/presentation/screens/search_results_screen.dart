import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/product_model.dart';

class SearchResultsScreen extends ConsumerStatefulWidget {
  final String query;

  const SearchResultsScreen({
    super.key,
    required this.query,
  });

  @override
  ConsumerState<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends ConsumerState<SearchResultsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ProductModel> _searchResults = [];
  bool _isLoading = false;
  String _sortBy = 'relevance';
  List<String> _selectedCategories = [];

  final List<String> _categories = [
    'Home Decor',
    'Garden',
    'Furniture',
    'Art',
    'Storage',
    'Lighting',
  ];

  final List<String> _sortOptions = [
    'relevance',
    'price_low',
    'price_high',
    'newest',
    'rating',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.query;
    _performSearch(widget.query);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      // Simulate API call with mock data
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Mock search results based on query
      _searchResults = _generateMockResults(query);
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Search failed: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  List<ProductModel> _generateMockResults(String query) {
    // Mock data generation based on search query
    final mockProducts = [
      ProductModel(
        id: 'search_1',
        name: 'Upcycled Bird Feeder',
        description: 'Beautiful bird feeder made from recycled plastic bottles',
        price: 25.99,
        category: 'Garden',
        imageUrls: ['assets/images/products/bird_feeder.jpg'],
        sellerId: 'seller1',
        sellerName: 'EcoArt Studio',
        isAvailable: true,
        stockQuantity: 15,
        rating: 4.8,
        reviewCount: 24,
        tags: ['upcycled', 'garden', 'bird', 'feeder'],
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        updatedAt: DateTime.now(),
        stats: ProductStats(views: 150, favorites: 45),
      ),
      ProductModel(
        id: 'search_2',
        name: 'Recycled Pen Stand',
        description: 'Stylish pen organizer made from old magazines',
        price: 15.50,
        category: 'Storage',
        imageUrls: ['assets/images/products/pen_stand.jpg'],
        sellerId: 'seller2',
        sellerName: 'Green Crafts Co.',
        isAvailable: true,
        stockQuantity: 8,
        rating: 4.5,
        reviewCount: 18,
        tags: ['recycled', 'office', 'storage', 'organizer'],
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now(),
        stats: ProductStats(views: 89, favorites: 23),
      ),
      ProductModel(
        id: 'search_3',
        name: 'Vertical Garden Planter',
        description: 'Space-saving planter made from repurposed wood',
        price: 45.00,
        category: 'Garden',
        imageUrls: ['assets/images/products/vertical_planter.jpg'],
        sellerId: 'seller3',
        sellerName: 'Urban Garden Solutions',
        isAvailable: true,
        stockQuantity: 12,
        rating: 4.9,
        reviewCount: 31,
        tags: ['garden', 'planter', 'vertical', 'wood'],
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now(),
        stats: ProductStats(views: 203, favorites: 67),
      ),
    ];

    // Filter based on query (simple contains check)
    return mockProducts.where((product) {
      final searchTerm = query.toLowerCase();
      return product.name.toLowerCase().contains(searchTerm) ||
             product.description.toLowerCase().contains(searchTerm) ||
             product.tags.any((tag) => tag.toLowerCase().contains(searchTerm));
    }).toList();
  }

  void _applyFilters() {
    // Apply sorting and filtering
    List<ProductModel> filtered = List.from(_searchResults);

    // Filter by categories
    if (_selectedCategories.isNotEmpty) {
      filtered = filtered.where((product) => 
        _selectedCategories.contains(product.category)).toList();
    }

    // Sort results
    switch (_sortBy) {
      case 'price_low':
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'newest':
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'rating':
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      default: // relevance
        // Keep original order for relevance
        break;
    }

    setState(() {
      _searchResults = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Search Results'),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onSubmitted: (value) {
                _performSearch(value);
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Info and Filters
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_searchResults.length} results for "${widget.query}"',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.filter_list),
                          onPressed: _showFilterDialog,
                        ),
                        IconButton(
                          icon: const Icon(Icons.sort),
                          onPressed: _showSortDialog,
                        ),
                      ],
                    ),
                  ],
                ),
                
                // Active filters
                if (_selectedCategories.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _selectedCategories.map((category) {
                      return Chip(
                        label: Text(category),
                        onDeleted: () {
                          setState(() {
                            _selectedCategories.remove(category);
                          });
                          _applyFilters();
                        },
                        backgroundColor: AppTheme.primaryGreen.withValues(alpha: 0.1),
                        labelStyle: TextStyle(color: AppTheme.primaryGreen),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
          
          // Search Results
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _searchResults.isEmpty
                    ? _buildEmptyState()
                    : _buildResultsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: AppTheme.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _selectedCategories.clear();
                _sortBy = 'relevance';
              });
              _performSearch(widget.query);
            },
            child: const Text('Clear Filters'),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final product = _searchResults[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductCard(ProductModel product) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          context.push('/product/${product.id}');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Product Image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppTheme.surfaceColor,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    product.imageUrls.first,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.eco,
                        color: AppTheme.primaryGreen,
                        size: 40,
                      );
                    },
                  ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Product Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${product.rating} (${product.reviewCount})',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const Spacer(),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.primaryGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter by Category'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _categories.map((category) {
              return CheckboxListTile(
                title: Text(category),
                value: _selectedCategories.contains(category),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      _selectedCategories.add(category);
                    } else {
                      _selectedCategories.remove(category);
                    }
                  });
                },
                activeColor: AppTheme.primaryGreen,
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _applyFilters();
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sort by'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Relevance'),
              value: 'relevance',
              groupValue: _sortBy,
              onChanged: (value) => setState(() => _sortBy = value!),
              activeColor: AppTheme.primaryGreen,
            ),
            RadioListTile<String>(
              title: const Text('Price: Low to High'),
              value: 'price_low',
              groupValue: _sortBy,
              onChanged: (value) => setState(() => _sortBy = value!),
              activeColor: AppTheme.primaryGreen,
            ),
            RadioListTile<String>(
              title: const Text('Price: High to Low'),
              value: 'price_high',
              groupValue: _sortBy,
              onChanged: (value) => setState(() => _sortBy = value!),
              activeColor: AppTheme.primaryGreen,
            ),
            RadioListTile<String>(
              title: const Text('Newest First'),
              value: 'newest',
              groupValue: _sortBy,
              onChanged: (value) => setState(() => _sortBy = value!),
              activeColor: AppTheme.primaryGreen,
            ),
            RadioListTile<String>(
              title: const Text('Highest Rated'),
              value: 'rating',
              groupValue: _sortBy,
              onChanged: (value) => setState(() => _sortBy = value!),
              activeColor: AppTheme.primaryGreen,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _applyFilters();
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}
