import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'score_model.g.dart';

@HiveType(typeId: 1)
class ScoreModel extends ChangeNotifier with HiveObjectMixin {
  @HiveField(0)
  String? id;
  @HiveField(1, defaultValue: 0)
  int? score;
  @HiveField(2)
  String? timeScore;
  @HiveField(3)
  String? userName;

  ScoreModel({
    this.id,
    this.score,
    this.timeScore,
    this.userName
  });

  ScoreModel.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    score = json['score'];
    timeScore = json['timeScore'];
    userName = json['userName'];
  }

  static List<ScoreModel> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((e) => ScoreModel.fromJson(e)).toList();
  }

  Map<String, Object?> toJson() {
    return {
      "id": id,
      "score": score,
      "timeScore": timeScore,
      "userName": userName
    };
  }

  Color getBackgroundColorByIndex(int index) {
    Color color = Colors.yellowAccent;
    switch (index) {
      case 1:
        color = const Color(0xFFFFD700);
        break;
      case 2:
        color = const Color(0xFFC0C0C0);
        break;
      case 3:
        color = const Color(0xFFB87333);
    }
    return color;
  }

}