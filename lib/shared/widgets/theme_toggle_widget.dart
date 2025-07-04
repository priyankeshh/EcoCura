import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../providers/theme_provider.dart';

class ThemeToggleWidget extends ConsumerWidget {
  final bool showLabel;
  final bool isCompact;

  const ThemeToggleWidget({
    super.key,
    this.showLabel = true,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final themeModeNotifier = ref.read(themeModeProvider.notifier);

    if (isCompact) {
      return IconButton(
        icon: Icon(themeModeNotifier.themeModeIcon),
        onPressed: () => _showThemeDialog(context, ref),
        tooltip: 'Change theme',
      );
    }

    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.primaryGreen.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          themeModeNotifier.themeModeIcon,
          color: AppTheme.primaryGreen,
          size: 20,
        ),
      ),
      title: showLabel ? const Text('Theme') : null,
      subtitle: showLabel ? Text(themeModeNotifier.themeModeString) : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => _showThemeDialog(context, ref),
    );
  }

  void _showThemeDialog(BuildContext context, WidgetRef ref) {
    final themeModeNotifier = ref.read(themeModeProvider.notifier);
    final currentTheme = ref.read(themeModeProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildThemeOption(
              context,
              'Light',
              Icons.light_mode,
              ThemeMode.light,
              currentTheme,
              () {
                themeModeNotifier.setThemeMode(ThemeMode.light);
                Navigator.of(context).pop();
              },
            ),
            _buildThemeOption(
              context,
              'Dark',
              Icons.dark_mode,
              ThemeMode.dark,
              currentTheme,
              () {
                themeModeNotifier.setThemeMode(ThemeMode.dark);
                Navigator.of(context).pop();
              },
            ),
            _buildThemeOption(
              context,
              'System',
              Icons.brightness_auto,
              ThemeMode.system,
              currentTheme,
              () {
                themeModeNotifier.setThemeMode(ThemeMode.system);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    String title,
    IconData icon,
    ThemeMode themeMode,
    ThemeMode currentTheme,
    VoidCallback onTap,
  ) {
    final isSelected = themeMode == currentTheme;
    
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppTheme.primaryGreen : Colors.grey,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: isSelected ? AppTheme.primaryGreen : null,
        ),
      ),
      trailing: isSelected
          ? Icon(
              Icons.check,
              color: AppTheme.primaryGreen,
            )
          : null,
      onTap: onTap,
    );
  }
}

class QuickThemeToggle extends ConsumerWidget {
  const QuickThemeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeNotifier = ref.read(themeModeProvider.notifier);

    return IconButton(
      icon: Icon(themeModeNotifier.themeModeIcon),
      onPressed: () => themeModeNotifier.toggleTheme(),
      tooltip: 'Toggle theme',
    );
  }
}
