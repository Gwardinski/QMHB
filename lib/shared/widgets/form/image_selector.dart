import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qmhb/shared/widgets/image_switcher.dart';

class ImageSelector extends StatelessWidget {
  const ImageSelector({
    Key key,
    @required this.fileImage,
    @required this.networkImage,
    @required this.selectImage,
    @required this.removeImage,
  });

  final File fileImage;
  final String networkImage;
  final Function selectImage;
  final Function removeImage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: selectImage,
          child: Container(
            width: 240,
            height: 240,
            child: ImageSwitcher(
              fileImage: fileImage,
              networkImage: networkImage,
              showNoImageText: true,
            ),
          ),
        ),
        Container(
          height: 44,
          width: 240,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                child: Container(
                  width: 120,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Center(child: Text("Select")),
                ),
                onTap: selectImage,
                // ImageCapture()
              ),
              InkWell(
                child: Container(
                  width: 120,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Center(child: Text("Remove")),
                ),
                onTap: selectImage,
                // ImageCapture()
              ),
            ],
          ),
        ),
      ],
    );
  }
}
