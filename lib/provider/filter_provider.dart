import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:password_manager/models/add_password_model.dart';
import 'package:password_manager/provider/user_password.dart';

enum Filters {
  all,
  social,
  finance,
  shopping,
  blog,
  booking,
  entertainment,
  news,
  travel,
  other,
}

class FilterNotifier extends StateNotifier<Map<Filters, bool>> {
  FilterNotifier()
      : _searchValue = '',
        super({
          Filters.all: true,
          Filters.social: false,
          Filters.finance: false,
          Filters.shopping: false,
          Filters.blog: false,
          Filters.booking: false,
          Filters.entertainment: false,
          Filters.news: false,
          Filters.travel: false,
          Filters.other: false,
        });

  String _searchValue;

  void setFilter(Map<Filters, bool> chosenFilters) {
    state = chosenFilters;
  }

  void setFilterValue(Filters filter, bool isActive) {
    state = {
      ...state,
      filter: isActive,
    };
  }

  void setSearchValue(String searchValue) {
    _searchValue = searchValue;
    state = {...state};
  }
}

final filterProvider =
    StateNotifierProvider<FilterNotifier, Map<Filters, bool>>(
  (ref) => FilterNotifier(),
);

final filteredVaultProvider = Provider((ref) {
  final vaults = ref.watch(userPasswordProvider).list;
  final activeFilters = ref.watch(filterProvider);
  final searchValue = ref.watch(filterProvider.notifier)._searchValue;

  return vaults.where((vault) {
    final matchesSearch =
        vault.title.toLowerCase().contains(searchValue.toLowerCase()) ||
            vault.username.toLowerCase().contains(searchValue.toLowerCase()) ||
            vault.password.toLowerCase().contains(searchValue.toLowerCase()) ||
            vault.url!.toLowerCase().contains(searchValue.toLowerCase());

    if (activeFilters[Filters.all]!) {
      return matchesSearch;
    }
    if (activeFilters[Filters.social]! && vault.category == Category.social) {
      return matchesSearch;
    }
    if (activeFilters[Filters.finance]! && vault.category == Category.finance) {
      return matchesSearch;
    }
    if (activeFilters[Filters.shopping]! &&
        vault.category == Category.shopping) {
      return matchesSearch;
    }
    if (activeFilters[Filters.blog]! && vault.category == Category.blog) {
      return matchesSearch;
    }
    if (activeFilters[Filters.booking]! && vault.category == Category.booking) {
      return matchesSearch;
    }
    if (activeFilters[Filters.entertainment]! &&
        vault.category == Category.entertainment) {
      return matchesSearch;
    }
    if (activeFilters[Filters.news]! && vault.category == Category.news) {
      return matchesSearch;
    }
    if (activeFilters[Filters.travel]! && vault.category == Category.travel) {
      return matchesSearch;
    }
    if (activeFilters[Filters.other]! && vault.category == Category.other) {
      return matchesSearch;
    }
    return false;
  }).toList();
});
