import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:password_manager/models/password_generator_model.dart';
import 'package:password_manager/widgets/cutom_app_bar/custom_app_bar.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class PasswordGeneratorPage extends StatelessWidget {
  const PasswordGeneratorPage({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primaryContainer,
      appBar: const CustomAppBar(title: 'Create Secure Passwords'),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: const PasswordGenerator(),
          ),
        ),
      ),
    );
  }
}

final capsSliderProvider = StateProvider<double>((ref) => 2);
final digitsSliderProvider = StateProvider<double>((ref) => 2);
final symbolsSliderProvider = StateProvider<double>((ref) => 2);
final characterSliderProvider = StateProvider<double>((ref) => 15);
final passwordProvider = StateProvider<String>((ref) => '');

class PasswordGenerator extends ConsumerStatefulWidget {
  const PasswordGenerator({super.key});

  @override
  ConsumerState<PasswordGenerator> createState() => _PasswordGeneratorState();
}

class _PasswordGeneratorState extends ConsumerState<PasswordGenerator> {
  late double capsSlider;
  late double digitsSlider;
  late double symbolsSlider;
  late double characterSlider;
  late String password;

  String randomPasswordGenerator(
      int length, int uppercase, int numbers, int symbols) {
    return PasswordGeneratorModel(
      length: length,
      uppercase: uppercase,
      numbers: numbers,
      symbols: symbols,
    ).randomPassword;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    capsSlider = ref.watch(capsSliderProvider);
    digitsSlider = ref.watch(digitsSliderProvider);
    symbolsSlider = ref.watch(symbolsSliderProvider);
    characterSlider = ref.watch(characterSliderProvider);
    password = ref.watch(passwordProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Container(
            padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15),
            decoration: BoxDecoration(
              color: colorScheme.onPrimary.withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Uppercases: ${capsSlider.toInt()}',
                      style: textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color:
                            colorScheme.onSecondaryContainer.withOpacity(0.8),
                        fontSize: 18,
                      ),
                    ),
                    Slider(
                        value: capsSlider,
                        min: 0,
                        max: 15,
                        divisions: 15,
                        onChanged: (value) {
                          capsSlider = ref
                              .read(capsSliderProvider.notifier)
                              .state = value;
                        }),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Numbers: ${digitsSlider.toInt()}',
                      style: textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color:
                            colorScheme.onSecondaryContainer.withOpacity(0.8),
                        fontSize: 18,
                      ),
                    ),
                    Slider(
                        value: digitsSlider,
                        min: 0,
                        max: 15,
                        divisions: 15,
                        onChanged: (value) {
                          digitsSlider = ref
                              .read(digitsSliderProvider.notifier)
                              .state = value;
                        }),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Symbols: ${symbolsSlider.toInt()}',
                      style: textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color:
                            colorScheme.onSecondaryContainer.withOpacity(0.8),
                        fontSize: 18,
                      ),
                    ),
                    Slider(
                      value: symbolsSlider,
                      min: 0,
                      max: 15,
                      divisions: 15,
                      onChanged: (value) {
                        symbolsSlider = ref
                            .read(symbolsSliderProvider.notifier)
                            .state = value;
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),
        Center(
          child: Container(
            width: 350,
            height: 350,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.onPrimary.withOpacity(0.8),
            ),
            child: SleekCircularSlider(
              min: 0,
              max: 61,
              initialValue: characterSlider,
              appearance: CircularSliderAppearance(
                angleRange: 360,
                size: 300,
                startAngle: 270,
                customWidths: CustomSliderWidths(progressBarWidth: 15),
                customColors: CustomSliderColors(
                  progressBarColor: colorScheme.primary,
                  trackColor: Colors.grey,
                ),
                infoProperties: InfoProperties(
                  topLabelText: 'CHARACTERS',
                  topLabelStyle: textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSecondaryContainer,
                  ),
                  mainLabelStyle: textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSecondaryContainer.withOpacity(0.8),
                    fontSize: 50,
                  ),
                  modifier: (double value) {
                    return value.toInt().toString();
                  },
                ),
              ),
              onChange: (value) {
                ref.read(characterSliderProvider.notifier).state = value;
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Maximum character limit: 60',
          style: textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSecondaryContainer.withOpacity(0.8),
              fontSize: 20),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.17,
          decoration: BoxDecoration(
            color: colorScheme.onPrimary.withOpacity(0.8),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                'GENERATED PASSWORD',
                style: textTheme.bodyMedium!.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  password == ''
                      ? "Click generate for a secure password."
                      : password,
                  style: textTheme.titleLarge!.copyWith(
                    color: colorScheme.onSecondaryContainer.withOpacity(0.8),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      ref.read(passwordProvider.notifier).state =
                          randomPasswordGenerator(
                              characterSlider.toInt(),
                              capsSlider.toInt(),
                              digitsSlider.toInt(),
                              symbolsSlider.toInt());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      fixedSize: const Size(150, 50),
                    ),
                    icon: Icon(Icons.refresh, color: colorScheme.onPrimary),
                    label: Text(
                      'Generate',
                      style: textTheme.bodyLarge!.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: password));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      fixedSize: const Size(150, 50),
                    ),
                    icon: Icon(Icons.copy, color: colorScheme.onPrimary),
                    label: Text(
                      'Copy',
                      style: textTheme.bodyLarge!.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
