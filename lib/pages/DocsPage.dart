
import 'package:flutter/material.dart';

import '../utils/api.dart';

final List<Doc> docs = [
  Doc(1, 'Документ №1', 1),
  Doc(2, 'Документ №2', 0),
  Doc(3, 'Документ №3', 1),
  Doc(4, 'Документ №4', 0),
  Doc(5, 'Документ №5', 1),
  Doc(6, 'Документ №6', 1),
  Doc(7, 'Документ №7', 0),
  Doc(8, 'Документ №8', 1),
  Doc(9, 'Документ №9', 1),
  Doc(10, 'Документ №10', 2),
];

class DocsPage extends StatelessWidget {

  const DocsPage({Key? key}) : super(key: key);

  // DocsPage() {
  //   _response = _getDocs();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Документы')),
      body: _docsListView(docs),
    );
  }
}

// String _getDocs() {
//   return api.doRequest('docs', '', '');
// }

Widget _docsListView(List<Doc> docs) {
  return ListView.builder(
    itemCount: docs.length,
    itemBuilder: (context, index) {
      return _docsListItem(context, docs[index]);
    },
  );
}

Widget _docsListItem(BuildContext context, Doc doc) {
  return InkWell(
    splashColor: Colors.pink,
    onTap: () => Navigator.pushNamed(context, '/docs/${doc.id}'),
    child: Container(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.only(right: 15),
              child: Icon(doc.type == 0 ? Icons.dangerous : Icons.access_alarm),
            ),
            Text(doc.time)
          ],
        )
    ),
  );
}

class Doc {
  final int id;
  final String time;
  final int type;

  Doc(this.id, this.time, this.type);
}