class BusModel {
  final String arrmsg1;
  final String stNm;
  final int exps1;

  const BusModel({
    required this.arrmsg1,
    required this.stNm,
    required this.exps1,
  });

  @override
  String toString() {
    return 'BusModel{arrmsg1: $arrmsg1, stNm: $stNm, exps1: $exps1}';
  }
}
