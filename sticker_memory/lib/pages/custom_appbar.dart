import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_account.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return AppBar(
      automaticallyImplyLeading: true, // ← 自動で戻るボタン表示
      title: Center(child: Text(title, style: const TextStyle(fontSize: 18))),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            // 設定ページへ遷移する処理
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Center(
            child: Text(
              user?.displayName ?? 'No name',
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false,
              );
            },
            child: Text(
              'ログアウト',
              style: TextStyle(
                color: Colors.black, // AppBarに合わせて白文字
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
