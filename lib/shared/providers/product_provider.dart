import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';
import '../../core/services/firebase_service.dart';

// Products stream provider
final productsProvider = StreamProvider<List<ProductModel>>((ref) {
  return FirebaseService.firestore
      .collection('products')
      .where('isAvailable', isEqualTo: true)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList());
});

// Popular products provider
final popularProductsProvider = StreamProvider<List<ProductModel>>((ref) {
  return FirebaseService.firestore
      .collection('products')
      .where('isAvailable', isEqualTo: true)
      .orderBy('rating', descending: true)
      .limit(10)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList());
});

// Products by category provider
final productsByCategoryProvider = StreamProvider.family<List<ProductModel>, String>((ref, category) {
  return FirebaseService.firestore
      .collection('products')
      .where('category', isEqualTo: category)
      .where('isAvailable', isEqualTo: true)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList());
});

// Product search provider
final productSearchProvider = StateNotifierProvider<ProductSearchNotifier, AsyncValue<List<ProductModel>>>((ref) {
  return ProductSearchNotifier();
});

class ProductSearchNotifier extends StateNotifier<AsyncValue<List<ProductModel>>> {
  ProductSearchNotifier() : super(const AsyncValue.data([]));

  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }

    state = const AsyncValue.loading();
    try {
      final snapshot = await FirebaseService.firestore
          .collection('products')
          .where('isAvailable', isEqualTo: true)
          .get();

      final products = snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()) ||
              product.description.toLowerCase().contains(query.toLowerCase()) ||
              product.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase())))
          .toList();

      state = AsyncValue.data(products);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  void clearSearch() {
    state = const AsyncValue.data([]);
  }
}

// Product service provider
final productServiceProvider = Provider<ProductService>((ref) {
  return ProductService();
});

class ProductService {
  // Get sample products for development
  static List<ProductModel> getSampleProducts() {
    final now = DateTime.now();
    return [
      ProductModel(
        id: 'product1',
        name: 'Upcycled Bag',
        description: 'Beautiful bag made from recycled materials',
        price: 500,
        category: 'Accessories',
        imageUrls: ['assets/images/bagpack.png'],
        sellerId: 'seller1',
        sellerName: 'EcoCraft Store',
        stockQuantity: 10,
        rating: 4.5,
        reviewCount: 23,
        tags: ['bag', 'recycled', 'eco-friendly'],
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now,
        stats: ProductStats(views: 156, orders: 23, revenue: 11500, favorites: 45),
      ),
      ProductModel(
        id: 'product2',
        name: 'Wooden Planter',
        description: 'Handcrafted planter from reclaimed wood',
        price: 750,
        category: 'Home Decor',
        imageUrls: ['assets/images/plantstand.png'],
        sellerId: 'seller2',
        sellerName: 'Green Crafters',
        stockQuantity: 5,
        rating: 4.8,
        reviewCount: 12,
        tags: ['planter', 'wood', 'garden'],
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now,
        stats: ProductStats(views: 89, orders: 12, revenue: 9000, favorites: 28),
      ),
      ProductModel(
        id: 'product3',
        name: 'Bird Feeder',
        description: 'Eco-friendly bird feeder from plastic bottles',
        price: 299,
        category: 'Home Decor',
        imageUrls: ['assets/images/bird-feeder.png'],
        sellerId: 'seller1',
        sellerName: 'EcoCraft Store',
        stockQuantity: 15,
        rating: 4.2,
        reviewCount: 34,
        tags: ['bird feeder', 'plastic', 'garden'],
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now,
        stats: ProductStats(views: 234, orders: 34, revenue: 10166, favorites: 67),
      ),
      ProductModel(
        id: 'product4',
        name: 'Desk Organizer',
        description: 'Multi-compartment desk organizer from cardboard',
        price: 450,
        category: 'Home Decor',
        imageUrls: ['assets/images/deskorganizer.png'],
        sellerId: 'seller3',
        sellerName: 'Upcycle Masters',
        stockQuantity: 8,
        rating: 4.6,
        reviewCount: 18,
        tags: ['organizer', 'desk', 'cardboard'],
        createdAt: now.subtract(const Duration(hours: 12)),
        updatedAt: now,
        stats: ProductStats(views: 123, orders: 18, revenue: 8100, favorites: 32),
      ),
    ];
  }

  // Add product to favorites
  Future<void> addToFavorites(String productId, String userId) async {
    try {
      await FirebaseService.firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(productId)
          .set({
        'productId': productId,
        'addedAt': Timestamp.now(),
      });

      // Update product favorites count
      await FirebaseService.firestore
          .collection('products')
          .doc(productId)
          .update({
        'stats.favorites': FieldValue.increment(1),
      });
    } catch (e) {
      throw Exception('Failed to add to favorites: $e');
    }
  }

  // Remove product from favorites
  Future<void> removeFromFavorites(String productId, String userId) async {
    try {
      await FirebaseService.firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(productId)
          .delete();

      // Update product favorites count
      await FirebaseService.firestore
          .collection('products')
          .doc(productId)
          .update({
        'stats.favorites': FieldValue.increment(-1),
      });
    } catch (e) {
      throw Exception('Failed to remove from favorites: $e');
    }
  }

  // Update product views
  Future<void> updateProductViews(String productId) async {
    try {
      await FirebaseService.firestore
          .collection('products')
          .doc(productId)
          .update({
        'stats.views': FieldValue.increment(1),
      });
    } catch (e) {
      // Silently fail for view updates
    }
  }

  // Create new product
  Future<void> createProduct(ProductModel product) async {
    try {
      await FirebaseService.firestore
          .collection('products')
          .doc(product.id)
          .set(product.toFirestore());
    } catch (e) {
      throw Exception('Failed to create product: $e');
    }
  }

  // Update product
  Future<void> updateProduct(ProductModel product) async {
    try {
      await FirebaseService.firestore
          .collection('products')
          .doc(product.id)
          .update(product.toFirestore());
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  // Delete product
  Future<void> deleteProduct(String productId) async {
    try {
      await FirebaseService.firestore
          .collection('products')
          .doc(productId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }
}
