import 'package:factory_shop/common/layout/main_layout.dart';
import 'package:factory_shop/features/auth/view/login_screen.dart';
import 'package:factory_shop/features/auth/view/splash_screen.dart';
import 'package:factory_shop/features/feed/view/home_screen.dart';
import 'package:factory_shop/features/profile/view/profile_screen.dart';
import 'package:factory_shop/features/search/view/search_detail_screen.dart';
import 'package:factory_shop/features/search/view/search_screen.dart';
import 'package:factory_shop/features/upload/view/upload_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

@riverpod
GoRouter router(Ref ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainScreen(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/search',
            builder: (context, state) => const SearchScreen(),
          ),
          GoRoute(
            path: '/upload',
            builder: (context, state) => const UploadScreen(),
          ),
          // GoRoute(
          //   path: '/activity',
          //   builder: (context, state) => const ActivityScreen(),
          // ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/search/:type/:id',
            builder: (context, state) {
              final params = state.pathParameters;
              final extra = state.extra as Map<String, String>;
              return SearchDetailScreen(
                type: params['type'] ?? '',
                query: extra['query'] ?? '',
                id: params['id'] ?? '',
              );
            },
          ),
        ],
      ),
    ],
  );
}

class ActivityScreen {
  const ActivityScreen();
}
