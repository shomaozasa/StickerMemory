import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ステッカー台紙',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const StickerBoardPage(),
    );
  }
}

class StickerBoardPage extends StatefulWidget {
  const StickerBoardPage({super.key});

  @override
  State<StickerBoardPage> createState() => _StickerBoardPageState();
}

class _StickerBoardPageState extends State<StickerBoardPage> {
  final List<String> stickerImages = [
    'assets/images/stickers/sakana.png',
    'assets/images/stickers/サモエド.jpg',
  ];

  Future<void> signInAnonymously() async {
  try {
    final userCredential = await FirebaseAuth.instance.signInAnonymously();
    debugPrint('サインイン完了！ユーザーID: ${userCredential.user?.uid}');
  } catch (e) {
      debugPrint('エラー: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    signInAnonymously();
  }

  final List<_PlacedSticker> placedStickers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // ======== 左側のステッカーリスト部分 ========
          Container(
            width: 250,
            color: const Color(0xFFDDE8E5),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'ステッカーを検索...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: stickerImages.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            placedStickers.add(
                              _PlacedSticker(
                                imagePath: stickerImages[index],
                                offset: const Offset(100, 100), // 初期配置位置
                              ),
                            );
                          });
                        },
                        child: Container(
                          color: Colors.white,
                          child: Image.asset(stickerImages[index]),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // ======== 右側のドロップエリア部分 ========
          Expanded(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'ここにドラッグアンドドロップ！',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        color: const Color(0xFFF7F7F7),
                      ),
                      child: Stack(
                        children: [
                          ...placedStickers.map((sticker) {
                            return Positioned(
                              left: sticker.offset.dx,
                              top: sticker.offset.dy,
                              child: Draggable<_PlacedSticker>(
                                data: sticker,
                                feedback: Image.asset(
                                  sticker.imagePath,
                                  width: 80,
                                  height: 80,
                                ),
                                childWhenDragging: const SizedBox.shrink(),
                                onDraggableCanceled: (velocity, offset) {
                                  setState(() {
                                    sticker.offset = offset;
                                  });
                                },
                                child: Image.asset(
                                  sticker.imagePath,
                                  width: 80,
                                  height: 80,
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: '台紙のタイトルを入力...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            // 保存処理
                          },
                          child: const Text('台紙保存'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlacedSticker {
  final String imagePath;
  Offset offset;

  _PlacedSticker({required this.imagePath, required this.offset});
}
