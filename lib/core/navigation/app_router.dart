import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/upcycle/presentation/screens/upcycle_screen.dart';
import '../../features/market/presentation/screens/market_screen.dart';
import '../../features/social/presentation/screens/social_screen.dart';
import '../../features/social/presentation/screens/events_screen.dart';
import '../../features/social/presentation/screens/messages_screen.dart';
import '../../features/social/presentation/screens/friends_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/coins_screen.dart';
import '../../features/profile/presentation/screens/my_store_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/my_orders_screen.dart';
import '../../features/profile/presentation/screens/settings_screen.dart';
import '../../features/market/presentation/screens/search_results_screen.dart';
import '../../shared/widgets/main_navigation.dart';
import '../../shared/providers/auth_provider.dart';
import '../screens/placeholder_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isLoggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/signup';

      // If not logged in and not on auth pages, redirect to login
      if (!isLoggedIn && !isLoggingIn) {
        return '/login';
      }

      // If logged in and on auth pages, redirect to home
      if (isLoggedIn && isLoggingIn) {
        return '/home';
      }

      return null; // No redirect needed
    },
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return MainNavigation(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/upcycle',
            name: 'upcycle',
            builder: (context, state) => const UpcycleScreen(),
          ),
          GoRoute(
            path: '/market',
            name: 'market',
            builder: (context, state) => const MarketScreen(),
          ),
          GoRoute(
            path: '/social',
            name: 'social',
            builder: (context, state) => const SocialScreen(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      // Authentication routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),

      // Additional routes for detailed screens
      GoRoute(
        path: '/product/:id',
        name: 'product-detail',
        builder: (context, state) {
          final productId = state.pathParameters['id']!;
          return PlaceholderScreen(title: 'Product Detail', subtitle: 'Product ID: $productId');
        },
      ),
      GoRoute(
        path: '/category/:id',
        name: 'category',
        builder: (context, state) {
          final categoryId = state.pathParameters['id']!;
          return PlaceholderScreen(title: 'Category', subtitle: 'Category: $categoryId');
        },
      ),
      GoRoute(
        path: '/search',
        name: 'search',
        builder: (context, state) {
          final query = state.uri.queryParameters['q'] ?? '';
          return SearchResultsScreen(query: query);
        },
      ),
      GoRoute(
        path: '/coins',
        name: 'coins',
        builder: (context, state) => const CoinsScreen(),
      ),
      GoRoute(
        path: '/orders',
        name: 'orders',
        builder: (context, state) => const MyOrdersScreen(),
      ),
      GoRoute(
        path: '/my-store',
        name: 'my-store',
        builder: (context, state) => const MyStoreScreen(),
      ),
      GoRoute(
        path: '/rewards',
        name: 'rewards',
        builder: (context, state) => const PlaceholderScreen(title: 'Rewards'),
      ),
      GoRoute(
        path: '/edit-profile',
        name: 'edit-profile',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/events',
        name: 'events',
        builder: (context, state) => const EventsScreen(),
      ),
      GoRoute(
        path: '/friends',
        name: 'friends',
        builder: (context, state) => const FriendsScreen(),
      ),
      GoRoute(
        path: '/messages',
        name: 'messages',
        builder: (context, state) => const MessagesScreen(),
      ),
      GoRoute(
        path: '/add-product-listing',
        name: 'add-product-listing',
        builder: (context, state) => const PlaceholderScreen(title: 'Add Product Listing'),
      ),
    ],
  );
});
