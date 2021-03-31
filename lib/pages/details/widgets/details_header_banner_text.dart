import 'package:flutter/material.dart';

class DetailsHeaderBannerText extends StatelessWidget {
  final String line1;
  final String line2;
  final String line3;

  const DetailsHeaderBannerText({
    Key key,
    @required this.line1,
    @required this.line2,
    @required this.line3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
              line1,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              line2,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              line3,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
