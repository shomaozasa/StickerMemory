import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/sticker_board.dart';
import 'pages/registration_sticker.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Multi Page App',
      theme: ThemeData(primarySwatch: Colors.teal),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/sticker': (context) => const StickerBoardPage(),
        '/stamp': (context) => ImagePickerPage(),
      },
    );
  }
}
