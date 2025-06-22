import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? profileImageUrl;
  final UserTier tier;
  final int points;
  final int pointsToNextTier;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isStoreOwner;
  final String? storeId;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
    required this.tier,
    required this.points,
    required this.pointsToNextTier,
    required this.createdAt,
    required this.updatedAt,
    this.isStoreOwner = false,
    this.storeId,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      profileImageUrl: data['profileImageUrl'],
      tier: UserTier.values.firstWhere(
        (t) => t.name == data['tier'],
        orElse: () => UserTier.bronze,
      ),
      points: data['points'] ?? 0,
      pointsToNextTier: data['pointsToNextTier'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      isStoreOwner: data['isStoreOwner'] ?? false,
      storeId: data['storeId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'tier': tier.name,
      'points': points,
      'pointsToNextTier': pointsToNextTier,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isStoreOwner': isStoreOwner,
      'storeId': storeId,
    };
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? profileImageUrl,
    UserTier? tier,
    int? points,
    int? pointsToNextTier,
    DateTime? updatedAt,
    bool? isStoreOwner,
    String? storeId,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      tier: tier ?? this.tier,
      points: points ?? this.points,
      pointsToNextTier: pointsToNextTier ?? this.pointsToNextTier,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isStoreOwner: isStoreOwner ?? this.isStoreOwner,
      storeId: storeId ?? this.storeId,
    );
  }
}

enum UserTier {
  bronze,
  silver,
  gold;

  String get displayName {
    switch (this) {
      case UserTier.bronze:
        return 'Bronze';
      case UserTier.silver:
        return 'Silver';
      case UserTier.gold:
        return 'Gold';
    }
  }

  String get description {
    switch (this) {
      case UserTier.bronze:
        return 'Earning 5 points per 100rs';
      case UserTier.silver:
        return 'Earning 7 points per 100rs';
      case UserTier.gold:
        return 'Earning 10 points per 100rs';
    }
  }

  String get iconAsset {
    switch (this) {
      case UserTier.bronze:
        return 'assets/images/bronze-medal.png';
      case UserTier.silver:
        return 'assets/images/silver-medal.png';
      case UserTier.gold:
        return 'assets/images/gold-medal.png';
    }
  }

  int get pointsRequired {
    switch (this) {
      case UserTier.bronze:
        return 0;
      case UserTier.silver:
        return 500;
      case UserTier.gold:
        return 1500;
    }
  }
}
