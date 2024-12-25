import 'package:factory_shop/features/search/model/search_result.dart';
import 'package:factory_shop/features/search/repository/search_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_provider.g.dart';

@riverpod
class SearchState extends _$SearchState {
  @override
  FutureOr<List<SearchResult>> build() async {
    return [];
  }

  Future<void> search(String query) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      return ref.read(searchRepositoryProvider.notifier).search(query);
    });
  }
}
