import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:password_manager/widgets/cutom_app_bar/custom_app_bar_container.dart';
import 'package:password_manager/widgets/cutom_app_bar/horizontal_slider.dart';
import 'package:password_manager/widgets/cutom_app_bar/vault_search_bar.dart';
import 'package:password_manager/widgets/image_input.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar(
      {super.key, required this.title, this.isTitleUsername = false});

  final String title;
  final bool isTitleUsername;

  Widget homePageAppBar(textTheme, colorScheme, title) {
    return Padding(
      padding: const EdgeInsets.only(left: 13, right: 13),
      child: Stack(
        children: [
          Row(
            children: [
              const ImageInput(),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back,',
                    style: textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onPrimary.withOpacity(0.5)),
                  ),
                  Text(
                    title,
                    style: textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onPrimary),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.exit_to_app),
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                    color: colorScheme.onPrimary,
                    iconSize: 30,
                  ),
                  Text(
                    'Logout',
                    style: textTheme.labelMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onPrimary),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget myVaultsAppBar(textTheme, colorScheme) {
    return Column(
      children: [
        const SizedBox(height: 30),
        const VaultSearchBar(),
        const SizedBox(height: 5),
        Container(
          height: 60,
          padding: const EdgeInsets.only(left: 13, right: 13),
          alignment: Alignment.centerLeft,
          child: Text(
            'Categories',
            style: textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.w600, color: colorScheme.onPrimary),
          ),
        ),
        const SizedBox(
          height: 30,
          child: HorizontalSlider(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Stack(
        children: [
          CustomAppBarContainer(context: context),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Center(
                  child: !isTitleUsername
                      ? Text(
                          title,
                          style: textTheme.displaySmall!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onPrimary,
                              fontSize: title == 'My Vaults' ? 40 : 30),
                        )
                      : homePageAppBar(textTheme, colorScheme, title),
                ),
                if (title == 'My Vaults')
                  myVaultsAppBar(textTheme, colorScheme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => title == 'My Vaults'
      ? const Size(280, 280)
      : isTitleUsername
          ? const Size(280, 120)
          : const Size(280, 90);
}
