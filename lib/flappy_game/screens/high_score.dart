import 'package:flappy_bird/flappy_game/data/data_app.dart';
import 'package:flappy_bird/flappy_game/flappy_game.dart';
import 'package:flappy_bird/flappy_game/models/data_score_model.dart';
import 'package:flappy_bird/flappy_game/models/score_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HighScoreScreen extends StatefulWidget {
  const HighScoreScreen({Key? key, required this.game}) : super(key: key);

  final FlappyGame game;

  @override
  State<HighScoreScreen> createState() => _HighScoreScreenState();
}

class _HighScoreScreenState extends State<HighScoreScreen> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    final score = Provider.of<DataScoreModel>(context);
    return Center(
      child: Material(
        color: Colors.black38,
        child: Container(
          margin: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.7),
            borderRadius: BorderRadius.circular(10.0)
          ),
          height: size.height * .7,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Highest score",
                style: TextStyle(
                  fontSize: 40,
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
                              Container(
                                padding: const EdgeInsets.all(7.0),
                                margin: const EdgeInsets.only(right: 10.0),
                                decoration: index < 3 ? BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: item.getBackgroundColorByIndex(index + 1),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(.4),
                                      blurRadius: 3,
                                      offset: const Offset(1, 2),
                                    ),
                                  ],
                                ) : null,
                                child: Text((index + 1).toString(), style: TextStyle(color: index < 3 ? Colors.white : Colors.black, fontWeight: FontWeight.w700, fontSize: 16)),
                              ),
                              Expanded(
                                  child: Text(item.userName ?? '', style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500
                                  ))
                              ),
                              Text("${item.score ?? 0}", style: const TextStyle(
                                fontSize: 20,
                                fontFamily: 'Game',
                              ), textAlign: TextAlign.right),
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
                  widget.game.overlays.add(DataApp.mainMenu);
                });
              },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child: const Text("Back", style: TextStyle(fontSize: 20),)),
            ],
          ),
        ),
      ),
    );
  }
}
