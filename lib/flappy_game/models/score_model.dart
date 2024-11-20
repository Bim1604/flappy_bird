import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
part 'score_model.g.dart';

@HiveType(typeId: 1)
class ScoreModel extends ChangeNotifier with HiveObjectMixin {
  @HiveField(0)
  int? id;
  @HiveField(1, defaultValue: 0)
  int? score;
  @HiveField(2)
  String? timeScore;
  @HiveField(3)
  int? map;

  ScoreModel({
    this.id,
    this.score,
    this.timeScore,
    this.map
  });

}