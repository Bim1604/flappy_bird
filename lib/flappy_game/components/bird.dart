import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flappy_bird/flappy_game/data/data_app.dart';
import 'package:flappy_bird/flappy_game/data/data_firestore.dart';
import 'package:flappy_bird/flappy_game/data/data_local_link.dart';
import 'package:flappy_bird/flappy_game/models/data_score_model.dart';
import 'package:flappy_bird/flappy_game/models/score_model.dart';
import 'package:flutter/material.dart';
import 'package:flappy_bird/flappy_game/data/asset.dart';
import 'package:flappy_bird/flappy_game/config/bird_movement.dart';
import 'package:flappy_bird/flappy_game/config/config.dart';
import 'package:flappy_bird/flappy_game/flappy_game.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class Bird extends SpriteGroupComponent<BirdMovement> with HasGameRef<FlappyGame>, CollisionCallbacks {
  Bird();

  int score = 0;



  @override
  FutureOr<void> onLoad() async {
    final birdMidFlap = await gameRef.loadSprite(Assets.birdMidFlap);
    final birdUpFlap = await gameRef.loadSprite(Assets.birdUpFlap);
    final birdDownFlap = await gameRef.loadSprite(Assets.birdDownFlap);

    size = Vector2(50, 40);
    current = BirdMovement.middle;
    position = Vector2(50, gameRef.size.y / 2 - size.y / 2);
    sprites = {
      BirdMovement.middle: birdMidFlap,
      BirdMovement.down: birdDownFlap,
      BirdMovement.up: birdUpFlap,
    };

    add(RectangleHitbox());
    game.pauseEngine();
    return super.onLoad();
  }

  void fly() {
    add(
      MoveByEffect(
        Vector2(0, Config.gravity),
        EffectController(duration: 0.2, curve: Curves.decelerate),
        onComplete: () => current = BirdMovement.down,
      )
    );
    current = BirdMovement.up;
    FlameAudio.play(Assets.flying);
  }

  @override
  void update(double dt) {
    position.y += Config.birdVelocity * dt;
    if (position.y < 1) {
      gameOver();
    }
    super.update(dt);
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    gameOver();
  }

  void gameOver() async {
    try {
      FlameAudio.play(Assets.collision);
      gameRef.isHit = true;
      gameRef.overlays.add(DataApp.gameOver);
      gameRef.pauseEngine();
      late Box<DataScoreModel> box;
      if (!Hive.isBoxOpen(DataLocalLink.scoreData)) {
        box = await Hive.openBox<DataScoreModel>(DataLocalLink.scoreData);
      } else {
        box = Hive.box<DataScoreModel>(DataLocalLink.scoreData);
      }
      QuerySnapshot result = await gameRef.db.collection(DataFireStore.score).get();
      DataScoreModel data = DataScoreModel(data: []);
      await box.clear();
      for (var item in result.docs) {
        ScoreModel model = ScoreModel.fromJson(item.data() as Map<dynamic,dynamic>);
        data.addDataScore(model);
      }
      final prefs = await SharedPreferences.getInstance();
      var uuid = const Uuid();
      ScoreModel model = ScoreModel(
        id: uuid.v4(),
        userName: prefs.getString(DataApp.charName),
        score: score,
        timeScore: DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())
      );
      data.addDataScore(model);
      gameRef.dataScore.saveScore(data, boxInit: box, context: gameRef.context);
      await gameRef.pushDataScore(model);
    } catch (e) {
      print(e);
    }
  }

  void reset() {
    score = 0;
    position = Vector2(50, gameRef.size.y / 2 - size.y / 2);
  }
}