import 'package:flutter/material.dart';
import 'package:qmhb/pages/details/widgets/details_header_profile_image.dart';
import 'package:qmhb/pages/details/widgets/details_header_title_and_type.dart';

class DetailsHeaderImageAndTitle extends StatelessWidget {
  const DetailsHeaderImageAndTitle({
    Key key,
    @required this.type,
    @required this.title,
    @required this.imageUrl,
  }) : super(key: key);

  final String type;
  final String title;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DetailsHeaderProfileImage(
            imageUrl: imageUrl,
          ),
          DetailsHeaderTypeAndTitle(
            type: type,
            title: title,
            hasImage: hasImage,
          ),
        ],
      ),
    );
  }
}
