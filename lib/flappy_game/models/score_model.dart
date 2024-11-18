import 'package:hive/hive.dart';

part 'score_model.g.dart';

@HiveType(typeId: 1)
class Score {
  @HiveField(0)
  int? id;
  @HiveField(1, defaultValue: 0)
  int? score;
  String? timeScore;
  @HiveField(3)
  int? map;

  Score({
    this.id,
    this.score,
    this.timeScore,
    this.map
  });
}