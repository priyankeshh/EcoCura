import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/providers/auth_provider.dart';
import '../../../../shared/models/user_model.dart';

class CoinsScreen extends ConsumerWidget {
  const CoinsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Coins'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: AppTheme.primaryGreen.withOpacity(0.05),
        ),
        child: currentUserAsync.when(
          data: (user) => _buildCoinsContent(context, user),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => _buildCoinsContent(context, null),
        ),
      ),
    );
  }

  Widget _buildCoinsContent(BuildContext context, UserModel? user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current Points Card
          _buildPointsCard(user),
          
          const SizedBox(height: 24),
          
          // Tier Progress
          _buildTierProgress(user),
          
          const SizedBox(height: 24),
          
          // Tier Benefits
          _buildTierBenefits(),
          
          const SizedBox(height: 24),
          
          // How to Earn Points
          _buildHowToEarn(),
          
          const SizedBox(height: 24),
          
          // Recent Transactions
          _buildRecentTransactions(),
        ],
      ),
    );
  }

  Widget _buildPointsCard(UserModel? user) {
    final points = user?.points ?? 0;
    final tier = user?.tier ?? UserTier.bronze;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryGreen,
            AppTheme.lightGreen,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGreen.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Points Display
          Text(
            points.toString(),
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Text(
            'EcoCoins',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Tier Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  tier.iconAsset,
                  width: 24,
                  height: 24,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.star,
                      size: 24,
                      color: Colors.white,
                    );
                  },
                ),
                const SizedBox(width: 8),
                Text(
                  '${tier.displayName} Member',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTierProgress(UserModel? user) {
    final currentPoints = user?.points ?? 0;
    final currentTier = user?.tier ?? UserTier.bronze;
    final nextTier = _getNextTier(currentTier);
    
    if (nextTier == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.emoji_events,
              color: AppTheme.primaryGreen,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Congratulations!',
                    style: AppTextStyles.heading3.copyWith(
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                  Text(
                    'You\'ve reached the highest tier!',
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final pointsNeeded = nextTier.pointsRequired - currentPoints;
    final progress = currentPoints / nextTier.pointsRequired;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          Text(
            'Progress to ${nextTier.displayName}',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 12),
          
          // Progress Bar
          LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryGreen),
            minHeight: 8,
          ),
          
          const SizedBox(height: 8),
          
          Text(
            '$pointsNeeded more points to reach ${nextTier.displayName}',
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildTierBenefits() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          Text(
            'Tier Benefits',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 16),
          
          ...UserTier.values.map((tier) => _buildTierBenefitItem(tier)),
        ],
      ),
    );
  }

  Widget _buildTierBenefitItem(UserTier tier) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Image.asset(
            tier.iconAsset,
            width: 24,
            height: 24,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.star,
                size: 24,
                color: AppTheme.primaryGreen,
              );
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tier.displayName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  tier.description,
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHowToEarn() {
    final earnMethods = [
      {'title': 'Complete Upcycling Projects', 'points': '+50 points'},
      {'title': 'Sell Products on Market', 'points': '+10 points per sale'},
      {'title': 'Share Social Posts', 'points': '+5 points'},
      {'title': 'Refer Friends', 'points': '+100 points'},
      {'title': 'Daily Login', 'points': '+2 points'},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          Text(
            'How to Earn Points',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 16),
          
          ...earnMethods.map((method) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Icon(
                  Icons.add_circle_outline,
                  color: AppTheme.primaryGreen,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    method['title']!,
                    style: AppTextStyles.bodyMedium,
                  ),
                ),
                Text(
                  method['points']!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppTheme.primaryGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions() {
    final transactions = [
      {'action': 'Completed Bird Feeder Project', 'points': '+50', 'date': '2 days ago'},
      {'action': 'Daily Login Bonus', 'points': '+2', 'date': '3 days ago'},
      {'action': 'Shared Post on Greenity', 'points': '+5', 'date': '1 week ago'},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          Text(
            'Recent Activity',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 16),
          
          ...transactions.map((transaction) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction['action']!,
                        style: AppTextStyles.bodyMedium,
                      ),
                      Text(
                        transaction['date']!,
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
                Text(
                  transaction['points']!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppTheme.primaryGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  UserTier? _getNextTier(UserTier currentTier) {
    switch (currentTier) {
      case UserTier.bronze:
        return UserTier.silver;
      case UserTier.silver:
        return UserTier.gold;
      case UserTier.gold:
        return null;
    }
  }
}
