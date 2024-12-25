import 'package:factory_shop/features/feed/model/post_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_repository.g.dart';

@riverpod
class FeedRepository extends _$FeedRepository {
  @override
  FutureOr<List<PostModel>> build() async {
    // TODO: API 연동 시 실제 데이터를 가져오도록 수정
    return List.generate(
      10,
      (index) => PostModel(
        id: index.toString(),
        userId: 'user$index',
        username: 'User $index',
        userImage: 'https://picsum.photos/200?random=$index',
        imageUrl: 'https://picsum.photos/500?random=$index',
        caption: '게시물 $index의 캡션입니다.',
        likes: index * 10,
        comments: List.generate(index, (i) => '댓글 $i'),
        createdAt: DateTime.now().subtract(Duration(days: index)),
      ),
    );
  }

  Future<void> likePost(String postId) async {
    state.whenData((posts) {
      final updatedPosts = posts.map((post) {
        if (post.id == postId) {
          return post.copyWith(likes: post.likes + 1);
        }
        return post;
      }).toList();
      state = AsyncValue.data(updatedPosts);
    });
  }

  Future<void> addComment(String postId, String comment) async {
    state.whenData((posts) {
      final updatedPosts = posts.map((post) {
        if (post.id == postId) {
          return post.copyWith(
            comments: [...post.comments, comment],
          );
        }
        return post;
      }).toList();
      state = AsyncValue.data(updatedPosts);
    });
  }

  Future<void> createPost({
    required String imageUrl,
    required String caption,
  }) async {
    state.whenData((posts) {
      final newPost = PostModel(
        id: DateTime.now().toString(),
        userId: 'currentUser', // TODO: 실제 사용자 ID로 변경
        username: 'Current User', // TODO: 실제 사용자 이름으로 변경
        userImage: 'https://picsum.photos/200',
        imageUrl: imageUrl,
        caption: caption,
        likes: 0,
        comments: [],
        createdAt: DateTime.now(),
      );
      state = AsyncValue.data([newPost, ...posts]);
    });
  }
}
