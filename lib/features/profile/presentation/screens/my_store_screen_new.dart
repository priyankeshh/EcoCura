import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyStoreScreen extends ConsumerStatefulWidget {
  const MyStoreScreen({super.key});

  @override
  ConsumerState<MyStoreScreen> createState() => _MyStoreScreenState();
}

class _MyStoreScreenState extends ConsumerState<MyStoreScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F8F5), // Light green background
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and title
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xFF4CAF50),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'My Store',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Second Life Crafter',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 40), // Balance the back button
                ],
              ),
            ),

            // Navigation tabs
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavTab('Home', 0, true),
                  _buildNavTab('Messages', 1, false),
                  _buildNavTab('Orders', 2, false),
                  _buildNavTab('Listings', 3, false),
                  _buildNavTab('More', 4, false),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Statistics section
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Statistics header
                    const Text(
                      'Your Shop Statistics',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    
                    const SizedBox(height: 16),

                    // Time period filters
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildPeriodTab('Today', true),
                          _buildPeriodTab('Last 7 days', false),
                          _buildPeriodTab('This month', false),
                          _buildPeriodTab('This year', false),
                          _buildPeriodTab('All time', false),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Statistics cards
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildStatRow('Views', '3461', true),
                          _buildStatRow('Orders', '26', false),
                          _buildStatRow('Returns', '1', false),
                          _buildStatRow('Visits', '1365', false),
                          _buildStatRow('Revenue', '\$1,170', false),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Popular Listing section
                    const Text(
                      'Popular Listing',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Popular listing card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Product image
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: const Color(0xFFFFE0B2),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                'assets/images/bird_feeder.jpg', // You'll need to add this image
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.eco,
                                    color: Color(0xFF8D6E63),
                                    size: 30,
                                  );
                                },
                              ),
                            ),
                          ),

                          const SizedBox(width: 16),

                          // Product details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Bird Feeder',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    _buildMetric('Views', '996'),
                                    const SizedBox(width: 24),
                                    _buildMetric('Orders', '10'),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    _buildMetric('Revenue', '\$450'),
                                    const SizedBox(width: 24),
                                    _buildMetric('Favourites', '45'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavTab(String title, int index, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF4CAF50) : const Color(0xFFE8F5E8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getTabIcon(title),
            size: 20,
            color: isSelected ? Colors.white : const Color(0xFF4CAF50),
          ),
          if (title != 'More') ...[
            const SizedBox(width: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF4CAF50),
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getTabIcon(String title) {
    switch (title) {
      case 'Home':
        return Icons.home;
      case 'Messages':
        return Icons.chat_bubble_outline;
      case 'Orders':
        return Icons.receipt_long;
      case 'Listings':
        return Icons.grid_view;
      case 'More':
        return Icons.more_horiz;
      default:
        return Icons.home;
    }
  }

  Widget _buildPeriodTab(String period, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF4CAF50) : const Color(0xFFE8F5E8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        period,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isSelected ? Colors.white : const Color(0xFF4CAF50),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, bool isFirst) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: isFirst ? null : const Border(
          top: BorderSide(color: Color(0xFFF0F0F0), width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward,
                  size: 16,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.access_time,
                  size: 12,
                  color: Color(0xFF4CAF50),
                ),
                SizedBox(width: 4),
                Text(
                  'Just now',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF4CAF50),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
