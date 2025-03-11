import 'dart:math';

import 'package:password_strength/password_strength.dart';

enum PasswordStrength {
  weak,
  medium,
  strong,
}

class PasswordStrengthModel {
  const PasswordStrengthModel({
    required this.password,
  });
  final String password;

  double estimatePasswordEntropy(String password) {
    int charsetSize = 0;
    if (RegExp(r'[0-9]').hasMatch(password)) {
      charsetSize += 10; // digits
    }
    if (RegExp(r'[a-z]').hasMatch(password)) {
      charsetSize += 26; // lowercase letters
    }
    if (RegExp(r'[A-Z]').hasMatch(password)) {
      charsetSize += 26; // uppercase letters
    }
    if (RegExp(r'''[!@#\$%\^&\*\(\)\-_\+=\{\}\[\]:;"\'<>,\.\?\/\\|~`]''')
        .hasMatch(password)) {
      charsetSize +=
          32; // special characters (this can be adjusted based on the exact characters considered)
    }

    final entropy = password.length * log(charsetSize) / log(2);
    return entropy;
  }

  double get entropy {
    return estimatePasswordEntropy(password);
  }

  double get strengthNum {
    return estimatePasswordStrength(password);
  }

  PasswordStrength get strength {
    double strength = estimatePasswordStrength(password);
    double entropy = estimatePasswordEntropy(password);
    if (strength < 0.3 || entropy < 30) {
      return PasswordStrength.weak;
    } else if (strength < 0.7 || entropy < 60) {
      return PasswordStrength.medium;
    } else {
      return PasswordStrength.strong;
    }
  }

  String get timeToCrack {
    double entropy = estimatePasswordEntropy(password);
    double secondsToCrack = pow(2, entropy) / 2e9;
    if (secondsToCrack.isNaN || secondsToCrack < 1) {
      return 'Less than a second';
    } else if (secondsToCrack < 60) {
      return '${secondsToCrack.toStringAsFixed(2)} seconds';
    } else if (secondsToCrack < 3600) {
      return '${(secondsToCrack / 60).toStringAsFixed(2)} minutes';
    } else if (secondsToCrack < 86400) {
      return '${(secondsToCrack / 3600).toStringAsFixed(2)} hours';
    } else if (secondsToCrack < 604800) {
      return '${(secondsToCrack / 86400).toStringAsFixed(2)} days';
    } else if (secondsToCrack < 2.628e+6) {
      return '${(secondsToCrack / 604800).toStringAsFixed(2)} weeks';
    } else if (secondsToCrack < 3.154e+7) {
      return '${(secondsToCrack / 2.628e+6).toStringAsFixed(2)} months';
    } else {
      return '${(secondsToCrack / 3.154e+7).toStringAsFixed(2)} years';
    }
  }
}
