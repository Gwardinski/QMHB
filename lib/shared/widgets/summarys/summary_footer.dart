import 'package:flutter/material.dart';

class SummaryRowFooter extends StatelessWidget {
  const SummaryRowFooter({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 16),
      child: Divider(),
    );
  }
}
