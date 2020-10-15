import 'package:flutter/material.dart';

class AddToDialogButton extends StatelessWidget {
  const AddToDialogButton({
    Key key,
    @required this.title,
    @required this.contains,
    @required this.isLoading,
  });

  final String title;
  final Function contains;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: EdgeInsets.all(16),
      child: Center(
        child: Container(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 16),
                child: isLoading
                    ? Container(height: 24, width: 24, child: CircularProgressIndicator())
                    : Icon(
                        contains() ? Icons.check_box : Icons.check_box_outline_blank_outlined,
                        size: 24,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
