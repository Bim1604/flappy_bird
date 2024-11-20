import 'package:flappy_bird/flappy_game/data/data_local_link.dart';
import 'package:flappy_bird/flappy_game/models/score_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'data_score_model.g.dart';

@HiveType(typeId: 2)
class DataScoreModel extends ChangeNotifier with HiveObjectMixin{

  DataScoreModel({required this.data});
  @HiveField(0)
  List<ScoreModel> data;

  void addDataScore(ScoreModel model) {
    data.add(model);
    notifyListeners();
  }

  void saveScore(ScoreModel model) async {
    try {
      if (model.score == null) return;
      late Box<DataScoreModel> box;
      if (!Hive.isBoxOpen(DataLocalLink.scoreData)) {
        box = await Hive.openBox<DataScoreModel>(DataLocalLink.scoreData);
      } else {
        box = Hive.box<DataScoreModel>(DataLocalLink.scoreData);
      }
      final scoreData = box.get(ObjectData.scoreObject);
      if (scoreData == null) return;
      ScoreModel? minScoreItem;
      int indexUpdate = -1;
      if (scoreData.data.isNotEmpty) {
        minScoreItem = scoreData.data.reduce((value, element) => (value.score ?? 0) < (element.score ?? 0) ? value : element);
        indexUpdate = scoreData.data.indexOf(minScoreItem);
      }
      if (scoreData.data.length < 5) {
        scoreData.data.add(model);
      } else {
        if (indexUpdate > -1) {
          scoreData.data[indexUpdate] = model;
        }
      }
      scoreData.data.sort((a,b) => (b.score ?? 0).compareTo(a.score ?? 0));
      await box.put(ObjectData.scoreObject, scoreData);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}