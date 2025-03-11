import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:password_manager/models/add_password_model.dart';
import 'package:password_manager/pages/add_vault_page.dart';
import 'package:password_manager/provider/user_password.dart';

class VaultBottomSheet extends ConsumerWidget {
  customListTile(String title, String subtitle, BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Theme.of(context)
                .colorScheme
                .onSecondaryContainer
                .withOpacity(0.5),
            fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: Theme.of(context)
                  .colorScheme
                  .onSecondaryContainer
                  .withOpacity(0.72),
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  const VaultBottomSheet({
    super.key,
    required this.userPasswords,
    required this.index,
    required this.favicoUrl,
  });

  final AddPasswordModel userPasswords;
  final int index;
  final Future<String> favicoUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String formattedDate =
        '${userPasswords.addedDate.day.toString().padLeft(2, '0')}/${userPasswords.addedDate.month.toString().padLeft(2, '0')}/${userPasswords.addedDate.year}';
    String categoryValue =
        capitalize(userPasswords.category.toString().split('.').last);
    String strengthValue =
        capitalize(userPasswords.strength.toString().split('.').last);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                future: favicoUrl,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return const Icon(
                      Icons.question_mark_rounded,
                      size: 50,
                      color: Colors.red,
                    );
                  }
                  return CircleAvatar(
                    backgroundImage: NetworkImage(snapshot.data!),
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    radius: 30,
                  );
                },
              ),
              const SizedBox(width: 15),
              Padding(
                padding: const EdgeInsets.only(top: 13),
                child: Text(
                  userPasswords.title,
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSecondaryContainer
                            .withOpacity(0.72),
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(top: 13),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (builder) {
                        return AddVaultPage(
                          id: userPasswords.id,
                          title: userPasswords.title,
                          username: userPasswords.username,
                          url: userPasswords.url!,
                          password: userPasswords.password,
                          notes: userPasswords.notes!,
                          category: userPasswords.category,
                          isEditing: true,
                        );
                      }),
                    );
                  },
                  icon: const Icon(Icons.edit, size: 30),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 13),
                child: IconButton(
                  onPressed: () {
                    ref
                        .read(userPasswordProvider.notifier)
                        .removePassword(userPasswords.id);
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.delete,
                    size: 30,
                  ),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary,
                  blurRadius: 1,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              children: [
                customListTile('Login', userPasswords.username, context),
                customListTile('Password', userPasswords.password, context),
                customListTile('Strength', strengthValue, context),
                customListTile('Login URL', userPasswords.url ?? '', context),
                customListTile('Category', categoryValue, context),
                customListTile('Date', formattedDate, context),
                userPasswords.notes == ''
                    ? const SizedBox()
                    : customListTile('Note', userPasswords.notes!, context),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
