
import 'package:flutter/material.dart';

class HighlightText extends StatelessWidget {

	final String text, mark;

	const HighlightText(this.text, this.mark, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
		List<TextSpan> span = [];
		int last = 0, cur = 0;

		while ((mark.isNotEmpty &&
			(cur = text.toLowerCase().indexOf(mark, last)) != -1) ||
			last != text.length) {
			span.add(TextSpan(
				text: (mark.isEmpty || cur == -1)
					? text.substring(last)
					: text.substring(last, cur)));

			if (mark.isNotEmpty && cur != -1) {
				span.add(TextSpan(
					text: text.substring(cur, cur + mark.length),
					style: const TextStyle(
						color: Colors.white, backgroundColor: Colors.blue)));
			}

			last = (mark.isEmpty || cur == -1) ? text.length : (cur + mark.length);
		}

		return Text.rich(TextSpan(children: span));
	}

}