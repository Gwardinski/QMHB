import 'package:flutter/material.dart';

class PageWrapper extends StatelessWidget {
  final Widget child;

  PageWrapper({
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 1800,
            ),
            child: child,
          ),
        ),
        width > 2000
            ? Row(
                children: [
                  Container(
                    color: Colors.pink,
                    child: Container(
                      width: 200,
                      color: Colors.grey,
                      child: Text("Ad Space"),
                    ),
                  ),
                ],
              )
            : Container(),
      ],
    );
  }
}
