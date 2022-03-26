
import 'package:flutter/material.dart';

class LoadButton extends StatefulWidget {
  
  final String text, textComplete, textError;
  final Function onTap, ui;
  final bool disabled;
  
  const LoadButton({required this.onTap, required this.ui, String? text, String? textComplete, String? textError, bool? disabled, Key? key}) :
        text = text ?? 'Сохранить',
        textComplete = textComplete ?? 'Сохранено',
        textError = textError ?? 'Ошибка',
        disabled = disabled ?? false,
        super(key: key);

  @override
  _LoadButtonState createState() => _LoadButtonState();
}

enum ButtonState { init, loading, complete, error }

class _LoadButtonState extends State<LoadButton> {

  ButtonState state = ButtonState.init;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,

      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: state == ButtonState.complete ? Colors.green : state == ButtonState.error ? Colors.red : Colors.blue),
        onPressed: widget.disabled || state == ButtonState.loading ? null : () async {
          setState(() => state = ButtonState.loading);

          if (await widget.onTap()) {
            setState(() => state = ButtonState.complete);

            await Future.delayed(const Duration(seconds: 1));

            widget.ui();

          } else {
            setState(() => state = ButtonState.error);

            await Future.delayed(const Duration(seconds: 2));

            setState(() => state = ButtonState.init);
          }
        },
        child: state == ButtonState.loading ?
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 1.5,
              ),
            ) :
            Text(state == ButtonState.init ? widget.text : state == ButtonState.complete ? widget.textComplete : widget.textError)
      ),
    );
  }
}