import 'package:flutter/material.dart';

class QuestionListItemRevealButton extends StatelessWidget {
  const QuestionListItemRevealButton({
    Key key,
    @required this.revealAnswer,
    @required this.onTap,
    @required this.type,
  }) : super(key: key);

  final bool revealAnswer;
  final onTap;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      width: 64,
      height: 64,
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Icon(
                  type == "MUSIC"
                      ? Icons.music_note
                      : type == "PICTURE"
                          ? Icons.image
                          : Icons.remove_red_eye,
                  size: 24,
                  color: revealAnswer ? Theme.of(context).accentColor : Colors.white,
                ),
              ),
            ],
          ),
        ),
        onPressed: onTap,
      ),
    );
  }
}
