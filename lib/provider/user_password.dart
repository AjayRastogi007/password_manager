import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:favicon/favicon.dart';

import 'package:password_manager/models/add_password_model.dart';
import 'package:password_manager/models/password_strength_model.dart';
import 'package:password_manager/services/database_service.dart';

class PasswordEnquiry {
  PasswordEnquiry({required this.list});
  final List<AddPasswordModel> list;
}

String categoryToString(Category category) {
  return category.toString().split('.').last;
}

Category stringToCategory(String category) {
  return Category.values
      .firstWhere((e) => e.toString().split('.').last == category);
}

String strengthToString(PasswordStrength strength) {
  return strength.toString().split('.').last;
}

PasswordStrength stringToStrength(String strength) {
  return PasswordStrength.values
      .firstWhere((e) => e.toString().split('.').last == strength);
}

String dateTimeToString(DateTime dateTime) {
  return dateTime.toIso8601String();
}

DateTime stringToDateTime(String dateTime) {
  return DateTime.parse(dateTime);
}

class UserPasswordNotifier extends StateNotifier<PasswordEnquiry> {
  UserPasswordNotifier() : super(PasswordEnquiry(list: []));

  void addPassword(AddPasswordModel password) async {
    await DatabaseService.instance.addVaults({
      'id': password.id,
      'title': password.title,
      'username': password.username,
      'url': password.url,
      'password': password.password,
      'strength': strengthToString(password.strength),
      'category': categoryToString(password.category),
      'notes': password.notes,
      'addedDate': dateTimeToString(password.addedDate)
    });
    state = PasswordEnquiry(list: [...state.list, password]);
  }

  void readPassword() async {
    var data = await DatabaseService.instance.getVaults();
    state = PasswordEnquiry(
      list: data
          .map((e) => AddPasswordModel(
              id: e['id'],
              title: e['title'],
              username: e['username'],
              url: e['url'],
              password: e['password'],
              strength: stringToStrength(e['strength']),
              category: stringToCategory(e['category']),
              notes: e['notes'],
              addedDate: stringToDateTime(e['addedDate'])))
          .toList(),
    );
  }

  void updatePassword(AddPasswordModel password) async {
    await DatabaseService.instance.updateVaults({
      'id': password.id,
      'title': password.title,
      'username': password.username,
      'url': password.url,
      'password': password.password,
      'strength': strengthToString(password.strength),
      'category': categoryToString(password.category),
      'notes': password.notes,
      'addedDate': dateTimeToString(password.addedDate)
    });

    state = PasswordEnquiry(
      list: state.list.map((e) {
        if (e.id == password.id) {
          return password;
        }
        return e;
      }).toList(),
    );
  }

  void addPasswordAtIndex(AddPasswordModel password, int index) async {
    await DatabaseService.instance.addVaults({
      'id': password.id,
      'title': password.title,
      'username': password.username,
      'url': password.url,
      'password': password.password,
      'strength': strengthToString(password.strength),
      'category': categoryToString(password.category),
      'notes': password.notes,
      'addedDate': dateTimeToString(password.addedDate)
    });
    state = PasswordEnquiry(
      list: [
        ...state.list.sublist(0, index),
        password,
        ...state.list.sublist(index),
      ],
    );
  }

  void removePassword(String id) {
    DatabaseService.instance.deleteVaults(id);
    state = PasswordEnquiry(
      list: state.list.where((password) => password.id != id).toList(),
    );
  }

  Future<String> getFavicoUrl({required String url}) async {
    var iconUrl = await FaviconFinder.getBest(url);
    return iconUrl!.url;
  }
}

final userPasswordProvider =
    StateNotifierProvider<UserPasswordNotifier, PasswordEnquiry>(
        (ref) => UserPasswordNotifier());
