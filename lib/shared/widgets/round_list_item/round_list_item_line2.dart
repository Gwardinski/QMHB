import 'package:flutter/material.dart';

class RoundListItemLine2 extends StatelessWidget {
  const RoundListItemLine2({
    Key key,
    @required this.description,
  }) : super(key: key);

  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      child: Row(
        children: [
          Expanded(
            child: Text(
              description != '' ? description : 'no description',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontStyle: description != '' ? FontStyle.normal : FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }
}