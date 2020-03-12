import 'package:flutter/material.dart';

class FormInput extends StatelessWidget {
  final onChanged;
  final validate;
  final labelText;
  final obscureText;
  final disabled;

  const FormInput({
    Key key,
    @required this.onChanged,
    @required this.validate,
    @required this.labelText,
    this.obscureText = false,
    this.disabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: TextFormField(
        enabled: disabled != true,
        validator: validate,
        onChanged: onChanged,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            color: Colors.white,
          ),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(
              width: 2.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(
              width: 2.0,
              color: Color(0xffFFA630),
            ),
          ),
        ),
      ),
    );
  }
}
