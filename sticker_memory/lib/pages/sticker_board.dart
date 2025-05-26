import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 触覚フィードバック用
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ステッカー台紙',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
      ),
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

  final List<_PlacedSticker> placedStickers = [];
  bool _showStickerPanel = false;

  // 触覚フィードバック用メソッド
  void _provideFeedback() {
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 800;
        final isMobile = constraints.maxWidth <= 600;
        
        if (isTablet) {
          // タブレット・PC用の横並びレイアウト
          return _buildTabletLayout();
        } else {
          // スマホ用の縦並びレイアウト
          return _buildMobileLayout(isMobile);
        }
      },
    );
  }

  Widget _buildTabletLayout() {
    return Scaffold(
      body: Row(
        children: [
          _buildStickerPanel(width: 250),
          Expanded(child: _buildMainArea()),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(bool isMobile) {
    return Scaffold(
      body: Stack(
        children: [
          // メインエリアを常に表示
          Positioned.fill(
            child: _buildMainArea(),
          ),
          // ステッカーパネルをオーバーレイとして表示
          if (_showStickerPanel) ...[
            // 背景オーバーレイ
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _showStickerPanel = false;
                  });
                },
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
            ),
            // ステッカーパネル
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Material(
                elevation: 8,
                child: Container(
                  width: isMobile ? MediaQuery.of(context).size.width * 0.8 : 300,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDDE8E5),
                  ),
                  child: _buildStickerPanelContent(),
                ),
              ),
            ),
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _showStickerPanel = !_showStickerPanel;
          });
        },
        backgroundColor: Colors.teal,
        child: Icon(_showStickerPanel ? Icons.close : Icons.add),
      ),
    );
  }

  Widget _buildStickerPanel({double? width}) {
    return Container(
      width: width,
      color: const Color(0xFFDDE8E5),
      child: _buildStickerPanelContent(),
    );
  }

  Widget _buildStickerPanelContent() {
    return Column(
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
                  final random = Random();
                  setState(() {
                    placedStickers.add(
                      _PlacedSticker(
                        imagePath: stickerImages[index],
                        offset: Offset(
                          random.nextDouble() * 200 + 50, // ランダムな位置に配置
                          random.nextDouble() * 200 + 50,
                        ),
                        scale: 1.0,
                        rotation: 0.0,
                      ),
                    );
                    // スマホでは追加後にパネルを閉じる
                    if (MediaQuery.of(context).size.width <= 600) {
                      _showStickerPanel = false;
                    }
                  });
                  
                  // デバッグ用：ステッカーが追加されたことを確認
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('ステッカーを追加しました (合計: ${placedStickers.length}個)'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(stickerImages[index]),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMainArea() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            'ここにドラッグアンドドロップ！\n(ステッカー長押しでステッカーを削除)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      placedStickers.forEach((s) => s.isSelected = false);
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: const Color(0xFFF7F7F7),
                    ),
                    child: Stack(
                      children: [
                        // デバッグ用：ステッカー数を表示
                        if (placedStickers.isEmpty)
                          const Center(
                            child: Text(
                              'ステッカーを追加してください\n（下の + ボタンをタップ）',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ...placedStickers.asMap().entries.map((entry) {
                          final index = entry.key;
                          final sticker = entry.value;
                          return Positioned(
                            left: sticker.offset.dx,
                            top: sticker.offset.dy,
                            child: GestureDetector(
                              onPanUpdate: (details) {
                                setState(() {
                                  final dx = sticker.offset.dx + details.delta.dx;
                                  final dy = sticker.offset.dy + details.delta.dy;
                                  sticker.offset = Offset(
                                    dx.clamp(0.0, constraints.maxWidth - 80),
                                    dy.clamp(0.0, constraints.maxHeight - 80),
                                  );
                                });
                              },
                              onLongPress: () {
                                _showDeleteDialog(sticker);
                              },
                              onTap: () {
                                setState(() {
                                  // 他のステッカーの選択を解除
                                  for (var s in placedStickers) {
                                    s.isSelected = false;
                                  }
                                  // このステッカーを選択
                                  sticker.isSelected = true;
                                });
                              },
                              child: Transform.rotate(
                                angle: sticker.rotation,
                                child: Transform.scale(
                                  scale: sticker.scale,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      border: sticker.isSelected 
                                        ? Border.all(color: Colors.blue, width: 3)
                                        : Border.all(color: Colors.transparent, width: 3),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      clipBehavior: Clip.none,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(4),
                                            boxShadow: sticker.isSelected ? [
                                              BoxShadow(
                                                color: Colors.blue.withOpacity(0.3),
                                                blurRadius: 8,
                                                spreadRadius: 2,
                                              ),
                                            ] : null,
                                          ),
                                          child: Image.asset(
                                            sticker.imagePath,
                                            width: 80,
                                            height: 80,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Container(
                                                width: 80,
                                                height: 80,
                                                color: Colors.grey[300],
                                                child: Icon(
                                                  Icons.image_not_supported,
                                                  color: Colors.grey[600],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        if (sticker.isSelected) ..._buildControlButtons(sticker),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                        // デバッグ用：右上にステッカー数を表示
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'ステッカー: ${placedStickers.length}個',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          _buildBottomPanel(),
        ],
      ),
    );
  }

  List<Widget> _buildControlButtons(_PlacedSticker sticker) {
    final isMobile = MediaQuery.of(context).size.width <= 600;
    final buttonSize = isMobile ? 40.0 : 32.0;
    final iconSize = isMobile ? 20.0 : 16.0;
    final offset = isMobile ? -28.0 : -24.0; // 当たり判定拡大分を考慮

    return [
      // 回転ボタン（右上）
      Positioned(
        right: offset,
        top: offset,
        child: _buildControlButton(
          size: buttonSize,
          iconSize: iconSize,
          icon: Icons.rotate_right,
          color: Colors.blue,
          onPressed: () {
            setState(() {
              sticker.rotation += pi / 8; // 22.5度ずつ回転
            });
            // 触覚フィードバック（バイブレーション）
            _provideFeedback();
          },
        ),
      ),
      // 拡大ボタン（右下）
      Positioned(
        right: offset,
        bottom: offset,
        child: _buildControlButton(
          size: buttonSize,
          iconSize: iconSize,
          icon: Icons.add,
          color: Colors.green,
          onPressed: () {
            setState(() {
              sticker.scale = (sticker.scale + 0.2).clamp(0.1, 3.0);
            });
            _provideFeedback();
          },
        ),
      ),
      // 縮小ボタン（左下）
      Positioned(
        left: offset,
        bottom: offset,
        child: _buildControlButton(
          size: buttonSize,
          iconSize: iconSize,
          icon: Icons.remove,
          color: Colors.orange,
          onPressed: () {
            setState(() {
              sticker.scale = (sticker.scale - 0.2).clamp(0.1, 3.0);
            });
            _provideFeedback();
          },
        ),
      ),
      // リセットボタン（左上）
      Positioned(
        left: offset,
        top: offset,
        child: _buildControlButton(
          size: buttonSize,
          iconSize: iconSize,
          icon: Icons.refresh,
          color: Colors.purple,
          onPressed: () {
            setState(() {
              sticker.rotation = 0.0;
              sticker.scale = 1.0;
            });
            _provideFeedback();
          },
        ),
      ),
    ];
  }

  Widget _buildControlButton({
    required IconData icon, 
    required VoidCallback onPressed,
    required double size,
    required double iconSize,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onPressed,
      // 当たり判定を大きくするための設定
      behavior: HitTestBehavior.opaque,
      child: Container(
        // 当たり判定のサイズ（実際のボタンより大きく）
        width: size + 16,
        height: size + 16,
        // 中央に実際のボタンを配置
        child: Center(
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              icon, 
              size: iconSize,
              color: color,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomPanel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 400) {
            // スマホの場合は縦並び
            return Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: '台紙のタイトルを入力...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // 保存処理
                    },
                    child: const Text('台紙保存'),
                  ),
                ),
              ],
            );
          } else {
            // タブレット・PCの場合は横並び
            return Row(
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
            );
          }
        },
      ),
    );
  }

  void _showDeleteDialog(_PlacedSticker sticker) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ステッカーを削除'),
        content: const Text('このステッカーを削除しますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                placedStickers.remove(sticker);
              });
              Navigator.of(context).pop();
            },
            child: const Text('削除'),
          ),
        ],
      ),
    );
  }
}

class _PlacedSticker {
  final String imagePath;
  Offset offset;
  double rotation;
  double scale;
  bool isSelected;

  _PlacedSticker({
    required this.imagePath,
    required this.offset,
    this.rotation = 0.0,
    this.scale = 1.0,
    this.isSelected = false,
  });
}