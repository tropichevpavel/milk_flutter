import 'package:flutter/material.dart';

class DropDownButton extends StatelessWidget {
  final String hint;
  final int? value;
  final Function(int?)? onChange;
  final List<dynamic> items;

  const DropDownButton(this.hint, this.items, this.value, this.onChange,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        isExpanded: true,
        hint: Text(hint),
        items: _array2Drop(items),
        value: value,
        onChanged: onChange);
  }

  List<DropdownMenuItem<int>> _array2Drop(List<dynamic> data) {
    List<DropdownMenuItem<int>> dropDown = [];
    for (var el in data) {
      dropDown.add(DropdownMenuItem(
          child: Text(el.name, overflow: TextOverflow.ellipsis), value: el.id));
    }

    return dropDown;
  }
}
