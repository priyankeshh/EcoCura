import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/providers/auth_provider.dart';
import '../../../../shared/widgets/theme_toggle_widget.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _darkModeEnabled = false;
  bool _locationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Section
            _buildSectionHeader('Account'),
            _buildSettingsTile(
              icon: Icons.person_outlined,
              title: 'Edit Profile',
              subtitle: 'Update your personal information',
              onTap: () => context.push('/edit-profile'),
            ),
            _buildSettingsTile(
              icon: Icons.lock_outlined,
              title: 'Change Password',
              subtitle: 'Update your account password',
              onTap: () => _showComingSoon('Change Password'),
            ),
            _buildSettingsTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Settings',
              subtitle: 'Manage your privacy preferences',
              onTap: () => _showComingSoon('Privacy Settings'),
            ),
            
            const SizedBox(height: 24),
            
            // Notifications Section
            _buildSectionHeader('Notifications'),
            _buildSwitchTile(
              icon: Icons.notifications_outlined,
              title: 'Enable Notifications',
              subtitle: 'Receive app notifications',
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() => _notificationsEnabled = value);
              },
            ),
            _buildSwitchTile(
              icon: Icons.email_outlined,
              title: 'Email Notifications',
              subtitle: 'Receive notifications via email',
              value: _emailNotifications,
              onChanged: (value) {
                setState(() => _emailNotifications = value);
              },
            ),
            _buildSwitchTile(
              icon: Icons.phone_android_outlined,
              title: 'Push Notifications',
              subtitle: 'Receive push notifications',
              value: _pushNotifications,
              onChanged: (value) {
                setState(() => _pushNotifications = value);
              },
            ),
            
            const SizedBox(height: 24),
            
            // App Preferences Section
            _buildSectionHeader('App Preferences'),
            const ThemeToggleWidget(),
            _buildSwitchTile(
              icon: Icons.location_on_outlined,
              title: 'Location Services',
              subtitle: 'Allow location access for better experience',
              value: _locationEnabled,
              onChanged: (value) {
                setState(() => _locationEnabled = value);
              },
            ),
            
            const SizedBox(height: 24),
            
            // Support Section
            _buildSectionHeader('Support & Info'),
            _buildSettingsTile(
              icon: Icons.help_outline,
              title: 'Help & Support',
              subtitle: 'Get help and contact support',
              onTap: () => _showComingSoon('Help & Support'),
            ),
            _buildSettingsTile(
              icon: Icons.info_outline,
              title: 'About EcoCura',
              subtitle: 'App version and information',
              onTap: () => _showAboutDialog(),
            ),
            _buildSettingsTile(
              icon: Icons.description_outlined,
              title: 'Terms & Conditions',
              subtitle: 'Read our terms and conditions',
              onTap: () => _showComingSoon('Terms & Conditions'),
            ),
            _buildSettingsTile(
              icon: Icons.policy_outlined,
              title: 'Privacy Policy',
              subtitle: 'Read our privacy policy',
              onTap: () => _showComingSoon('Privacy Policy'),
            ),
            
            const SizedBox(height: 32),
            
            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _showLogoutDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.errorColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Sign Out',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppTheme.primaryGreen,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.primaryGreen.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryGreen,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 12,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppTheme.textSecondary,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        secondary: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.primaryGreen.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryGreen,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 12,
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.primaryGreen,
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature feature coming soon!'),
        backgroundColor: AppTheme.primaryGreen,
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'EcoCura',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: AppTheme.primaryGreen,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.eco,
          color: Colors.white,
          size: 30,
        ),
      ),
      children: [
        const Text(
          'EcoCura is your sustainable upcycling companion, helping you turn waste into wonderful creations while building a greener future.',
        ),
        const SizedBox(height: 16),
        Text(
          'Made with 💚 for the environment',
          style: TextStyle(
            color: AppTheme.primaryGreen,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref.read(authNotifierProvider.notifier).signOut();
                if (mounted) {
                  context.go('/login');
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error signing out: $e')),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text(
              'Sign Out',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
