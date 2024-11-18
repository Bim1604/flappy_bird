import 'dart:async';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flappy_bird/flappy_game/data/asset.dart';
import 'package:flappy_bird/flappy_game/components/pipe.dart';
import 'package:flappy_bird/flappy_game/config/config.dart';
import 'package:flappy_bird/flappy_game/flappy_game.dart';
import 'package:flappy_bird/flappy_game/config/pipe_position.dart';

class PipeGround extends PositionComponent with HasGameRef<FlappyGame>{

  PipeGround();

  final _random = Random();

  double getRandomValue () {
    double value = _random.nextDouble();
    try {
      if (value > 0.8) {
        value = getRandomValue();
      }
    } catch (e) {
      print(e);
    }
    return value;
  }

  @override
  FutureOr<void> onLoad() async {
    position.x = gameRef.size.x;
    double valueRandom = getRandomValue();
    final heightMinusGround = gameRef.size.y - Config.groundHeight;
    final spacing = valueRandom < 0.3 ? 150 : 100 + valueRandom *  (heightMinusGround / 4);
    final centerY = spacing + valueRandom * (heightMinusGround - spacing);

    addAll([
      Pipe(height: centerY - spacing / 2, pipePosition: PipePosition.top),
      Pipe(height: heightMinusGround - (centerY + spacing / 2), pipePosition: PipePosition.bottom),
    ]);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    position.x -= Config.gameSpeed * dt;
    if (position.x < - 10) {
      removeFromParent();
      updateScore();
    }
    if (gameRef.isHit == true) {
      removeFromParent();
      gameRef.isHit = false;
    }
    super.update(dt);
  }

  void updateScore () {
    game.bird.score += 1;
    if (game.bird.score == 10) {
      FlameAudio.play(Assets.clap);
    } else if (game.bird.score == 20) {
      FlameAudio.play(Assets.bravo);
    } else if (game.bird.score % 10 == 0 && game.bird.score > 0) {
      FlameAudio.play(Assets.clap);
    } else {
      FlameAudio.play(Assets.point);
    }
  }
}