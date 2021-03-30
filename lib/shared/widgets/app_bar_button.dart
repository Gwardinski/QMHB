import 'package:flutter/material.dart';

class AppBarButton extends StatelessWidget {
  final String title;
  final Function onTap;
  final IconData rightIcon;
  final IconData leftIcon;
  final bool highlight;

  AppBarButton({
    @required this.title,
    @required this.onTap,
    this.leftIcon,
    this.rightIcon,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    bool useLandscape = MediaQuery.of(context).size.width > 800.0;
    return Container(
      height: 64,
      child: MaterialButton(
        onPressed: onTap,
        child: Row(
          children: [
            leftIcon != null
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(leftIcon),
                  )
                : Container(width: useLandscape ? 32 : 0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:
                      highlight ? Theme.of(context).accentColor : Theme.of(context).cardTheme.color,
                ),
              ),
            ),
            rightIcon != null
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(rightIcon),
                  )
                : Container(width: useLandscape ? 32 : 0),
          ],
        ),
      ),
    );
  }
}
