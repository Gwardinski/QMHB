import 'package:flutter/material.dart';

class AddItemIntoItemButton extends StatefulWidget {
  const AddItemIntoItemButton({
    Key key,
    @required this.title,
    @required this.contains,
    @required this.onTap,
  });

  final String title;
  final Function contains;
  final Function onTap;

  @override
  _AddItemIntoItemButtonState createState() => _AddItemIntoItemButtonState();
}

class _AddItemIntoItemButtonState extends State<AddItemIntoItemButton> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  onTap() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await widget.onTap();
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
                  child: _isLoading
                      ? Container(height: 24, width: 24, child: CircularProgressIndicator())
                      : Icon(
                          widget.contains()
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
