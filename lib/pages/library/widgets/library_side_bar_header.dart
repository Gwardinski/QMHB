import 'package:flutter/material.dart';

class LibarySidebarHeader extends StatelessWidget {
  final title;
  final header1;
  final header2;
  final header3;
  final tooltip1;
  final tooltip2;
  final tooltip3;

  LibarySidebarHeader({
    @required this.title,
    @required this.header1,
    @required this.header2,
    @required this.header3,
    @required this.tooltip1,
    @required this.tooltip2,
    @required this.tooltip3,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Container(
            height: 32,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          Container(
            height: 32,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    width: 32,
                    child: Tooltip(
                      message: tooltip1,
                      child: Text(
                        header1,
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 32,
                  child: Tooltip(
                    message: tooltip2,
                    child: Text(
                      header2,
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                ),
                Container(
                  width: 16,
                  child: Tooltip(
                    message: tooltip3,
                    child: Text(
                      header3,
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
