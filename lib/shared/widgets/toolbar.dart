import 'package:flutter/material.dart';

class Toolbar extends StatelessWidget {
  const Toolbar({
    Key key,
    this.onUpdateSearchString,
  }) : super(key: key);

  final Function onUpdateSearchString;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.search),
                hintText: 'Search...',
              ),
              onChanged: onUpdateSearchString,
            ),
          ),
        ],
      ),
    );
  }
}
