import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';
import 'package:transparent_image/transparent_image.dart';

class ImageSwitcher extends StatelessWidget {
  const ImageSwitcher({
    this.fileImage,
    this.networkImage,
    this.showNoImageText,
  });

  final File fileImage;
  final String networkImage;
  final bool showNoImageText;

  @override
  Widget build(BuildContext context) {
    return fileImage != null
        ? Image.file(
            fileImage,
            fit: BoxFit.cover,
          )
        : (networkImage != null)
            ? Stack(
                children: [
                  Center(child: LoadingSpinnerHourGlass()),
                  Container(
                    width: double.infinity,
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: networkImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              )
            : Container(
                color: Theme.of(context).primaryColorDark,
                child: Center(
                  child: Text(
                    showNoImageText == true ? "No Image!" : '',
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              );
  }
}
