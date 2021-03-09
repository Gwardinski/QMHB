import 'package:flutter/material.dart';
import 'package:qmhb/get_it.dart';
import 'package:qmhb/models/state_models/app_size.dart';

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
    return TextButton(
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
              color: isSelected
                  ? Theme.of(context).accentColor
                  : Theme.of(context).selectedRowColor,
            ),
            Padding(padding: EdgeInsets.all(getIt<AppSize>().spacingMd)),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                color: isSelected
                    ? Theme.of(context).accentColor
                    : Theme.of(context).selectedRowColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
