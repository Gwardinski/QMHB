// import 'package:flutter/material.dart';

// class StarRatingForm extends StatefulWidget {
//   final int rating;
//   final Function onTap;
//   StarRatingForm({
//     Key key,
//     this.rating,
//     @required this.onTap,
//   }) : super(key: key);

//   @override
//   _StarRatingFormState createState() => _StarRatingFormState();
// }

// class _StarRatingFormState extends State<StarRatingForm> {
//   int rating;

//   @override
//   Widget build(BuildContext context) {
//     rating = widget.rating ?? 1;
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: <Widget>[
//         Expanded(
//           child: Container(
//             height: 20,
//             child: ListView.builder(
//               itemCount: 5,
//               scrollDirection: Axis.horizontal,
//               itemBuilder: (BuildContext context, int index) {
//                 return GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       rating = index + 1;
//                       widget.onTap(rating);
//                     });
//                   },
//                   child: Icon(
//                     Icons.star,
//                     size: 20,
//                     color: index < rating ? Theme.of(context).accentColor : Color(0xffFFFFF0),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
