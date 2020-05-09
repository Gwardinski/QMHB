import 'package:flutter/material.dart';

class FormInput extends StatelessWidget {
  final initialValue;
  final onChanged;
  final validate;
  final labelText;
  final obscureText;
  final disabled;
  final keyboardType;

  const FormInput({
    Key key,
    this.initialValue,
    @required this.onChanged,
    @required this.validate,
    @required this.labelText,
    this.obscureText = false,
    this.disabled = false,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 16),
      child: TextFormField(
        initialValue: initialValue,
        enabled: disabled != true,
        validator: validate,
        maxLines: keyboardType == TextInputType.multiline ? 5 : 1,
        onChanged: onChanged,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          alignLabelWithHint: true,
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
          errorStyle: TextStyle(
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }
}
