import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:qmhb/shared/widgets/button_primary.dart';
import 'package:qmhb/shared/widgets/image_switcher.dart';

class ImageCapture extends StatefulWidget {
  final File fileImage;
  final String networkImage;

  ImageCapture({
    this.networkImage,
    this.fileImage,
  });

  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  File _fileImage;
  String _networkImage;
  final picker = ImagePicker();

  @override
  void initState() {
    _fileImage = widget.fileImage;
    _networkImage = widget.networkImage;
    super.initState();
  }

  Future _pickImage(source) async {
    final pickedFile = await picker.getImage(source: source);
    setState(() {
      if (pickedFile != null) {
        _networkImage = null;
        _fileImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  _cropImage() async {
    File cropped = await ImageCropper.cropImage(sourcePath: _fileImage.path);
    setState(() {
      _fileImage = cropped ?? _fileImage;
    });
  }

  _clear() {
    setState(() {
      _fileImage = null;
    });
  }

  _selectImage() {
    Navigator.of(context).pop(_fileImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.camera),
              onPressed: () => _pickImage(ImageSource.camera),
            ),
            IconButton(
              icon: Icon(Icons.photo_library),
              onPressed: () => _pickImage(ImageSource.gallery),
            ),
            IconButton(
              icon: Icon(Icons.crop),
              onPressed: (_fileImage != null || _networkImage != null) ? _cropImage : null,
            ),
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: (_fileImage != null || _networkImage != null) ? _clear : null,
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("Select Image"),
      ),
      body: (_fileImage != null || _networkImage != null)
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ImageSwitcher(
                    fileImage: _fileImage,
                    networkImage: _networkImage,
                  ),
                ),
                Container(
                  height: 48,
                  margin: EdgeInsets.all(16),
                  child: ButtonPrimary(
                    text: "Use This Image",
                    onPressed: _selectImage,
                    fullWidth: true,
                  ),
                ),
              ],
            )
          : Center(
              child: Container(
                width: 240,
                child: Text(
                  "Using the buttons below, take a new photo or select from your devices gallery",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
    );
  }
}
