import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hansungunivnotinoti/views/web_view/web_view.dart';

class NoticeWidget extends StatelessWidget {
  const NoticeWidget({super.key, required this.title, required this.date, required this.writer, required this.link, this.isAnnouncement = false});

  final String title;
  final String date;
  final String writer;
  final String link;
  final bool isAnnouncement;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              TextSpan(
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                children: [
                  if (isAnnouncement)
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFD34C5A),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        child: const Text(
                          "공지",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  if (isAnnouncement) const WidgetSpan(child: SizedBox(width: 4)),
                  TextSpan(
                    text: title,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "$date | $writer",
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => WebView(link: link)));
      },
    );
  }
}
