import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class StickerRegister extends StatefulWidget {
  @override
  _StickerRegisterState createState() => _StickerRegisterState();
}

class _StickerRegisterState extends State<StickerRegister> {
  String? _fileName;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _fileName = result.files.first.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sticker Register')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(onPressed: _pickFile, child: Text('ファイルを選択')),
            SizedBox(height: 20),
            if (_fileName != null) Text('選択されたファイル: $_fileName'),
          ],
        ),
      ),
    );
  }
}
