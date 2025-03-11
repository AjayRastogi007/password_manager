import 'dart:math';

class PasswordGeneratorModel {
  PasswordGeneratorModel({
    required this.length,
    required this.uppercase,
    required this.numbers,
    required this.symbols,
  });

  int length;
  int uppercase;
  int numbers;
  int symbols;

  String get randomPassword {
    Random random = Random();
    String password = '';

    // Ensure that the length of the password is enough to include the required characters
    if (length < uppercase + numbers + symbols) {
      return 'Length is too short to include the required characters';
    }

    // Character sets
    const lowercase = 'abcdefghijklmnopqrstuvwxyz';
    const uppercaseChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const digits = '0123456789';
    const symbolChars = '!@#\$%^&*()-_+=\\{}\\[\\]:;"\'<>,.?/\\|~`';

    // Add required number of uppercase characters
    for (int i = 0; i < uppercase; i++) {
      password += uppercaseChars[random.nextInt(uppercaseChars.length)];
    }

    // Add required number of numbers
    for (int i = 0; i < numbers; i++) {
      password += digits[random.nextInt(digits.length)];
    }

    // Add required number of symbols
    for (int i = 0; i < symbols; i++) {
      password += symbolChars[random.nextInt(symbolChars.length)];
    }

    // Fill the rest of the password with random lowercase characters
    for (int i = password.length; i < length; i++) {
      password += lowercase[random.nextInt(lowercase.length)];
    }

    // Shuffle the password to ensure randomness
    List<String> passwordChars = password.split('');
    passwordChars.shuffle(random);
    return passwordChars.join('');
  }
}
