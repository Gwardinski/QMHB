import 'package:flutter/material.dart';
import 'package:qmhb/shared/widgets/star_rating.dart';

class SummaryTile extends StatelessWidget {
  final String line1;
  final String line2;
  final String line3;
  final int starValue;
  final int numberValue;
  final Function onTap;

  const SummaryTile({
    Key key,
    @required this.line1,
    @required this.line2,
    @required this.line3,
    @required this.starValue,
    @required this.numberValue,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        width: 120,
        color: Color(0xff6D6D6D),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(child: Text(line1)),
              Column(
                children: <Widget>[
                  Text(line2),
                  StarRatingRow(rating: starValue),
                ],
              ),
              Column(
                children: <Widget>[
                  Text(line3),
                  Text(
                    numberValue.toString(),
                    style: TextStyle(
                      color: Color(0xffFFA630),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
