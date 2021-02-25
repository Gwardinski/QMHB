import 'package:flutter/material.dart';
import 'package:qmhb/screens/play/select_quiz_page.dart';
import 'package:qmhb/shared/widgets/button_primary.dart';

class PlayScreen extends StatefulWidget {
  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Play"),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(bottom: 16)),
              Container(
                padding: EdgeInsets.all(16),
                child: Text("Casual fun for the pub and car journeys"),
              ),
              ButtonPrimary(
                text: "Host Local",
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SelectQuizToPlayPage(
                          // type: SelectQuizToPlayPageType.LOCAL,
                          ),
                    ),
                  );
                },
              ),
              Padding(padding: EdgeInsets.only(bottom: 16)),
              Container(
                padding: EdgeInsets.all(16),
                child: Text("Have contenstants take part using their own device"),
              ),
              ButtonPrimary(text: "Host Online", onPressed: null),
              Padding(padding: EdgeInsets.only(bottom: 16)),
              Container(
                padding: EdgeInsets.all(16),
                child: Text("Join as a contestant"),
              ),
              ButtonPrimary(text: "Join Online", onPressed: null),
            ],
          ),
        ),
      ),
    );
  }
}
