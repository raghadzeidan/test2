
import 'package:flutter/material.dart';
import 'package:flutterapp/Tips/CoursesMultiChoice.dart';
import 'package:flutterapp/Tips/Cards.dart';
import 'package:flutterapp/Tips/TipDialog.dart';



class TipsPage extends StatefulWidget {
  @override
  _TipsPageState createState() => _TipsPageState();
}

class _TipsPageState extends State<TipsPage> {

  List<String> usersTags=["general"];



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.blueAccent,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              CoursesMultiChoice(updateUserTags,20),
              Cards(),
            ],
          ),
        ),
      ),
      floatingActionButton: fab(context),
    );
  }

  Widget fab(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Center(
          child: FloatingActionButton.extended(
            onPressed: (){addTip(context, updateState);},
            label: Text("Add Tip"),
            backgroundColor: Colors.blueAccent,
            icon: Icon(Icons.add),
//            shape: new CircleBorder(),
          ),
        )
      ],
    );
  }

  void updateState(){
    setState(() {});
  }

  void updateUserTags(List<String> newUserTags){
    usersTags.clear();
    for(int i=0;i<newUserTags.length;i++){
      usersTags.add(newUserTags[i]);
    }
  }

}

void addTip(BuildContext context, Function callback){
  showModalBottomSheet(
      context: context,
      builder: (context){return TipDialog(callback);},
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      );
}


