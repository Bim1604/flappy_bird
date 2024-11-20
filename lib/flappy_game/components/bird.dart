import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flappy_bird/flappy_game/data/data_app.dart';
import 'package:flappy_bird/flappy_game/models/score_model.dart';
import 'package:flutter/material.dart';
import 'package:flappy_bird/flappy_game/data/asset.dart';
import 'package:flappy_bird/flappy_game/config/bird_movement.dart';
import 'package:flappy_bird/flappy_game/config/config.dart';
import 'package:flappy_bird/flappy_game/flappy_game.dart';
import 'package:intl/intl.dart';

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

  void gameOver() {
    FlameAudio.play(Assets.collision);
    gameRef.isHit = true;
    gameRef.overlays.add(DataApp.gameOver);
    ScoreModel model = ScoreModel(
      id: 0,
      map: 0,
      score: score,
      timeScore: DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())
    );
    gameRef.dataScore.saveScore(model);
    gameRef.pauseEngine();
  }

  void reset() {
    score = 0;
    position = Vector2(50, gameRef.size.y / 2 - size.y / 2);
  }
}