import 'package:factory_shop/features/auth/provider/auth_provider.dart';
import 'package:factory_shop/features/auth/repository/auth_repository.dart';
import 'package:factory_shop/features/feed/repository/feed_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(authRepositoryProvider);
    final postsAsync = ref.watch(feedRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: userAsync.whenOrNull(
          data: (user) => Text(user?.username ?? ''),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () async {
              await ref.read(authStateProvider.notifier).logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (user) {
          if (user == null) {
            return const Center(child: Text('로그인이 필요합니다.'));
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(user.profileImage),
                          ),
                          const SizedBox(width: 32),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildStatColumn(
                                  postsAsync.whenOrNull(
                                    data: (posts) => posts.length.toString(),
                                  ) ?? '0',
                                  '게시물',
                                ),
                                _buildStatColumn(
                                  user.followers.length.toString(),
                                  '팔로워',
                                ),
                                _buildStatColumn(
                                  user.following.length.toString(),
                                  '팔로잉',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.username,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (user.bio.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(user.bio),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: OutlinedButton(
                              onPressed: () {
                                // TODO: 프로필 편집
                              },
                              child: const Text('프로필 편집'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              postsAsync.when(
                loading: () => const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, stack) => SliverToBoxAdapter(
                  child: Center(child: Text('Error: $error')),
                ),
                data: (posts) {
                  final userPosts = posts
                      .where((post) => post.userId == user.id)
                      .toList();

                  return SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 1,
                      crossAxisSpacing: 1,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final post = userPosts[index];
                        return Image.network(
                          post.imageUrl,
                          fit: BoxFit.cover,
                        );
                      },
                      childCount: userPosts.length,
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatColumn(String count, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
