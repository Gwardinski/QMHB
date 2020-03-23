import 'package:flutter/material.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/screens/questions/question_details_page.dart';

class QuestionListItem extends StatefulWidget {
  final QuestionModel questionModel;

  QuestionListItem({
    Key key,
    @required this.questionModel,
  }) : super(key: key);

  @override
  _QuestionListItemState createState() => _QuestionListItemState();
}

class _QuestionListItemState extends State<QuestionListItem> {
  bool revealAnswer = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => QuestionDetailsPage(
              questionModel: widget.questionModel,
            ),
          ),
        );
      },
      child: Container(
        height: 80,
        color: Color(0xff6D6D6D),
        padding: EdgeInsets.only(left: 8),
        child: Column(
          children: [
            Container(
              height: 40,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      revealAnswer == true
                          ? widget.questionModel.answer
                          : widget.questionModel.question,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.remove_red_eye,
                        color: Color(0xffFFA630),
                      ),
                    ),
                    onTapDown: (d) {
                      setState(() {
                        revealAnswer = true;
                      });
                    },
                    onTapUp: (d) {
                      setState(() {
                        revealAnswer = false;
                      });
                    },
                  )
                ],
              ),
            ),
            Container(
              height: 40,
              child: Row(
                children: <Widget>[
                  Flexible(
                    flex: 2,
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Text("Category: "),
                          Text(
                            widget.questionModel.category,
                            style: TextStyle(
                              color: Color(0xffFFA630),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 8),
                    child: Row(
                      children: <Widget>[
                        Text("Points: "),
                        Text(widget.questionModel.points.toString()),
                      ],
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                      width: 40,
                      height: 40,
                      child: Icon(Icons.add),
                    ),
                    onTap: () {
                      print('add question');
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// _filterQuestionsBottomSheet() {
//   showModalBottomSheet(
//     context: context,
//     builder: (BuildContext context) {
//       return Container(
//         height: 400,
//         child: Column(
//           children: <Widget>[
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Expanded(
//                   child: FlatButton(
//                     child: Text("Category"),
//                     onPressed: () {},
//                   ),
//                 ),
//                 Expanded(
//                   child: FlatButton(
//                     child: Text("Difficulty"),
//                     onPressed: () {},
//                   ),
//                 ),
//               ],
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: 8,
//                 itemBuilder: (context, index) {
//                   return CheckboxListTile(
//                     title: Text('Category Name $index'),
//                     value: false,
//                     onChanged: (val) => {},
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }

// void _openQuestionSummary(QuestionModel question) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return SimpleDialog(
//         children: <Widget>[
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 12),
//             child: Column(
//               children: <Widget>[
//                 Text(question.question),
//                 Padding(padding: EdgeInsets.only(top: 16)),
//                 Text(
//                   question.answer,
//                   style: TextStyle(
//                     color: Color(0xffFFA630),
//                   ),
//                 ),
//                 Padding(padding: EdgeInsets.only(top: 4)),
//                 Divider(),
//                 Padding(padding: EdgeInsets.only(top: 8)),
//                 Text(question.category),
//                 Padding(padding: EdgeInsets.only(top: 8)),
//                 Text(question.points.toString()),
//                 Padding(padding: EdgeInsets.only(top: 8)),
//                 Text("Uploader"),
//                 Padding(padding: EdgeInsets.only(top: 8)),
//                 Text("Something else"),
//                 Padding(padding: EdgeInsets.only(top: 8)),
//                 Text("Something else"),
//               ],
//             ),
//           ),
//         ],
//       );
//     },
//   );
// }

// void _addQuestionBottomSheet() {
//   showModalBottomSheet(
//     context: context,
//     builder: (BuildContext context) {
//       return Container(
//         height: 400,
//         child: Column(
//           children: <Widget>[
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Expanded(
//                   child: FlatButton.icon(
//                     icon: Icon(Icons.arrow_drop_down),
//                     label: Text("By Recent"),
//                     onPressed: () {},
//                   ),
//                 ),
//                 Expanded(
//                   child: FlatButton.icon(
//                     icon: Icon(Icons.arrow_drop_down),
//                     label: Text("By Title"),
//                     onPressed: () {},
//                   ),
//                 ),
//                 Expanded(
//                   child: FlatButton(
//                     color: Color(0xffFFA630),
//                     child: Text(
//                       "New Round",
//                       style: TextStyle(color: Colors.black),
//                     ),
//                     onPressed: () {},
//                   ),
//                 ),
//               ],
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: 20,
//                 itemBuilder: (context, index) {
//                   return CheckboxListTile(
//                     activeColor: Color(0xffFFA630),
//                     checkColor: Colors.grey[900],
//                     value: index != 2 ? false : true,
//                     title: Text('My Round $index'),
//                     onChanged: (val) => {},
//                   );
//                 },
//               ),
//             ),
//             Container(
//               height: 60,
//               width: double.infinity,
//               child: FlatButton(
//                 onPressed: () {},
//                 child: Text(
//                   "Update Selected Rounds with Question",
//                 ),
//               ),
//             )
//           ],
//         ),
//       );
//     },
//   );
// }
