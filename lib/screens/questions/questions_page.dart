import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/shared/widgets/summarys/question_summary.dart';

class QuestionsScreen extends StatefulWidget {
  @override
  _QuestionsPageState createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsScreen> {
  @override
  Widget build(BuildContext context) {
    final questions = Provider.of<List<QuestionModel>>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Questions"),
        actions: <Widget>[
          FlatButton(
            child: Text('Filter'),
            onPressed: _filterQuestionsBottomSheet,
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              // open search
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          return QuestionSummary(
            questionModel: questions[index],
            onAddQuestion: (QuestionModel question) {
              _addQuestionBottomSheet();
            },
            onSummaryTap: (QuestionModel question) {
              _openQuestionSummary(question);
            },
          );
        },
      ),
    );
  }

  _filterQuestionsBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 400,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: FlatButton(
                      child: Text("Category"),
                      onPressed: () {},
                    ),
                  ),
                  Expanded(
                    child: FlatButton(
                      child: Text("Difficulty"),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                      title: Text('Catagory Name $index'),
                      value: false,
                      onChanged: (val) => {},
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openQuestionSummary(QuestionModel question) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: <Widget>[
                  Text(question.question),
                  Padding(padding: EdgeInsets.only(top: 16)),
                  Text(
                    question.answer,
                    style: TextStyle(
                      color: Color(0xffFFA630),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 4)),
                  Divider(),
                  Padding(padding: EdgeInsets.only(top: 8)),
                  Text(question.category),
                  Padding(padding: EdgeInsets.only(top: 8)),
                  Text(question.points.toString()),
                  Padding(padding: EdgeInsets.only(top: 8)),
                  Text("Uploader"),
                  Padding(padding: EdgeInsets.only(top: 8)),
                  Text("Something else"),
                  Padding(padding: EdgeInsets.only(top: 8)),
                  Text("Something else"),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _addQuestionBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 400,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: FlatButton.icon(
                      icon: Icon(Icons.arrow_drop_down),
                      label: Text("By Recent"),
                      onPressed: () {},
                    ),
                  ),
                  Expanded(
                    child: FlatButton.icon(
                      icon: Icon(Icons.arrow_drop_down),
                      label: Text("By Title"),
                      onPressed: () {},
                    ),
                  ),
                  Expanded(
                    child: FlatButton(
                      color: Color(0xffFFA630),
                      child: Text(
                        "New Round",
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                      activeColor: Color(0xffFFA630),
                      checkColor: Colors.grey[900],
                      value: index != 2 ? false : true,
                      title: Text('My Round $index'),
                      onChanged: (val) => {},
                    );
                  },
                ),
              ),
              Container(
                height: 60,
                width: double.infinity,
                child: FlatButton(
                  onPressed: () {},
                  child: Text(
                    "Update Selected Rounds with Question",
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
