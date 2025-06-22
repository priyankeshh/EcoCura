// import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final List<String> imageUrls;
  final String sellerId;
  final String sellerName;
  final bool isAvailable;
  final int stockQuantity;
  final double rating;
  final int reviewCount;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ProductStats stats;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrls,
    required this.sellerId,
    required this.sellerName,
    this.isAvailable = true,
    this.stockQuantity = 0,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.tags = const [],
    required this.createdAt,
    required this.updatedAt,
    required this.stats,
  });

  // Firebase integration temporarily disabled
  // factory ProductModel.fromFirestore(DocumentSnapshot doc) {
  //   final data = doc.data() as Map<String, dynamic>;
  //   return ProductModel(
  //     id: doc.id,
  //     name: data['name'] ?? '',
  //     description: data['description'] ?? '',
  //     price: (data['price'] ?? 0).toDouble(),
  //     category: data['category'] ?? '',
  //     imageUrls: List<String>.from(data['imageUrls'] ?? []),
  //     sellerId: data['sellerId'] ?? '',
  //     sellerName: data['sellerName'] ?? '',
  //     isAvailable: data['isAvailable'] ?? true,
  //     stockQuantity: data['stockQuantity'] ?? 0,
  //     rating: (data['rating'] ?? 0).toDouble(),
  //     reviewCount: data['reviewCount'] ?? 0,
  //     tags: List<String>.from(data['tags'] ?? []),
  //     createdAt: (data['createdAt'] as Timestamp).toDate(),
  //     updatedAt: (data['updatedAt'] as Timestamp).toDate(),
  //     stats: ProductStats.fromMap(data['stats'] ?? {}),
  //   );
  // }

  // Firebase integration temporarily disabled
  // Map<String, dynamic> toFirestore() {
  //   return {
  //     'name': name,
  //     'description': description,
  //     'price': price,
  //     'category': category,
  //     'imageUrls': imageUrls,
  //     'sellerId': sellerId,
  //     'sellerName': sellerName,
  //     'isAvailable': isAvailable,
  //     'stockQuantity': stockQuantity,
  //     'rating': rating,
  //     'reviewCount': reviewCount,
  //     'tags': tags,
  //     'createdAt': Timestamp.fromDate(createdAt),
  //     'updatedAt': Timestamp.fromDate(updatedAt),
  //     'stats': stats.toMap(),
  //   };
  // }

  ProductModel copyWith({
    String? name,
    String? description,
    double? price,
    String? category,
    List<String>? imageUrls,
    bool? isAvailable,
    int? stockQuantity,
    double? rating,
    int? reviewCount,
    List<String>? tags,
    DateTime? updatedAt,
    ProductStats? stats,
  }) {
    return ProductModel(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      imageUrls: imageUrls ?? this.imageUrls,
      sellerId: sellerId,
      sellerName: sellerName,
      isAvailable: isAvailable ?? this.isAvailable,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      tags: tags ?? this.tags,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      stats: stats ?? this.stats,
    );
  }
}

class ProductStats {
  final int views;
  final int orders;
  final double revenue;
  final int favorites;

  ProductStats({
    this.views = 0,
    this.orders = 0,
    this.revenue = 0.0,
    this.favorites = 0,
  });

  factory ProductStats.fromMap(Map<String, dynamic> map) {
    return ProductStats(
      views: map['views'] ?? 0,
      orders: map['orders'] ?? 0,
      revenue: (map['revenue'] ?? 0).toDouble(),
      favorites: map['favorites'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'views': views,
      'orders': orders,
      'revenue': revenue,
      'favorites': favorites,
    };
  }

  ProductStats copyWith({
    int? views,
    int? orders,
    double? revenue,
    int? favorites,
  }) {
    return ProductStats(
      views: views ?? this.views,
      orders: orders ?? this.orders,
      revenue: revenue ?? this.revenue,
      favorites: favorites ?? this.favorites,
    );
  }
}

enum ProductCategory {
  homeDecor('Home Decor'),
  travel('Travel'),
  toys('Toys'),
  gifting('Gifting'),
  furniture('Furniture'),
  accessories('Accessories'),
  clothing('Clothing'),
  electronics('Electronics');

  const ProductCategory(this.displayName);
  final String displayName;

  static ProductCategory fromString(String value) {
    return ProductCategory.values.firstWhere(
      (category) => category.displayName.toLowerCase() == value.toLowerCase(),
      orElse: () => ProductCategory.homeDecor,
    );
  }
}

enum PriceRange {
  under199('Under ₹199', 0, 199),
  under299('Under ₹299', 200, 299),
  under499('Under ₹499', 300, 499),
  under999('Under ₹999', 500, 999),
  above999('Above ₹999', 1000, double.infinity);

  const PriceRange(this.displayName, this.min, this.max);
  final String displayName;
  final double min;
  final double max;

  bool contains(double price) {
    return price >= min && price <= max;
  }
}
