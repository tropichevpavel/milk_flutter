import 'package:flutter/material.dart';
import 'package:milk/utils/DateTimeExt.dart';

class DatePickerButton extends StatelessWidget {
  final DateTimeExt date;
  final Function onChange;

  const DatePickerButton(this.date, this.onChange, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => OutlinedButton(
      onPressed: () async => onChange(await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: date,
          lastDate: DateTime(2030))),
      child: Text(date.getDMY()));
}
