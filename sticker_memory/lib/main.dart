import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/login_account.dart';
import 'pages/sticker_board.dart';
import 'pages/setting.dart';
import 'pages/sticker_view.dart';
import 'pages/registration_sticker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/registration_account.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return MaterialApp(
        title: 'Flutter Multi Page App',
        theme: ThemeData(primarySwatch: Colors.teal),
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginPage(),
          '/registration': (context) => RegistrationPage(),
        },
      );
    } else {
      return MaterialApp(
        title: 'Flutter Multi Page App',
        theme: ThemeData(primarySwatch: Colors.teal),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomePage(),
          '/sticker': (context) => const StickerBoardPage(),
          '/sticker_view': (context) => StickerViewPage(),
          '/stamp': (context) => ImagePickerPage(),
          '/registration': (context) => RegistrationPage(),
          '/settings': (context) => SettingsPage(),
        },
      );
    }
  }
}
