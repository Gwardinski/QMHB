import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qmhb/shared/widgets/image_switcher.dart';

class EditorSideBarDetails extends StatelessWidget {
  const EditorSideBarDetails({
    Key key,
    @required this.header,
    @required this.titleValue,
    @required this.fileImage,
    @required this.networkImage,
    @required this.descriptionValue,
  }) : super(key: key);

  final String header;
  final String titleValue;
  final String descriptionValue;
  final File fileImage;
  final String networkImage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 240,
          child: ImageSwitcher(
            fileImage: fileImage,
            networkImage: networkImage,
            showNoImageText: true,
          ),
        ),
        Container(
          height: 16,
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Title",
            style: TextStyle(
              fontSize: 10,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Text(titleValue),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Description",
            style: TextStyle(
              fontSize: 10,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Text(descriptionValue),
        ),
      ],
    );
  }
}
