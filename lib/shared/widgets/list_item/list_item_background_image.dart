import 'dart:ui';

import 'package:flutter/material.dart';

class ItemBackgroundImage extends StatelessWidget {
  const ItemBackgroundImage({
    Key key,
    @required this.imageUrl,
  }) : super(key: key);

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 112,
      decoration: BoxDecoration(
        image: imageUrl != null
            ? DecorationImage(
                fit: BoxFit.cover,
                alignment: Alignment.center,
                matchTextDirection: true,
                repeat: ImageRepeat.noRepeat,
                image: NetworkImage(imageUrl),
              )
            : null,
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: FractionalOffset.centerLeft,
                end: FractionalOffset.centerRight,
                colors: [
                  Theme.of(context).accentColor.withOpacity(0.2),
                  Theme.of(context).canvasColor,
                ],
                stops: [0.0, 1.0],
              ),
            ),
          ),
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1, sigmaY: 0),
              child: Container(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: FractionalOffset.centerLeft,
                      end: FractionalOffset.centerRight,
                      colors: [
                        Colors.black.withOpacity(0.5),
                        Theme.of(context).canvasColor,
                      ],
                      stops: [0.0, 1.0],
                    ),
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
