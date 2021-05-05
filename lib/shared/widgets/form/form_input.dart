import 'package:flutter/material.dart';
import 'package:qmhb/models/state_models/app_size.dart';

import '../../../get_it.dart';

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
      constraints: BoxConstraints(
        minHeight: 80,
        maxWidth: 700,
        minWidth: 200,
      ),
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
          filled: false,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            borderSide: BorderSide(
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(getIt<AppSize>().borderRadius),
            ),
            borderSide: BorderSide(
              width: 2.0,
              color: Theme.of(context).accentColor,
            ),
          ),
          errorStyle: TextStyle(
            fontSize: 12.0,
            height: 1,
          ),
        ),
      ),
    );
  }
}
