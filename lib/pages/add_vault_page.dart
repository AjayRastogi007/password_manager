import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:password_manager/models/add_password_model.dart';
import 'package:password_manager/models/password_strength_model.dart';
import 'package:password_manager/provider/user_password.dart';
import 'package:password_manager/widgets/cutom_app_bar/custom_app_bar.dart';
import 'package:password_manager/widgets/strength_based_color.dart';

class AddVaultPage extends StatelessWidget {
  const AddVaultPage(
      {super.key,
      this.id = '',
      this.title = '',
      this.username = '',
      this.url = '',
      this.password = '',
      this.notes = '',
      this.category = Category.other,
      this.isEditing = false});

  final String id;
  final String title;
  final String username;
  final String url;
  final String password;
  final String notes;
  final Category category;
  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
            title: isEditing ? 'Edit Existing Valuts' : 'Create New Vaults'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        body: !isEditing
            ? const VaultForm()
            : VaultForm(
                id: id,
                title: title,
                username: username,
                url: url,
                password: password,
                notes: notes,
                category: category,
                isEditing: isEditing,
              ));
  }
}

final savingProvider = StateProvider((ref) => false);
final passwordVisibilityProvider = StateProvider((ref) => false);
final passwordStrengthModelProvider =
    StateProvider((ref) => const PasswordStrengthModel(password: ''));

class VaultForm extends ConsumerStatefulWidget {
  const VaultForm({
    super.key,
    this.id = '',
    this.title = '',
    this.username = '',
    this.url = '',
    this.password = '',
    this.notes = '',
    this.category = Category.other,
    this.isEditing = false,
  });

  final String id;
  final String title;
  final String username;
  final String url;
  final String password;
  final String notes;
  final Category category;
  final bool isEditing;

  @override
  ConsumerState<VaultForm> createState() => _VaultFormState();
}

class _VaultFormState extends ConsumerState<VaultForm> {
  final _formKeyOne = GlobalKey<FormState>();
  final _formKeyTwo = GlobalKey<FormState>();
  final _formKeyThree = GlobalKey<FormState>();

  bool passwordVisibility = false;
  bool isSaving = false;
  PasswordStrengthModel passwordStrengthModel =
      const PasswordStrengthModel(password: '');

