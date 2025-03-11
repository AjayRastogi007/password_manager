import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:password_manager/provider/page_controller.dart';

import 'package:password_manager/pages/add_vault_page.dart';
import 'package:password_manager/pages/home_page.dart';
import 'package:password_manager/pages/password_generator_page.dart';
import 'package:password_manager/pages/vault_page.dart';

class BottomNavigation extends ConsumerWidget {
  const BottomNavigation({super.key});

  final List<Widget> _pages = const [
    HomePage(),
    VaultPage(),
    AddVaultPage(),
    PasswordGeneratorPage(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(pageProvider);

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lock),
            label: 'Vault',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.password),
            label: 'Generater',
          ),
        ],
        elevation: 5,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.outline,
        selectedLabelStyle: Theme.of(context).textTheme.labelLarge!.copyWith(
              fontWeight: FontWeight.bold,
            ),
        unselectedLabelStyle: Theme.of(context).textTheme.labelLarge,
        showUnselectedLabels: true,
        currentIndex: selectedIndex,
        onTap: (value) => ref.read(pageProvider.notifier).setPage(value),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
    );
  }
}
