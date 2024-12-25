import 'package:factory_shop/features/auth/model/user_model.dart';
import 'package:factory_shop/features/feed/model/post_model.dart';
import 'package:factory_shop/features/search/model/location_model.dart';
import 'package:factory_shop/features/search/repository/search_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SearchDetailScreen extends ConsumerStatefulWidget {
  final String type;
  final String query;
  final String id;

  const SearchDetailScreen({
    required this.type,
    required this.query,
    required this.id,
    super.key,
  });

  @override
  ConsumerState<SearchDetailScreen> createState() => _SearchDetailScreenState();
}

class _SearchDetailScreenState extends ConsumerState<SearchDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.type == 'hashtag'
              ? '#${widget.query}'
              : widget.type == 'location'
                  ? widget.query
                  : '검색 결과',
        ),
      ),
      body: widget.type == 'hashtag'
          ? _HashtagResults(hashtag: widget.query)
          : widget.type == 'location'
              ? _LocationResults(locationId: widget.id)
              : _UserResults(query: widget.query),
    );
  }
}

class _HashtagResults extends ConsumerWidget {
  final String hashtag;

  const _HashtagResults({required this.hashtag});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<PostModel>>(
      future: ref
          .read(searchRepositoryProvider.notifier)
          .getPostsByHashtag(hashtag),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final posts = snapshot.data ?? [];
        if (posts.isEmpty) {
          return const Center(child: Text('게시물이 없습니다'));
        }

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 1,
            crossAxisSpacing: 1,
          ),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return GestureDetector(
              onTap: () {
                context.push('/post/${post.id}');
              },
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    post.imageUrl,
                    fit: BoxFit.cover,
                  ),
                  if (post.comments.isNotEmpty || post.likes > 1)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Row(
                        children: [
                          if (post.likes > 1)
                            Row(
                              children: [
                                const Icon(
                                  Icons.favorite,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  post.likes.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          if (post.comments.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.comment,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  post.comments.length.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _LocationResults extends ConsumerWidget {
  final String locationId;

  const _LocationResults({required this.locationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<LocationModel>(
      future: ref
          .read(searchRepositoryProvider.notifier)
          .getLocationDetails(locationId),
      builder: (context, locationSnapshot) {
        if (locationSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (locationSnapshot.hasError) {
          return Center(child: Text('Error: ${locationSnapshot.error}'));
        }

        final location = locationSnapshot.data!;

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    location.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(location.address),
                  const SizedBox(height: 8),
                  Text('게시물 ${location.postCount}개'),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: FutureBuilder<List<PostModel>>(
                future: ref
                    .read(searchRepositoryProvider.notifier)
                    .getPostsByLocation(locationId),
                builder: (context, postsSnapshot) {
                  if (postsSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (postsSnapshot.hasError) {
                    return Center(child: Text('Error: ${postsSnapshot.error}'));
                  }

                  final posts = postsSnapshot.data ?? [];
                  if (posts.isEmpty) {
                    return const Center(child: Text('게시물이 없습니다'));
                  }

                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 1,
                      crossAxisSpacing: 1,
                    ),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return GestureDetector(
                        onTap: () {
                          context.push('/post/${post.id}');
                        },
                        child: Image.network(
                          post.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _UserResults extends ConsumerWidget {
  final String query;

  const _UserResults({required this.query});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<UserModel>>(
      future: ref.read(searchRepositoryProvider.notifier).searchUsers(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final users = snapshot.data ?? [];
        if (users.isEmpty) {
          return const Center(child: Text('검색 결과가 없습니다'));
        }

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user.profileImage),
              ),
              title: Text(user.username),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.bio),
                  const SizedBox(height: 4),
                  Text(
                    '팔로워 ${user.followers.length} · 팔로잉 ${user.following.length}',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              trailing: TextButton(
                onPressed: () {
                  // TODO: 팔로우/언팔로우 기능 구현
                },
                child: const Text('팔로우'),
              ),
              onTap: () {
                context.push('/profile/${user.id}');
              },
            );
          },
        );
      },
    );
  }
}
