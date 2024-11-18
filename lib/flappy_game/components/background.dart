import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flappy_bird/flappy_game/data/asset.dart';
import 'package:flappy_bird/flappy_game/flappy_game.dart';

class Background extends SpriteComponent with HasGameRef<FlappyGame>{
  Background();

  @override
  FutureOr<void> onLoad() async {
    final backGround = await Flame.images.load(Assets.backgorund);
    size = gameRef.size;
    sprite = Sprite(backGround);
    return super.onLoad();
  }
}