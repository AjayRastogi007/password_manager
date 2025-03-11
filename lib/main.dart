import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:password_manager/firebase_options.dart';
import 'package:password_manager/pages/authentication_page.dart';
import 'package:password_manager/services/database_service.dart';
import 'package:password_manager/widgets/bottom_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await DatabaseService().database;
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Password Manager',
        darkTheme: ThemeData(
          fontFamily: GoogleFonts.nunitoSans().fontFamily,
          textTheme: GoogleFonts.nunitoSansTextTheme(),
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 17, 131, 79),
              brightness: Brightness.dark),
        ),
        theme: ThemeData(
          textTheme: GoogleFonts.nunitoSansTextTheme(),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 17, 131, 79),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary),
              );
            }
            if (snapshot.hasData) {
              return const BottomNavigation();
            }
            return const AuthenticationPage();
          },
        ));
  }
}
