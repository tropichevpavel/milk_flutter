
import 'package:flutter/material.dart';

class DocPage extends StatelessWidget {

  final int _id;

  DocPage(this._id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Документ $_id')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Text('Даные документа #$_id')
      ),
    );
  }
}