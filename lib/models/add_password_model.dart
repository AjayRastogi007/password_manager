import 'package:password_manager/models/password_strength_model.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

enum Category {
  social,
  finance,
  shopping,
  blog,
  booking,
  entertainment,
  news,
  travel,
  other,
}

class AddPasswordModel {
  AddPasswordModel({
    required this.title,
    required this.username,
    this.url,
    required this.password,
    required this.strength,
    required this.addedDate,
    required this.category,
    this.notes,
    String? id,
  }) : id = id ?? uuid.v4();

  final String id;
  final String title;
  final String username;
  final String? url;
  final String password;
  final PasswordStrength strength;
  final String? notes;
  final Category category;
  final DateTime addedDate;
}
