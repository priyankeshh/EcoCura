import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/providers/auth_provider.dart';
import '../../../../shared/models/user_model.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F8F5), // Light green background like in the design
      body: SafeArea(
        child: currentUserAsync.when(
          data: (user) => _buildProfileContent(user),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => _buildProfileContent(null),
        ),
      ),
    );
  }

  Widget _buildProfileContent(UserModel? user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // App Title
          const SizedBox(height: 20),
          const Text(
            'Profile',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 40),

          // Profile Picture with green border
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF4CAF50), // Green border
                width: 4,
              ),
            ),
            child: Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFFF9800), // Orange inner border
                  width: 3,
                ),
              ),
              child: CircleAvatar(
                radius: 53,
                backgroundColor: const Color(0xFFFFE0B2), // Light orange background
                backgroundImage: user?.profileImageUrl != null
                    ? NetworkImage(user!.profileImageUrl!)
                    : null,
                child: user?.profileImageUrl == null
                    ? const Icon(
                        Icons.person,
                        size: 60,
                        color: Color(0xFF8D6E63), // Brown icon
                      )
                    : null,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Greeting
          Text(
            'Hi ${user?.name ?? 'Gracy'}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 32),

          // Action Buttons Grid (2x2)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildGreenButton('My Orders', () {
                context.push('/orders');
              }),
              _buildGreenButton('My Store', () {
                context.push('/my-store');
              }),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildGreenButton('Wishlist', () {
                context.push('/wishlist');
              }),
              _buildGreenButton('Help Center', () {
                context.push('/help');
              }),
            ],
          ),

          const SizedBox(height: 40),

          // Profile Options List
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildListOption('Edit Profile', Icons.arrow_forward_ios, () {
                  context.push('/edit-profile');
                }),
                _buildDivider(),
                _buildListOption('Saved Addresses', Icons.arrow_forward_ios, () {
                  context.push('/addresses');
                }),
                _buildDivider(),
                _buildListOption('Payment Options', Icons.arrow_forward_ios, () {
                  context.push('/payment');
                }),
                _buildDivider(),
                _buildListOption('Select Language', Icons.arrow_forward_ios, () {
                  context.push('/language');
                }),
                _buildDivider(),
                _buildListOption('Accessibility', Icons.arrow_forward_ios, () {
                  context.push('/accessibility');
                }),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Logout Button
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 40),
            child: ElevatedButton(
              onPressed: _showLogoutDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildGreenButton(String title, VoidCallback onPressed) {
    return Container(
      width: 140,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8BC34A), // Light green
          foregroundColor: const Color(0xFF2E7D32), // Dark green text
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildListOption(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      trailing: Icon(
        icon,
        size: 18,
        color: Colors.grey[600],
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey[200],
      indent: 20,
      endIndent: 20,
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _handleLogout();
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  void _handleLogout() async {
    try {
      await ref.read(authNotifierProvider.notifier).signOut();
      if (mounted) {
        context.go('/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error logging out: $e')),
        );
      }
    }
  }
}
