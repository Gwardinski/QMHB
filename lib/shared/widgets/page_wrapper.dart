import 'package:flutter/material.dart';

class AppWrapper extends StatelessWidget {
  final Widget child;

  AppWrapper({
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 2200,
            ),
            child: child,
          ),
        ),
        width > 2200
            ? Flexible(
                child: Scaffold(
                  body: Column(
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          color: Colors.grey,
                          child: Center(
                            child: Text("Ad Space"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
