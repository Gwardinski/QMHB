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
                  Theme.of(context).accentColor.withOpacity(0),
                ],
                stops: [0, 1],
              ),
            ),
          ),
          ClipRect(
            child: Container(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: FractionalOffset.centerLeft,
                    end: FractionalOffset.centerRight,
                    colors: [
                      Theme.of(context).canvasColor.withOpacity(0.4),
                      Theme.of(context).canvasColor.withOpacity(0.9),
                      Theme.of(context).canvasColor.withOpacity(1),
                    ],
                    stops: [0, 0.25, 1],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: 112,
              width: 64,
              color: Theme.of(context).canvasColor,
            ),
          ),
        ],
      ),
    );
  }
}
