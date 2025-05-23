import 'package:firebase_core/firebase_core.dart';
import 'package:flame/game.dart';
import 'package:flappy_bird/firebase_options.dart';
import 'package:flappy_bird/flappy_game/data/data_app.dart';
import 'package:flappy_bird/flappy_game/data/data_local_link.dart';
import 'package:flappy_bird/flappy_game/models/data_score_model.dart';
import 'package:flappy_bird/flappy_game/models/score_model.dart';
import 'package:flappy_bird/flappy_game/screens/high_score.dart';
import 'package:flappy_bird/util/notification_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flappy_bird/flappy_game/flappy_game.dart';
import 'package:flappy_bird/flappy_game/screens/game_over.dart';
import 'package:flappy_bird/flappy_game/screens/main_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  NotificationUtility().initFirebaseNotification();
  FlutterError.onError = (err) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(err);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  await initHive();
  runApp(
      MultiProvider(
          providers: [
            FutureProvider<DataScoreModel>(
              create: (context) => getScoreData(),
              initialData: DataScoreModel(data: [], keyScore: "1"),
            ),
          ],
          builder: (context, child) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider<DataScoreModel>.value(
                  value: Provider.of<DataScoreModel>(context, listen: false),
                ),
              ],
              child: child,
            );
          },
          child: const FlappyGameWidget()
      )
  );
}

class FlappyGameWidget extends StatelessWidget {
  const FlappyGameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FlappyGame flappyGame = FlappyGame(context: context);
    return MaterialApp(
      home: GameWidget(game: flappyGame, initialActiveOverlays: [DataApp.mainMenu],
        overlayBuilderMap: {
          DataApp.mainMenu: (context, _) => MainMenuScreen(game: flappyGame),
          DataApp.gameOver: (context, _) => GameOverScreen(game: flappyGame),
          DataApp.highScore: (context, _) => HighScoreScreen(game: flappyGame),
        },
      ),
    );
  }
}


Future<void> initHive() async {
  try {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    Hive.registerAdapter(ScoreModelAdapter());
    Hive.registerAdapter(DataScoreModelAdapter());
  } catch (e) {
    print(e);
  }
}

//
Future<DataScoreModel> getScoreData() async {
  DataScoreModel scoreData = DataScoreModel(data: []);
  try {
    final box = await  Hive.openBox<DataScoreModel>(DataLocalLink.scoreData);
    final score = box.get(ObjectData.scoreObject);
    if (score == null) {
      box.put(ObjectData.scoreObject, scoreData);
    } else {
      scoreData = box.get(ObjectData.scoreObject)!;
    }
  } catch (e) {
    print(e);
  }
  return scoreData;
}