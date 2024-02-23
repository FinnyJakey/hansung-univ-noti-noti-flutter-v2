import 'package:flutter/material.dart';
import 'package:hansungunivnotinoti/service/utils.dart';

class BusWidget extends StatelessWidget {
  const BusWidget({super.key, required this.arrmsg1, required this.stNm, required this.exps1});

  final String arrmsg1;
  final String stNm;
  final int exps1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6),
      child: Row(
        children: [
          Text(stNm.replaceAll(".", "\n")),
          const Spacer(),
          Text(
            leftTimeConvert(exps1),
            style: const TextStyle(
              color: Colors.red,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            "[${removeBrackets(arrmsg1)}]",
            style: const TextStyle(
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }
}
