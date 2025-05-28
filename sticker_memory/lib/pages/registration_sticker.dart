import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:sticker_memory/pages/custom_appbar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImagePickerPage extends StatefulWidget {
  @override
  _ImagePickerPageState createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  File? _selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
      File file = File(image.path);
      FirebaseStorage storage = FirebaseStorage.instance;
      try {
        // Firebase Storageに画像をアップロード
        await storage
            .ref('stickers/${file.uri.pathSegments.last}')
            .putFile(file);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('画像がアップロードされました')));
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('アップロードエラー: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'ステッカー登録'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _selectedImage != null
                ? Image.file(
                  _selectedImage!,
                  width: 250,
                  height: 250,
                  fit: BoxFit.cover,
                )
                : Text('画像が選択されていません'),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _pickImage, child: Text('画像を選択')),
          ],
        ),
      ),
    );
  }
}
