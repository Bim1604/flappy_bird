import 'package:flappy_bird/flappy_game/data/data_firestore.dart';
import 'package:flappy_bird/flappy_game/data/data_local_link.dart';
import 'package:flappy_bird/flappy_game/models/score_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

part 'data_score_model.g.dart';

@HiveType(typeId: 2)
class DataScoreModel extends ChangeNotifier with HiveObjectMixin{

  DataScoreModel({required this.data, this.keyScore});
  @HiveField(0)
  List<ScoreModel> data = List.empty(growable: true);
  String? keyScore;

  DataScoreModel.fromJson(Map<dynamic, dynamic> map) {
    data = ScoreModel.fromJsonList(map['data']);
    keyScore = map['key'];
  }

  void addDataScore(ScoreModel model) {
    data.add(model);
    notifyListeners();
  }

  void saveScore(DataScoreModel model, {required Box<DataScoreModel> boxInit, required BuildContext context}) async {
    try {
      if (model.data.length > DataFireStore.highScoreLength) {
        ScoreModel? minScoreItem;
        int indexUpdate = -1;
        if (model.data.isNotEmpty) {
          minScoreItem = model.data.reduce((value, element) => (value.score ?? 0) < (element.score ?? 0) ? value : element);
          indexUpdate = model.data.indexOf(minScoreItem);
        }
        model.data.removeAt(indexUpdate);
      }
      final scoreProvider = Provider.of<DataScoreModel>(context, listen: false);
      scoreProvider.data = model.data;
      model.data.sort((a,b) => (b.score ?? 0).compareTo(a.score ?? 0));
      await boxInit.put(ObjectData.scoreObject, model);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}