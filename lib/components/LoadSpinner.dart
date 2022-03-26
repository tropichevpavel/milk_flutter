
import 'package:flutter/material.dart';

enum LoadState { load, empty, complete}

class LoadSpinner extends StatelessWidget {

  final LoadState state;

  const LoadSpinner(this.state, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Visibility(
    visible: state == LoadState.load || state == LoadState.empty,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
              child: Container(
                padding: const EdgeInsets.only(right: 15),
                child: const SizedBox(
                  width: 15,
                  height: 15,
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                    strokeWidth: 3,
                  ),
                ),
              ),
              visible: state == LoadState.load,
          ),
          Text(state == LoadState.load ? 'Загрузка...' : 'Список пуст...', style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      )
    ),
  );
}
