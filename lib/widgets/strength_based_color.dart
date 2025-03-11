import 'package:flutter/material.dart';
import 'package:password_manager/models/password_strength_model.dart';

class StrengthBasedColor extends StatelessWidget {
  const StrengthBasedColor({super.key, required this.passwordStrengthModel});

  final PasswordStrengthModel passwordStrengthModel;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    Color color = Colors.red;
    if (passwordStrengthModel.strength == PasswordStrength.strong) {
      color = Colors.green;
    } else if (passwordStrengthModel.strength == PasswordStrength.medium) {
      color = Colors.orange;
    } else {
      color = Colors.red;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(8),
      ),
      height: 8,
      width: width,
      child: Row(
        children: [
          Container(
            width: width / 3 - 13.34,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
          ),
          Container(
            width: width / 3 - 13.33,
            color: passwordStrengthModel.strength == PasswordStrength.medium ||
                    passwordStrengthModel.strength == PasswordStrength.strong
                ? color
                : Colors.grey,
          ),
          Container(
            width: width / 3 - 13.33,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              color: passwordStrengthModel.strength == PasswordStrength.strong
                  ? color
                  : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
