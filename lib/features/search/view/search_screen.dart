import 'dart:async';

import 'package:factory_shop/features/search/provider/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(searchStateProvider.notifier).search(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(searchStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: _onSearchChanged,
          decoration: const InputDecoration(
            hintText: '검색',
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search),
          ),
        ),
      ),
      body: searchResults.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (results) {
          if (results.isEmpty) {
            return const Center(child: Text('검색 결과가 없습니다'));
          }

          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final result = results[index];
              return ListTile(
                leading: result.imageUrl != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(result.imageUrl!),
                      )
                    : CircleAvatar(
                        child: Icon(
                          result.type == 'hashtag'
                              ? Icons.tag
                              : result.type == 'location'
                                  ? Icons.location_on
                                  : Icons.person,
                        ),
                      ),
                title: Text(result.text),
                subtitle: result.description != null
                    ? Text(result.description!)
                    : null,
                onTap: () {
                  context.push(
                    '/search/${result.type}/${result.id}',
                    extra: {
                      'type': result.type,
                      'query': result.text,
                      'id': result.id,
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
