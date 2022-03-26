
import 'package:flutter/material.dart';

class LoadListView extends StatefulWidget {

  final Function? getData, parser;
  final Function section;

  const LoadListView({this.getData, this.parser, required this.section, Key? key}) : super(key: key);

  @override
  _LoadListViesState createState() => _LoadListViesState();
}

class _LoadListViesState extends State<LoadListView> {

  bool isLoading = true;

  List<dynamic> data = [];

  @override
  initState() { super.initState(); _getData(); }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          child: Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: ListTile(
                leading: !isLoading && data.isEmpty ? null :
                    const CircularProgressIndicator(
                      color: Colors.blue,
                      strokeWidth: 3,
                    ),
                title: Text(!isLoading && data.isEmpty ? 'Список пуст...' : 'Загрузка...', textAlign: TextAlign.center),
              ),
          ),
          visible: isLoading),
        Expanded(child: widget.parser != null ? listViewSection() : listView()),
      ],
    );
  }

  _getData() async {
    setState(() => isLoading = true);

    if (widget.getData != null) {
      data = await widget.getData!();
    }
    setState(() => isLoading = false);
  }

  Widget listView() => CustomScrollView(slivers: [widget.section(data)]);

  Widget listViewSection() => CustomScrollView(
        slivers: widget.parser!(data).map((item) => widget.section(item.header, item.data)).toList().cast<Widget>()
    );
}
