import 'package:flame/game.dart';
import 'package:flappy_bird/flappy_game/models/score_model.dart';
import 'package:flutter/material.dart';
import 'package:flappy_bird/flappy_game/flappy_game.dart';
import 'package:flappy_bird/flappy_game/screens/game_over.dart';
import 'package:flappy_bird/flappy_game/screens/main_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlappyGame flappyGame = FlappyGame();
  await initHive();
  runApp(
    GameWidget(game: flappyGame, initialActiveOverlays: const [MainMenuScreen.id],
      overlayBuilderMap: {
        'mainMenu': (context, _) => MainMenuScreen(game: flappyGame),
        'gameOver': (context, _) => GameOverScreen(game: flappyGame),
      },)
  );
}

Future<void> initHive() async {
  try {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    Hive.registerAdapter(ScoreAdapter());
  } catch (e) {
    print(e);
  }
}
//
// Future<PlayerData> getPlayerData() async {
//   PlayerData player = PlayerData.getPlayerDataDefault();
//   try {
//     final box = await  Hive.openBox<PlayerData>(DataLocalLink.dataPlayerBox);
//     final playerData = box.get(ObjectData.dataPlayer);
//     if (playerData == null) {
//       box.put(ObjectData.dataPlayer, PlayerData.fromMap(PlayerData.defaultData));
//       player = box.get(ObjectData.dataPlayer)!;
//     } else {
//       if (playerData.ownedSpaceships.isEmpty) {
//         playerData.ownedSpaceships.add(SpaceshipTypes.Dino);
//       }
//       await playerData.save();
//       player = playerData;
//     }
//   } catch (e) {
//     print(e);
//   }
//   return player;
// }