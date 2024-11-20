import 'dart:ffi';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/text.dart';
import 'package:flappy_bird/flappy_game/models/data_score_model.dart';
import 'package:flutter/material.dart';
import 'package:flappy_bird/flappy_game/components/background.dart';
import 'package:flappy_bird/flappy_game/components/bird.dart';
import 'package:flappy_bird/flappy_game/components/ground.dart';
import 'package:flappy_bird/flappy_game/components/pipeGround.dart';
import 'package:flappy_bird/flappy_game/config/config.dart';

class FlappyGame extends FlameGame with TapDetector, HasCollisionDetection{

  final BuildContext context;
  FlappyGame({
    required this.context
  });

  late Bird bird;
  late PipeGround pipeGround;
  late TextComponent score;
  bool isHit = false;
  Timer interval = Timer(Config.pipeInterval, repeat: true);
  DataScoreModel dataScore = DataScoreModel(data: []);

  @override
  Future<void> onLoad() async {
    bird = Bird();
    pipeGround = PipeGround();
    score = buildScore();

    addAll([
      Background(),
      Ground(),
      bird,
      pipeGround,
      score,
    ]);
    interval.onTick = () => add(PipeGround());
  }

  TextComponent buildScore() {
    return TextComponent(
      text: 'Score: 0',
      position: Vector2(size.x / 2, size.y / 2 * .2), 
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 40, fontWeight: FontWeight.bold, fontFamily: 'Game',
        )
      )
    );
  }

  @override
  void onTap() {
    bird.fly();
    super.onTap();
  }

  @override
  void update(double dt) {
    interval.update(dt);
    super.update(dt);

    score.text = "Score :${bird.score}";
  }
}