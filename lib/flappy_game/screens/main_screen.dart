import 'package:flappy_bird/flappy_game/data/data_app.dart';
import 'package:flutter/material.dart';
import 'package:flappy_bird/flappy_game/data/asset.dart';
import 'package:flappy_bird/flappy_game/flappy_game.dart';

class MainMenuScreen extends StatelessWidget {
  final FlappyGame game;
  const MainMenuScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    game.pauseEngine;
    return Scaffold(
      body: GestureDetector(
        onTap:() {
          game.overlays.remove(DataApp.mainMenu);
          game.resumeEngine();
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.menu),
              fit: BoxFit.cover,
            ), 
          ),
          child: Image.asset(Assets.message),
        ),
      ),
    );
  }

}