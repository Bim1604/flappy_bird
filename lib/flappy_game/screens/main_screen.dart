import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flappy_bird/extension/string_exs.dart';
import 'package:flappy_bird/flappy_game/components/textfield/textfield_component.dart';
import 'package:flappy_bird/flappy_game/data/data_app.dart';
import 'package:flappy_bird/flappy_game/data/data_firestore.dart';
import 'package:flappy_bird/util/snack_bar_utils.dart';
import 'package:flappy_bird/util/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:flappy_bird/flappy_game/data/asset.dart';
import 'package:flappy_bird/flappy_game/flappy_game.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainMenuScreen extends StatefulWidget {
  final FlappyGame game;
  const MainMenuScreen({super.key, required this.game});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  TextEditingController nameController = TextEditingController();
  bool hasName = false;
  late SharedPreferences prefs;

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString(DataApp.charName);
    if (!StringUtils.isNullOrWhite(name)) {
      if (mounted) {
        setState(() {
          hasName = true;
          nameController.text = name!;
        });
      }
    }
  }

  Future<String> registerUsername() async {
    String err = "";
    if (nameController.text == "") {
      err = 'Empty username !!!';
      return err;
    }
    QuerySnapshot result = await widget.game.db.collection(DataFireStore.user).get();
    int valid = result.docs.indexWhere((element) => ((element.data() as  Map<dynamic,dynamic>)["userNName"] as String) == nameController.text);
    if (valid > -1) {
      err = "Username already exists !!!";
    }
    return err;
  }

  void setNameChar(BuildContext context) async {
    String err = await registerUsername();
    if (err.isNotEmpty) {
      SnackBarUtil.onShowSnackBar(context, title: "Opps !! ", content: err, contentType: ContentType.failure);
      return;
    }
    await widget.game.db.collection(DataFireStore.user).add(nameController.text.toJson(DataFireStore.userField));
    prefs.setString(DataApp.charName, nameController.text);
    SnackBarUtil.onShowSnackBar(context, title: "Opps !! ", content: "Registered successfully. Your username is ${nameController.text}");
    if (mounted) {
      setState(() {
        hasName = true;
      });
    }
  }

  void clearUser() {
    prefs.setString(DataApp.charName, "");
    if (mounted) {
      setState(() {
        hasName = false;
        nameController.text = "";
      });
    }
  }

  Widget getWidgetByName() {
    Widget result = Container(
      margin: const EdgeInsets.only(bottom: 40.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 60.0),
            child: TextFieldComponent(
              controller: nameController,
              height: 40,
              radius: 50,
              backgroundColor: Colors.orange,
              onChanged: (value){
                if (mounted) {
                  setState(() {

                  });
                }
              },
            ),
          ),
          Visibility(
              visible: nameController.text.isNotEmpty,
              child: Positioned(
                right: 10,
                child: Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF64E1DC),
                        Color(0xFFA3D977),
                      ],
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                        onTap: (){
                          FocusManager.instance.primaryFocus?.unfocus();
                          setNameChar(context);
                        },
                        borderRadius: BorderRadius.circular(50.0),
                        splashColor: Colors.green,
                        child: const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Icon(Icons.check, color: Colors.white, weight: 2, size: 23,),
                        )),
                  ),
                ),
              )
          )
        ],
      ),
    );
    if (hasName) {
      result = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Welcome, ${nameController.text.toUpperCase()}", style: const TextStyle(fontSize: 30, color: Colors.white )),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: (){
            Future.delayed(const Duration(milliseconds: 100),(){
              widget.game.overlays.remove(DataApp.mainMenu);
              widget.game.bird.reset();
              widget.game.resumeEngine();
            });
          }, style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text("Start", style: TextStyle(fontSize: 20),)),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: (){
            Future.delayed(const Duration(milliseconds: 100),(){
              widget.game.overlays.remove(DataApp.mainMenu);
              widget.game.overlays.add(DataApp.highScore);
            });
          }, style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text("Game Score", style: TextStyle(fontSize: 20),)),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: (){
            clearUser();
          }, style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text("Logout", style: TextStyle(fontSize: 20),))
        ],
      );
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    widget.game.pauseEngine;
    return Scaffold(
      body: Material(
        color: Colors.black38,
        child: Container(
          width: size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.menu),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: getWidgetByName(),
          ),
        ),
      ),
    );
  }
}