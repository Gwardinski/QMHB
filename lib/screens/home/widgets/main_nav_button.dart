import 'package:flutter/material.dart';

class MainNavigationButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function onPressed;
  final bool isSelected;

  MainNavigationButton({
    @required this.title,
    @required this.icon,
    @required this.onPressed,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        onPressed();
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 28,
              color:
                  isSelected ? Theme.of(context).accentColor : Theme.of(context).selectedRowColor,
            ),
            Padding(padding: EdgeInsets.only(left: 16)),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                color:
                    isSelected ? Theme.of(context).accentColor : Theme.of(context).selectedRowColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
