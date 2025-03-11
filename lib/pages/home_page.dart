import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:password_manager/models/password_strength_model.dart';
import 'package:password_manager/provider/user_password.dart';
import 'package:password_manager/widgets/cutom_app_bar/custom_app_bar.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

final touchedIndex = StateProvider<int>((ref) => -1);

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  Widget card(int num, String title, Color color, colorScheme, textTheme) {
    return Expanded(
      child: SizedBox(
        height: 100,
        child: Card(
          color: colorScheme.onPrimary,
          child: Center(
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_outline,
                  color: color,
                  size: 30,
                ),
              ),
              title: Text(
                num.toString(),
                style: textTheme.headlineLarge!.copyWith(
                  color: colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                title,
                style: textTheme.titleSmall!.copyWith(
                  color: colorScheme.onSecondaryContainer.withOpacity(0.5),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  SleekCircularSlider buildCircularSlider(
      ColorScheme colorScheme, TextTheme textTheme, double score) {
    return SleekCircularSlider(
      min: 0,
      max: 100,
      initialValue: score * 100,
      appearance: CircularSliderAppearance(
        angleRange: 360,
        size: 300,
        startAngle: 270,
        customWidths: CustomSliderWidths(progressBarWidth: 18),
        customColors: CustomSliderColors(
          progressBarColor: colorScheme.primary,
          shadowColor: Colors.black,
          trackColor: Colors.grey,
        ),
        infoProperties: InfoProperties(
          topLabelText: 'Health Score',
          topLabelStyle: textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSecondaryContainer,
          ),
          mainLabelStyle: textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSecondaryContainer.withOpacity(0.8),
            fontSize: 75,
          ),
        ),
      ),
    );
  }

  Future<String> getUsername() async {
    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    return userData.data()!['username'];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final totalPasswords = ref.watch(userPasswordProvider).list;

    Map<String, int> frequencyMap = {};
    for (var str in totalPasswords.map((e) => e.password)) {
      frequencyMap.update(str, (count) => count + 1, ifAbsent: () => 1);
    }
    int reusedCount = frequencyMap.values.where((count) => count > 1).length;

    double totalEntropy = totalPasswords.isEmpty
        ? 0
        : totalPasswords
                .map((e) => PasswordStrengthModel(password: e.password).entropy)
                .reduce((value, element) => value + element) /
            totalPasswords.length;

    double totalStrength = totalPasswords.isEmpty
        ? 0
        : totalPasswords
                .map((e) =>
                    PasswordStrengthModel(password: e.password).strengthNum)
                .reduce((value, element) => value + element) /
            totalPasswords.length;

    double score = totalPasswords.isEmpty
        ? 0
        : (((totalEntropy / 128) * 0.5) +
            (totalStrength * 0.3) -
            ((reusedCount / totalPasswords.length) * 0.2));

    return Scaffold(
      backgroundColor: colorScheme.primaryContainer,
      appBar: CustomAppBar(
        title: getUsername().toString(),
        isTitleUsername: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(5),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 460,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: colorScheme.onPrimary.withOpacity(0.9),
                  ),
                  child: Column(
                    children: [
                      buildCircularSlider(colorScheme, textTheme, score),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          card(totalPasswords.length, 'Total', Colors.brown,
                              colorScheme, textTheme),
                          card(reusedCount, 'Reused', Colors.purple,
                              colorScheme, textTheme),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                child: Text(
                  'Recenltly Added',
                  style: textTheme.headlineSmall!.copyWith(
                    color: colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: totalPasswords.isEmpty
                    ? Center(
                        child: Text(
                          'No Vaults Found!',
                          style: theme.textTheme.headlineSmall!.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: totalPasswords.length < 5
                            ? totalPasswords.length
                            : 5,
                        itemBuilder: (context, index) {
                          int reverseIndex = totalPasswords.length - index - 1;
                          return Card(
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
                                          url: totalPasswords[reverseIndex]
                                              .url!),
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
                                      backgroundImage:
                                          NetworkImage(snapshot.data!),
                                      backgroundColor: colorScheme.onPrimary,
                                      radius: 27,
                                    );
                                  },
                                ),
                                title: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, left: 10),
                                  child: Text(
                                    totalPasswords[reverseIndex].title,
                                    style: theme.textTheme.titleLarge!.copyWith(
                                        color: colorScheme.onSecondaryContainer
                                            .withOpacity(0.72),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 22),
                                  ),
                                ),
                                subtitle: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, left: 10),
                                  child: Text(
                                    totalPasswords[reverseIndex].username,
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
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.copy,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(
                                          text: totalPasswords[reverseIndex]
                                              .password));
                                      ScaffoldMessenger.of(context)
                                          .clearSnackBars();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Password copied to clipboard',
                                            style: theme.textTheme.bodyLarge!
                                                .copyWith(
                                              color: colorScheme.onPrimary,
                                            ),
                                          ),
                                          backgroundColor:
                                              colorScheme.secondary,
                                          duration: const Duration(seconds: 1),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