  late TextEditingController _title;
  late TextEditingController _username;
  late TextEditingController _url;
  late TextEditingController _password;
  late TextEditingController _notes;
  late Category _category = widget.category;
  late bool isEditing = widget.isEditing;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.title);
    _username = TextEditingController(text: widget.username);
    _url = TextEditingController(text: widget.url);
    _password = TextEditingController(text: widget.password);
    _notes = TextEditingController(text: widget.notes);
  }

  @override
  void dispose() {
    _title.dispose();
    _username.dispose();
    _url.dispose();
    _password.dispose();
    _notes.dispose();
    super.dispose();
  }

  void _submit() {
    final isValid = _formKeyOne.currentState!.validate() &&
        _formKeyTwo.currentState!.validate() &&
        _formKeyThree.currentState!.validate();
    if (!isValid) {
      return;
    }

    ref.read(savingProvider.notifier).state = true;
    _formKeyOne.currentState!.save();
    _formKeyTwo.currentState!.save();
    _formKeyThree.currentState!.save();

    if (isEditing) {
      ref.read(userPasswordProvider.notifier).updatePassword(
            AddPasswordModel(
              id: widget.id,
              title: _title.text,
              username: _username.text,
              url: _url.text == ''
                  ? 'https://www.${_title.text}.com'
                  : _url.text,
              password: _password.text,
              strength: passwordStrengthModel.strength,
              addedDate: DateTime.now(),
              category: _category,
              notes: _notes.text,
            ),
          );
    } else {
      ref.read(userPasswordProvider.notifier).addPassword(
            AddPasswordModel(
              title: _title.text,
              username: _username.text,
              url: _url.text == ''
                  ? 'https://www.${_title.text}.com'
                  : _url.text,
              password: _password.text,
              strength: passwordStrengthModel.strength,
              addedDate: DateTime.now(),
              category: _category,
              notes: _notes.text,
            ),
          );
    }

    Future.delayed(
      const Duration(seconds: 1),
      () {
        ref.read(savingProvider.notifier).state = false;
        _formKeyOne.currentState!.reset();
        _formKeyTwo.currentState!.reset();
        _formKeyThree.currentState!.reset();

        setState(() {
          _title.clear();
          _username.clear();
          _url.clear();
          _password.clear();
          _notes.clear();
          _category = Category.other;
        });

        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditing
                  ? 'Vault updated successfully.'
                  : 'Vault added successfully.',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
            backgroundColor: Theme.of(context).colorScheme.secondary,
            duration: const Duration(seconds: 2),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    passwordStrengthModel = ref.watch(passwordStrengthModelProvider);
    passwordVisibility = ref.watch(passwordVisibilityProvider);
    isSaving = ref.watch(savingProvider);
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          physics: const ScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Form(
                key: _formKeyOne,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Credentials',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                            ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _title,
                        decoration: InputDecoration(
                          labelText: 'Title*',
                          prefixIcon: const Icon(Icons.title),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a valid title.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _title.text = value!;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: _url,
                        decoration: InputDecoration(
                          labelText: 'Website / App',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.link),
                        ),
                        textInputAction: TextInputAction.next,
                        onSaved: (value) => _url.text = value!,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: _username,
                        decoration: InputDecoration(
                          labelText: 'Username / Email*',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.person),
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a valid username';
                          }
                          return null;
                        },
                        onSaved: (value) => _username.text = value!,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: _password,
                        decoration: InputDecoration(
                          labelText: 'Password*',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.password),
                          suffixIcon: IconButton(
                            icon: Icon(passwordVisibility
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () => ref
                                .read(passwordVisibilityProvider.notifier)
                                .state = !passwordVisibility,
                          ),
                        ),
                        obscureText: passwordVisibility ? false : true,
                        onChanged: (value) {
                          ref
                              .read(passwordStrengthModelProvider.notifier)
                              .state = PasswordStrengthModel(password: value);
                        },
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a valid password';
                          }
                          return null;
                        },
                        onSaved: (value) => _password.text = value!,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      StrengthBasedColor(
                        passwordStrengthModel: PasswordStrengthModel(
                          password: passwordStrengthModel.password,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Strength: ${passwordStrengthModel.strength.name.toUpperCase()}',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: passwordStrengthModel.strength ==
                                      PasswordStrength.strong
                                  ? Colors.green
                                  : passwordStrengthModel.strength ==
                                          PasswordStrength.medium
                                      ? Colors.orange
                                      : Colors.red,
                            ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Time need to crack: ${passwordStrengthModel.timeToCrack}',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                child: Form(
                  key: _formKeyTwo,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Category',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                            ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DropdownButtonFormField(
                        isExpanded: true,
                        value: _category,
                        items: Category.values
                            .map((category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(
                                    category.name.toUpperCase(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ))
                            .toList(),
                        onChanged: (value) {
                          _category = value!;
                        },
                        onSaved: (value) {
                          _category = value!;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                child: Form(
                  key: _formKeyThree,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notes',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                            ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _notes,
                        maxLines: null,
                        minLines: 1,
                        decoration: InputDecoration(
                          labelText: 'Notes',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.note_add_sharp),
                        ),
                        onSaved: (value) => _notes.text = value!,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadowColor: Theme.of(context).colorScheme.secondary,
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 40,
                  ),
                ),
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  _submit();
                  if (isEditing) {
                    Future.delayed(
                      const Duration(seconds: 2),
                      () {
                        isEditing = false;
                        Navigator.of(context).pop();
                      },
                    );
                  }
                },
                child: isSaving
                    ? Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text(
                          isEditing ? 'Update the Vault' : 'Create the Vault',
                          style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
