import 'package:flutter/material.dart';

import '../theme.dart';

class ConfirmDialog {
  ConfirmDialog(BuildContext c, String text, Function onConfirm) {
    showDialog(context: c, builder: (c) => _Dialog(text, onConfirm));
  }
}

class _Dialog extends StatelessWidget {
  final String text;
  final Function onConfirm;

  const _Dialog(this.text, this.onConfirm, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Dialog(
      insetPadding: EdgeInsets.all(ThemeSize.mainPadding),
      child: Container(
		  width: 400,
        padding: EdgeInsets.all(ThemeSize.mainPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 15),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Отмена')),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onConfirm();
                      },
                      child: const Text('Подтвердить',
                          style: TextStyle(color: Colors.red)))
                ],
              ),
            )
          ],
        ),
      ));
}
