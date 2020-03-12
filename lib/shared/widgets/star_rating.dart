import 'package:flutter/material.dart';

class StarRatingRow extends StatelessWidget {
  final int rating;
  const StarRatingRow({
    Key key,
    @required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          child: Container(
            height: 20,
            child: ListView.builder(
              itemCount: rating,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return Icon(
                  Icons.star,
                  size: 20,
                  color: Color(0xffFFA630),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
