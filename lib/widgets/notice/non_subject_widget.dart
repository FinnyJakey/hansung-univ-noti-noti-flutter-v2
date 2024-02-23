import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hansungunivnotinoti/views/web_view/web_view.dart';

class NonSubjectWidget extends StatefulWidget {
  const NonSubjectWidget({super.key, this.image, required this.deadline, this.point, required this.writer, required this.title, required this.regDate, required this.link});
  final String? image;
  final String deadline;
  final String? point;
  final String writer;
  final String title;
  final String regDate;
  final String link;

  @override
  State<NonSubjectWidget> createState() => _NonSubjectWidgetState();
}

class _NonSubjectWidgetState extends State<NonSubjectWidget> {
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.network(
                widget.image ?? "https://hsportal.hansung.ac.kr/modules/eco/images/noimage.png",
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(2.0),
                ),
                width: 40,
                height: 40,
                // padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.deadline,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (widget.point != null)
                      Text(
                        "P ${widget.point}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.writer,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.blue.shade900,
            ),
          ),
          const Spacer(),
          Text(
            widget.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const Spacer(),
          Text(
            widget.regDate,
            maxLines: 2,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => WebView(link: widget.link)));
      },
    );
  }
}
