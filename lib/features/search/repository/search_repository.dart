import 'package:factory_shop/features/auth/model/user_model.dart';
import 'package:factory_shop/features/feed/model/post_model.dart';
import 'package:factory_shop/features/search/model/location_model.dart';
import 'package:factory_shop/features/search/model/search_result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_repository.g.dart';

@riverpod
class SearchRepository extends _$SearchRepository {
  @override
  FutureOr<List<SearchResult>> build() async {
    return [];
  }

  Future<List<SearchResult>> search(String query) async {
    if (query.isEmpty) return [];

    // TODO: API 연동 시 실제 검색 결과를 가져오도록 수정
    return [
      const SearchResult(
        id: '1',
        type: 'user',
        text: 'john_doe',
        imageUrl: 'https://picsum.photos/200',
        description: 'John Doe',
      ),
      const SearchResult(
        id: '2',
        type: 'hashtag',
        text: 'flutter',
        imageUrl: null,
        description: '1,234 posts',
      ),
      const SearchResult(
        id: '3',
        type: 'location',
        text: 'Seoul, South Korea',
        imageUrl: null,
        description: '5,678 posts',
      ),
    ];
  }

  Future<List<PostModel>> getPostsByHashtag(String hashtag) async {
    // TODO: API 연동 시 실제 해시태그 검색 결과를 가져오도록 수정
    return [
      PostModel(
        id: '1',
        userId: '1',
        username: 'john_doe',
        userImage: 'https://picsum.photos/200',
        imageUrl: 'https://picsum.photos/500',
        caption: 'Beautiful day #flutter',
        likes: 2,
        comments: [],
        createdAt: DateTime.now(),
      ),
      PostModel(
        id: '2',
        userId: '2',
        username: 'jane_doe',
        userImage: 'https://picsum.photos/201',
        imageUrl: 'https://picsum.photos/501',
        caption: 'Learning #flutter',
        likes: 3,
        comments: [],
        createdAt: DateTime.now(),
      ),
    ];
  }

  Future<List<PostModel>> getPostsByLocation(String locationId) async {
    // TODO: API 연동 시 실제 위치 기반 검색 결과를 가져오도록 수정
    return [
      PostModel(
        id: '3',
        userId: '3',
        username: 'travel_lover',
        userImage: 'https://picsum.photos/202',
        imageUrl: 'https://picsum.photos/502',
        caption: 'Beautiful Seoul!',
        likes: 2,
        comments: [],
        createdAt: DateTime.now(),
      ),
      PostModel(
        id: '4',
        userId: '4',
        username: 'foodie',
        userImage: 'https://picsum.photos/203',
        imageUrl: 'https://picsum.photos/503',
        caption: 'Korean food is amazing!',
        likes: 3,
        comments: [],
        createdAt: DateTime.now(),
      ),
    ];
  }

  Future<List<UserModel>> searchUsers(String query) async {
    // TODO: API 연동 시 실제 사용자 검색 결과를 가져오도록 수정
    return [
      UserModel(
        id: '1',
        email: 'john@example.com',
        username: 'john_doe',
        profileImage: 'https://picsum.photos/200',
        bio: 'Flutter developer',
        followers: ['2', '3'],
        following: ['2'],
        posts: ['1', '2'],
      ),
      UserModel(
        id: '2',
        email: 'jane@example.com',
        username: 'jane_doe',
        profileImage: 'https://picsum.photos/201',
        bio: 'UI/UX designer',
        followers: ['1'],
        following: ['1', '3'],
        posts: ['3'],
      ),
    ];
  }

  Future<LocationModel> getLocationDetails(String locationId) async {
    // TODO: API 연동 시 실제 위치 정보를 가져오도록 수정
    return const LocationModel(
      id: '1',
      name: 'Seoul, South Korea',
      latitude: 37.5665,
      longitude: 126.9780,
      address: 'Seoul, South Korea',
      postCount: 5678,
    );
  }
}
