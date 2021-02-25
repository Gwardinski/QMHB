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
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        image: imageURL != null
            ? DecorationImage(
                fit: BoxFit.cover,
                alignment: Alignment.center,
                matchTextDirection: true,
                repeat: ImageRepeat.noRepeat,
                image: NetworkImage(imageURL),
              )
            : null,
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                colors: [
                  Theme.of(context).accentColor.withOpacity(0.2),
                  Theme.of(context).canvasColor.withOpacity(1),
                ],
                stops: [0.0, 1.0],
              ),
            ),
          ),
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1, sigmaY: 0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.1),
                      Theme.of(context).canvasColor.withOpacity(1),
                    ],
                    stops: [0.0, 1.0],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
