class NoticeModel {
  final String title;
  final bool isAnnouncement;
  final String link;
  final String writer;
  final String date;

  const NoticeModel({
    required this.title,
    required this.isAnnouncement,
    required this.link,
    required this.writer,
    required this.date,
  });

  @override
  String toString() {
    return 'NoticeModel{title: $title, isAnnouncement: $isAnnouncement, link: $link, writer: $writer, date: $date}';
  }
}
