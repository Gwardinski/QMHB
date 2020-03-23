import 'package:flutter/material.dart';
import 'package:qmhb/models/category_model.dart';

class FormDropdown extends StatefulWidget {
  final Function(String) onSelect;
  final String initialValue;
  FormDropdown({
    Key key,
    this.onSelect,
    this.initialValue,
  }) : super(key: key);

  @override
  _FormDropdownState createState() => _FormDropdownState();
}

class _FormDropdownState extends State<FormDropdown> {
  String dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.initialValue ?? acceptedCategories[0];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DropdownButton<String>(
            value: dropdownValue,
            icon: Padding(padding: EdgeInsets.only(left: 8), child: Icon(Icons.arrow_downward)),
            style: TextStyle(color: Color(0xffFFA630)),
            onChanged: (String newValue) {
              setState(() {
                dropdownValue = newValue;
                widget.onSelect(newValue);
              });
            },
            items: acceptedCategories.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value ?? 'err',
                child: Text(value ?? 'err'),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
