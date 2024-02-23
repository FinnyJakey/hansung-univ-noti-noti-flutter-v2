class CalendarModel {
  final String title;
  final String content;

  const CalendarModel({
    required this.title,
    required this.content,
  });

  @override
  String toString() {
    return 'CalendarModel{title: $title, content: $content}';
  }
}
