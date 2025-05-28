import 'package:flutter/material.dart';
import 'package:sticker_memory/pages/custom_appbar.dart';

class StickerViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'ステッカー一覧'),
      body: Center(child: Text("設定ページです")),
    );
  }
}
