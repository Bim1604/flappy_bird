import 'package:flappy_bird/flappy_game/data/data_app.dart';
import 'package:flutter/material.dart';
import 'package:flappy_bird/flappy_game/data/asset.dart';
import 'package:flappy_bird/flappy_game/flappy_game.dart';

class GameOverScreen extends StatelessWidget {
  final FlappyGame game;
  const GameOverScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black38,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Score: ${game.bird.score}",
              style: const TextStyle(
                fontSize: 60,
                color: Colors.white,
                fontFamily: 'Game',
              ),
            ),
            const SizedBox(height: 20),
            Image.asset(Assets.gameOver),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: (){
              Future.delayed(const Duration(milliseconds: 100),(){
                game.overlays.remove(DataApp.gameOver);
                game.bird.reset();
                game.resumeEngine();
              });
            }, 
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text("Restart", style: TextStyle(fontSize: 20),)),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: (){
              Future.delayed(const Duration(milliseconds: 100),(){
                game.overlays.remove(DataApp.gameOver);
                game.overlays.add(DataApp.highScore);
              });
            }, style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text("Game Score", style: TextStyle(fontSize: 20),))
          ],
        ),
      ),
    );
  }
}