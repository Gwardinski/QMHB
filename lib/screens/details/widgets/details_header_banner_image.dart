import 'dart:ui';

import 'package:flutter/material.dart';

class DetailsHeaderBannerImage extends StatelessWidget {
  const DetailsHeaderBannerImage({
    Key key,
    @required this.imageURL,
  }) : super(key: key);

  final String imageURL;

  @override
  Widget build(BuildContext context) {
    return imageURL != null
        ? Container(
            width: double.infinity,
            height: 120,
            margin: EdgeInsets.only(bottom: 32),
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                alignment: Alignment.center,
                matchTextDirection: true,
                repeat: ImageRepeat.noRepeat,
                image: NetworkImage(imageURL),
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Theme.of(context).accentColor.withOpacity(0.1),
                    ],
                    stops: [0.0, 1.0],
                  ),
                ),
              ),
            ),
          )
        : Container(
            height: 40,
          );
  }
}
