import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/services/navigation_service.dart';

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
                : Container(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: title != null ? 8.0 : 0),
              child: Text(
                title ?? '',
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
                : Container(),
          ],
        ),
      ),
    );
  }
}

class AppBarBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NavigationService navigationService = Provider.of(context);
    return navigationService.isRoot()
        ? Container()
        : Container(
            height: 64,
            child: MaterialButton(
              onPressed: () => navigationService.pop(),
              child: Center(
                child: Icon(Icons.arrow_back_ios),
              ),
            ),
          );
  }
}
