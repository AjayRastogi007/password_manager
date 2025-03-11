import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:password_manager/provider/filter_provider.dart';

class HorizontalSlider extends ConsumerWidget {
  const HorizontalSlider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: Filters.values.length,
      itemBuilder: (context, index) {
        return Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(left: 10, right: 5),
          padding: const EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
            color: ref.watch(filterProvider)[Filters.values[index]]!
                ? Colors.lightGreen
                : colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorScheme.secondaryContainer),
          ),
          child: InkWell(
            onTap: () {
              ref.read(filterProvider.notifier).setFilterValue(
                  Filters.values[index],
                  !ref.read(filterProvider)[Filters.values[index]]!);
            },
            child: Text(
              Filters.values[index].name,
              style: textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w600, color: colorScheme.secondary),
            ),
          ),
        );
      },
    );
  }
}
