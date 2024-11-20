import 'package:flappy_bird/flappy_game/data/data_app.dart';
import 'package:flappy_bird/flappy_game/flappy_game.dart';
import 'package:flappy_bird/flappy_game/models/data_score_model.dart';
import 'package:flappy_bird/flappy_game/models/score_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class HighScoreScreen extends StatefulWidget {
  const HighScoreScreen({Key? key, required this.game}) : super(key: key);

  final FlappyGame game;

  @override
  State<HighScoreScreen> createState() => _HighScoreScreenState();
}

class _HighScoreScreenState extends State<HighScoreScreen> {
  DataScoreModel score = DataScoreModel(data: []);

  @override
  void initState() {
    score = Provider.of<DataScoreModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Center(
      child: Material(
        color: Colors.black38,
        child: SizedBox(
          height: size.height,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Highest score",
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontFamily: 'Game',
                ),
              ),
              const SizedBox(height: 20.0),
              SingleChildScrollView(
                child: SizedBox(
                  height: size.height * .4,
                  child: ListView.builder(
                      itemCount: score.data.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index){
                        ScoreModel item = score.data[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 5.0, left: 10.0, right: 10.0),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(item.timeScore ?? '', style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontFamily: 'Game',
                                  ))
                              ),
                              Expanded(
                                  child: Text("${item.score ?? 0}", style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontFamily: 'Game',
                                  ), textAlign: TextAlign.right)
                              ),
                            ],
                          ),
                        );
                      }),
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(onPressed: (){
                Future.delayed(const Duration(milliseconds: 100),(){
                  widget.game.overlays.remove(DataApp.highScore);
                  widget.game.overlays.add(DataApp.gameOver);
                });
              },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child: const Text("Back", style: TextStyle(fontSize: 20),)),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: (){
                Future.delayed(const Duration(milliseconds: 100),(){
                  widget.game.overlays.remove(DataApp.highScore);
                  widget.game.bird.reset();
                  widget.game.resumeEngine();
                });
              }, style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child: const Text("Restart", style: TextStyle(fontSize: 20),))
            ],
          ),
        ),
      ),
    );
  }
}
