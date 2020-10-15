import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qmhb/shared/widgets/button_primary.dart';
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
    return Container(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: selectImage,
            child: Container(
              width: 120,
              height: 120,
              child: ImageSwitcher(
                fileImage: fileImage,
                networkImage: networkImage,
                showNoImageText: true,
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(right: 16)),
          Expanded(
            child: Column(
              children: [
                ButtonPrimary(
                  text: "Select Image",
                  fullWidth: true,
                  onPressed: selectImage,
                  type: ButtonPrimaryType.OUTLINE,
                ),
                Padding(padding: EdgeInsets.only(bottom: 16)),
                ButtonPrimary(
                  text: "Remove Image",
                  fullWidth: true,
                  onPressed: removeImage,
                  type: ButtonPrimaryType.OUTLINE,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
