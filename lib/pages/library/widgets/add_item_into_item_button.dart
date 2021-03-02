import 'package:flutter/material.dart';

class AddItemIntoItemButton extends StatefulWidget {
  const AddItemIntoItemButton({
    Key key,
    @required this.title,
    @required this.doesContain,
    @required this.onTap,
  });

  final String title;
  final bool doesContain;
  final Function onTap;

  @override
  _AddItemIntoItemButtonState createState() => _AddItemIntoItemButtonState();
}

class _AddItemIntoItemButtonState extends State<AddItemIntoItemButton> {
  bool isLoading = false;

  Future<void> onTap() async {
    setState(() {
      isLoading = true;
    });
    await widget.onTap();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
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
                    widget.title,
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
                          widget.doesContain
                              ? Icons.check_box
                              : Icons.check_box_outline_blank_outlined,
                          size: 24,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
