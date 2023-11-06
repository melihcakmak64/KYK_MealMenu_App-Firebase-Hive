class MenuModel {
  String date;
  List<String> kahvalti;
  List<String> aksam;

  MenuModel({required this.date, required this.kahvalti, required this.aksam});

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      date: json['date'],
      kahvalti: List<String>.from(json['kahvalti']),
      aksam: List<String>.from(json['aksam']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'kahvalti': kahvalti,
      'aksam': aksam,
    };
  }
}
