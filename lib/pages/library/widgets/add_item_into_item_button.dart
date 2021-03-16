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
    return Container(
      padding: EdgeInsets.only(left: 16),
      height: 64,
      width: 64,
      child: Center(
        child: _isLoading
            ? Container(height: 24, width: 24, child: CircularProgressIndicator())
            : Icon(
                widget.contains() ? Icons.check_box : Icons.check_box_outline_blank_outlined,
                size: 24,
              ),
      ),
    );
  }
}
