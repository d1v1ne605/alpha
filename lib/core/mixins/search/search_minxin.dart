import 'dart:async';

import 'package:alpha/core/base/base_view_model.dart';
import 'package:flutter/material.dart';

mixin SearchMixin<T> on BaseViewModel {
  final TextEditingController searchController = TextEditingController();
  Timer? _searchDebouncer;
  String _searchQuery = '';

  late final ValueNotifier<List<T>> filteredItemsNotifier;

  String get searchQuery => _searchQuery;

  Duration get debounceDuration => const Duration(milliseconds: 100);

  List<T> get allItems;

  List<T> get filteredItems => filteredItemsNotifier.value;

  set filteredItems(List<T> items) {
    filteredItemsNotifier.value = items;
  }

  void initializeSearch() {
    filteredItemsNotifier = ValueNotifier<List<T>>(List.from(allItems));
  }

  String getSearchField(T item) {
    if (item is Map) {
      return item['name']?.toString() ?? item['id']?.toString() ?? '';
    }
    return item.toString();
  }

  void onSearchChanged(String query) {
    _searchDebouncer?.cancel();
    _searchDebouncer = Timer(debounceDuration, () {
      _searchQuery = query;
      updateSearchQuery(query);
    });
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      filteredItemsNotifier.value = List.from(allItems);
    } else {
      final lowercaseQuery = query.toLowerCase();
      filteredItemsNotifier.value = allItems.where((item) {
        final searchField = getSearchField(item);
        return searchField.toLowerCase().contains(lowercaseQuery);
      }).toList();
    }
  }

  void clearSearch() {
    searchController.clear();
    _searchQuery = '';
    filteredItemsNotifier.value = List.from(allItems);
    _searchDebouncer?.cancel();
  }

  @override
  void dispose() {
    searchController.dispose();
    filteredItemsNotifier.dispose();
    _searchDebouncer?.cancel();
    super.dispose();
  }
}
