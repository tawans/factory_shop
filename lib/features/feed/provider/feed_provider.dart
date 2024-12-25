import 'package:factory_shop/features/feed/repository/feed_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_provider.g.dart';

@riverpod
class FeedState extends _$FeedState {
  @override
  FutureOr<void> build() async {
    await ref.watch(feedRepositoryProvider.future);
  }

  Future<void> likePost(String postId) async {
    await ref.read(feedRepositoryProvider.notifier).likePost(postId);
  }

  Future<void> addComment(String postId, String comment) async {
    await ref.read(feedRepositoryProvider.notifier).addComment(postId, comment);
  }

  Future<void> createPost({
    required String imageUrl,
    required String caption,
  }) async {
    await ref.read(feedRepositoryProvider.notifier).createPost(
          imageUrl: imageUrl,
          caption: caption,
        );
  }
}
