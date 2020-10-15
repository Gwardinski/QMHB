import 'package:flutter/material.dart';

class ListItemLine2 extends StatelessWidget {
  const ListItemLine2({
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
              description ?? 'no description',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontStyle: description != null ? FontStyle.normal : FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
