import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_manager/models/add_password_model.dart';
import 'package:password_manager/provider/filter_provider.dart';
import 'package:password_manager/provider/user_password.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:password_manager/widgets/cutom_app_bar/custom_app_bar.dart';
import 'package:password_manager/widgets/vault_bottom_sheet.dart';

List<AddPasswordModel> userPasswords = [];

class VaultPage extends StatelessWidget {
  const VaultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primaryContainer,
      appBar: const CustomAppBar(
        title: 'My Vaults',
      ),
      body: const VaultList(),
    );
  }
}

class VaultList extends ConsumerStatefulWidget {
  const VaultList({super.key});

  @override
  ConsumerState<VaultList> createState() => _VaultListState();
}

class _VaultListState extends ConsumerState<VaultList> {
  @override
  initState() {
    super.initState();
    ref.read(userPasswordProvider.notifier).readPassword();
  }

  Widget slideBackground(Color color, IconData icon, String text, bool isLeft) {
    return Container(
      alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        mainAxisAlignment:
            isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: <Widget>[
          const SizedBox(width: 15),
          Icon(
            icon,
            color: isLeft ? Colors.white : Colors.black,
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              color: isLeft ? Colors.white : Colors.black,
              fontWeight: FontWeight.w900,
            ),
            textAlign: isLeft ? TextAlign.left : TextAlign.right,
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    userPasswords = ref.watch(filteredVaultProvider.select((value) => value));
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return userPasswords.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Image.asset('assets/sorry.png', width: 200)),
              Text(
                'No vaults found!',
                style: theme.textTheme.headlineMedium!.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          )
        : ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
              bottom: 10,
            ),
            itemCount: userPasswords.length,
            itemBuilder: (context, index) {
              int reverseIndex = userPasswords.length - index - 1;
              return Dismissible(
                key: Key(userPasswords[reverseIndex].id),
                background: slideBackground(
                    colorScheme.error, Icons.delete, 'Delete', true),
                secondaryBackground: slideBackground(
                    Colors.lightGreen, Icons.copy, 'Copy', false),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    final removedVaultIndex = reverseIndex;
                    final removedVault = userPasswords[reverseIndex];
                    ref
                        .read(userPasswordProvider.notifier)
                        .removePassword(userPasswords[reverseIndex].id);
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Vault deleted successfully',
                          style: theme.textTheme.bodyLarge!.copyWith(
                            color: colorScheme.onPrimary,
                          ),
                        ),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () {
                            ref
                                .read(userPasswordProvider.notifier)
                                .addPasswordAtIndex(
                                    removedVault, removedVaultIndex);
                          },
                        ),
                        backgroundColor: colorScheme.secondary,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                    return true;
                  } else {
                    Clipboard.setData(ClipboardData(
                        text: userPasswords[reverseIndex].password));
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Password copied to clipboard',
                          style: theme.textTheme.bodyLarge!.copyWith(
                            color: colorScheme.onPrimary,
                          ),
                        ),
                        backgroundColor: colorScheme.secondary,
                        duration: const Duration(seconds: 1),
                      ),
                    );
                    return false;
                  }
                },
                child: Card(
                  elevation: 1,
                  shadowColor: colorScheme.primary,
                  color: colorScheme.onPrimary,
                  child: SizedBox(
                    height: 80,
                    child: ListTile(
                      leading: FutureBuilder<String>(
                        future: ref
                            .read(userPasswordProvider.notifier)
                            .getFavicoUrl(
                                url: userPasswords[reverseIndex].url!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator(
                              color: colorScheme.primary,
                            );
                          }
                          if (snapshot.hasError) {
                            return const Icon(
                              Icons.error,
                              size: 60,
                              color: Colors.grey,
                            );
                          }
                          return CircleAvatar(
                            backgroundImage: NetworkImage(snapshot.data!),
                            backgroundColor: colorScheme.onPrimary,
                            radius: 27,
                          );
                        },
                      ),
                      title: Padding(
                        padding: const EdgeInsets.only(top: 5, left: 10),
                        child: Text(
                          userPasswords[reverseIndex].title,
                          style: theme.textTheme.titleLarge!.copyWith(
                              color: colorScheme.onSecondaryContainer
                                  .withOpacity(0.72),
                              fontWeight: FontWeight.w600,
                              fontSize: 22),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 5, left: 10),
                        child: Text(
                          userPasswords[reverseIndex].username,
                          style: theme.textTheme.bodyMedium!.copyWith(
                              color: colorScheme.onSecondaryContainer
                                  .withOpacity(0.5),
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          userPasswords[reverseIndex]
                              .category
                              .toString()
                              .split('.')
                              .last,
                          style: theme.textTheme.bodyMedium!.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      onTap: () => showModalBottomSheet(
                        backgroundColor: const Color.fromRGBO(214, 214, 214, 1),
                        context: context,
                        showDragHandle: true,
                        useSafeArea: true,
                        isScrollControlled: true,
                        builder: (context) {
                          return Wrap(children: [
                            VaultBottomSheet(
                              userPasswords: userPasswords[reverseIndex],
                              index: reverseIndex,
                              favicoUrl: ref
                                  .read(userPasswordProvider.notifier)
                                  .getFavicoUrl(
                                      url: userPasswords[reverseIndex].url!),
                            ),
                          ]);
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          );
  }
}
