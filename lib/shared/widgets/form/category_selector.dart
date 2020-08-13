import 'package:flutter/material.dart';
import 'package:qmhb/models/category_model.dart';

class CategorySelector extends StatefulWidget {
  final Function(String) onSelect;
  final String initialValue;
  CategorySelector({
    Key key,
    this.onSelect,
    this.initialValue,
  }) : super(key: key);

  @override
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  String dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.initialValue ?? acceptedCategories[0];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: DropdownButton<String>(
              value: dropdownValue,
              isExpanded: true,
              icon: Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(Icons.arrow_downward),
              ),
              iconSize: 28,
              style: TextStyle(color: Theme.of(context).accentColor, fontSize: 18),
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
          ),
        ],
      ),
    );
  }
}
