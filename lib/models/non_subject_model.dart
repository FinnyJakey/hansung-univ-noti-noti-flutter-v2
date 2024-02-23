class NonSubjectModel {
  final String? image;
  final String deadline;
  final String? point;
  final String writer;
  final String title;
  final String regDate;
  final String link;

  const NonSubjectModel({
    this.image,
    required this.deadline,
    this.point,
    required this.writer,
    required this.title,
    required this.regDate,
    required this.link,
  });

  @override
  String toString() {
    return 'NonSubjectModel{image: $image, deadline: $deadline, point: $point, writer: $writer, title: $title, regDate: $regDate, link: $link}';
  }
}
