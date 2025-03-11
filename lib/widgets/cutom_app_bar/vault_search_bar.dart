import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:password_manager/provider/filter_provider.dart';

class VaultSearchBar extends ConsumerWidget {
  const VaultSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController searchController = TextEditingController();
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      height: 55,
      child: SearchBar(
        controller: searchController,
        onChanged: (value) {
          ref.read(filterProvider.notifier).setSearchValue(value);
        },
        backgroundColor: WidgetStatePropertyAll<Color>(
            Theme.of(context).colorScheme.onPrimary),
        textCapitalization: TextCapitalization.sentences,
        elevation: const WidgetStatePropertyAll<double>(0),
        hintText: 'Search in Vaults',
        hintStyle: WidgetStatePropertyAll<TextStyle>(textTheme.titleMedium!
            .copyWith(color: Colors.grey, fontWeight: FontWeight.bold)),
        leading: const Icon(Icons.search, size: 30, color: Colors.grey),
        shape: WidgetStatePropertyAll<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
