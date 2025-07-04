import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';

enum OrderStatus { pending, confirmed, shipped, delivered, cancelled }

class OrderModel {
  final String id;
  final String productName;
  final String productImage;
  final double price;
  final int quantity;
  final OrderStatus status;
  final DateTime orderDate;
  final DateTime? deliveryDate;
  final String sellerName;

  OrderModel({
    required this.id,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
    required this.status,
    required this.orderDate,
    this.deliveryDate,
    required this.sellerName,
  });
}

class MyOrdersScreen extends ConsumerStatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  ConsumerState<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends ConsumerState<MyOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock data for demonstration
  final List<OrderModel> _mockOrders = [
    OrderModel(
      id: 'ORD001',
      productName: 'Upcycled Bird Feeder',
      productImage: 'assets/images/products/bird_feeder.jpg',
      price: 25.99,
      quantity: 1,
      status: OrderStatus.delivered,
      orderDate: DateTime.now().subtract(const Duration(days: 7)),
      deliveryDate: DateTime.now().subtract(const Duration(days: 2)),
      sellerName: 'EcoArt Studio',
    ),
    OrderModel(
      id: 'ORD002',
      productName: 'Recycled Pen Stand',
      productImage: 'assets/images/products/pen_stand.jpg',
      price: 15.50,
      quantity: 2,
      status: OrderStatus.shipped,
      orderDate: DateTime.now().subtract(const Duration(days: 3)),
      sellerName: 'Green Crafts Co.',
    ),
    OrderModel(
      id: 'ORD003',
      productName: 'Vertical Garden Planter',
      productImage: 'assets/images/products/vertical_planter.jpg',
      price: 45.00,
      quantity: 1,
      status: OrderStatus.confirmed,
      orderDate: DateTime.now().subtract(const Duration(days: 1)),
      sellerName: 'Urban Garden Solutions',
    ),
    OrderModel(
      id: 'ORD004',
      productName: 'Eco-friendly Tote Bag',
      productImage: 'assets/images/products/tote_bag.jpg',
      price: 12.99,
      quantity: 3,
      status: OrderStatus.pending,
      orderDate: DateTime.now(),
      sellerName: 'Sustainable Style',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<OrderModel> _getOrdersByStatus(List<OrderStatus> statuses) {
    return _mockOrders.where((order) => statuses.contains(order.status)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Delivered'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrdersList(_getOrdersByStatus([
            OrderStatus.pending,
            OrderStatus.confirmed,
            OrderStatus.shipped,
          ])),
          _buildOrdersList(_getOrdersByStatus([OrderStatus.delivered])),
          _buildOrdersList(_getOrdersByStatus([OrderStatus.cancelled])),
        ],
      ),
    );
  }

  Widget _buildOrdersList(List<OrderModel> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 80,
              color: AppTheme.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'No orders found',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start shopping to see your orders here',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(order);
      },
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order.id}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                _buildStatusChip(order.status),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Product Info
            Row(
              children: [
                // Product Image
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppTheme.surfaceColor,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      order.productImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.eco,
                          color: AppTheme.primaryGreen,
                          size: 30,
                        );
                      },
                    ),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Product Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.productName,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Sold by ${order.sellerName}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Qty: ${order.quantity}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Price
                Text(
                  '\$${(order.price * order.quantity).toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.primaryGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Order Date
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  'Ordered on ${_formatDate(order.orderDate)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            
            // Delivery Date (if delivered)
            if (order.deliveryDate != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.local_shipping,
                    size: 16,
                    color: AppTheme.successColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Delivered on ${_formatDate(order.deliveryDate!)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.successColor,
                    ),
                  ),
                ],
              ),
            ],
            
            const SizedBox(height: 16),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _showOrderDetails(order);
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppTheme.primaryGreen),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'View Details',
                      style: TextStyle(color: AppTheme.primaryGreen),
                    ),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                if (order.status == OrderStatus.delivered) ...[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _showReorderDialog(order);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Reorder',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ] else if (order.status == OrderStatus.pending) ...[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _showCancelDialog(order);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.errorColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(OrderStatus status) {
    Color backgroundColor;
    Color textColor;
    String text;

    switch (status) {
      case OrderStatus.pending:
        backgroundColor = Colors.orange.withValues(alpha: 0.1);
        textColor = Colors.orange;
        text = 'Pending';
        break;
      case OrderStatus.confirmed:
        backgroundColor = Colors.blue.withValues(alpha: 0.1);
        textColor = Colors.blue;
        text = 'Confirmed';
        break;
      case OrderStatus.shipped:
        backgroundColor = AppTheme.primaryGreen.withValues(alpha: 0.1);
        textColor = AppTheme.primaryGreen;
        text = 'Shipped';
        break;
      case OrderStatus.delivered:
        backgroundColor = AppTheme.successColor.withValues(alpha: 0.1);
        textColor = AppTheme.successColor;
        text = 'Delivered';
        break;
      case OrderStatus.cancelled:
        backgroundColor = AppTheme.errorColor.withValues(alpha: 0.1);
        textColor = AppTheme.errorColor;
        text = 'Cancelled';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showOrderDetails(OrderModel order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order Details',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text('Order ID: ${order.id}'),
              Text('Product: ${order.productName}'),
              Text('Seller: ${order.sellerName}'),
              Text('Price: \$${order.price.toStringAsFixed(2)}'),
              Text('Quantity: ${order.quantity}'),
              Text('Total: \$${(order.price * order.quantity).toStringAsFixed(2)}'),
              Text('Status: ${order.status.name}'),
              Text('Order Date: ${_formatDate(order.orderDate)}'),
              if (order.deliveryDate != null)
                Text('Delivery Date: ${_formatDate(order.deliveryDate!)}'),
            ],
          ),
        ),
      ),
    );
  }

  void _showReorderDialog(OrderModel order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reorder Item'),
        content: Text('Would you like to reorder "${order.productName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Item added to cart!')),
              );
            },
            child: const Text('Add to Cart'),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(OrderModel order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Order'),
        content: Text('Are you sure you want to cancel order #${order.id}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Order cancelled successfully')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorColor),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }
}
