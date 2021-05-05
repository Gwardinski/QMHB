import 'package:flutter/material.dart';

class LibrarySideBarItem extends StatelessWidget {
  const LibrarySideBarItem({
    Key key,
    @required this.onTap,
    @required this.title,
    @required this.val1,
    this.val2,
    this.highlight = false,
    this.lowlight = false,
    this.edgePadding = false,
  }) : super(key: key);

  final Function onTap;
  final String title;
  final String val1;
  final String val2;
  final bool highlight;
  final bool lowlight;
  final bool edgePadding;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 64,
        padding: EdgeInsets.all(16),
        child: Center(
          child: Container(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(right: 16),
                    child: Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 14,
                        color: !lowlight && !highlight
                            ? Theme.of(context).appBarTheme.color
                            : highlight
                                ? Theme.of(context).accentColor
                                : Colors.grey,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 32,
                      child: Text(
                        val1,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    val2 != null
                        ? Container(
                            width: 16,
                            child: Text(
                              val2,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          )
                        : Container(),
                    Container(
                      width: edgePadding ? 32 : 0,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
