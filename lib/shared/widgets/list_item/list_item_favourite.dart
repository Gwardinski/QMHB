import 'package:flutter/material.dart';

class ListItemFavourite extends StatelessWidget {
  final bool isDisabled;
  final bool isFavourited;
  final Function onTap;

  ListItemFavourite({
    @required this.isDisabled,
    @required this.isFavourited,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          width: 48,
          height: 48,
          child: FlatButton(
            onPressed: onTap,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Icon(
                      isFavourited == true ? Icons.favorite : Icons.favorite_outline,
                      size: 24,
                      color: isDisabled == false ? Theme.of(context).accentColor : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
