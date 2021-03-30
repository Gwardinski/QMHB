import 'package:flutter/material.dart';

class AddItemIntoItemButton extends StatelessWidget {
  const AddItemIntoItemButton({
    Key key,
    @required this.contains,
    @required this.onTap,
  });

  final Function contains;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      width: 64,
      height: 64,
      child: FlatButton(
        onPressed: onTap,
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
