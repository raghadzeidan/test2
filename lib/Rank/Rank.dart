import 'package:flutter/material.dart';
import 'package:flutterapp/Progress/ProgressData.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:flutterapp/firebase/FirebaseAPI.dart';

import '../Global.dart';

class Rank extends StatefulWidget {
  @override
  _RankState createState() => _RankState();
}

class _RankState extends State<Rank> {
  List<String> friends=[];
  List<String> friendsUid=[];
  List<int> rank=[];
  List<double> progress=[];
  double semesterHours=0.0;
  double semesterHoursDone=0.0;
  int starRank =1;
  static bool sortProgress=true;
  bool initializing=true;


  void initial()async{
    UserProgress user = await UserProgressDataBase().getUser(FirebaseAPI().getUid());
    friendsUid=await UserDataBase().getUserFriendsList(FirebaseAPI().getUid());
    friends.clear();
    for(String user in friendsUid) {
      friends.add(await UserDataBase().getUserNickname(user));
      rank.add(await UserProgressDataBase().getFriendRank(user));
      progress.add(await UserProgressDataBase().getFriendProgress(user));
    }
    semesterHours=user.getGoal("SemesterHours",null);
    semesterHoursDone=user.getCourseTime("totalTime",null);
    if((semesterHoursDone/semesterHours)>0.2){starRank=2;}
    if((semesterHoursDone/semesterHours)>0.5){starRank=3;}
    if((semesterHoursDone/semesterHours)>0.75){starRank=4;}
    if((semesterHoursDone/semesterHours)>0.9){starRank=5;}
    user.setRank(starRank);
    initializing=false;
    setState(() {});

  }

  @override
  void initState() {
    initial();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(initializing){
      return Loading();
    }
    user.initData(friends,progress,rank);
    return Scaffold(
      body: ListView(
          children: [
            rankStars(starRank),
            _getBodyWidget()
          ]),
    );
  }

  Widget _getBodyWidget() {
    return Container(
      child: HorizontalDataTable(
        leftHandSideColumnWidth: 100,
        rightHandSideColumnWidth: 600,
        isFixedHeader: true,
        headerWidgets: _getTitleWidget(),
        leftSideItemBuilder: _generateFirstColumnRow,
        rightSideItemBuilder: _generateRightHandSideColumnRow,
        itemCount: user.userInfo.length,
        rowSeparatorWidget: const Divider(
          color: Colors.black54,
          height: 1.0,
          thickness: 0.0,
        ),
        leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
        rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
      ),
      height: MediaQuery
          .of(context)
          .size
          .height,
    );
  }

  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget('Name', 100),
      FlatButton(
        padding: EdgeInsets.all(0),
        child: _getTitleItemWidget('Rank', 150),
        onPressed: () {
          sortProgress=false;
          setState(() {});
        },
      ),
      FlatButton(
        padding: EdgeInsets.all(0),
        child: _getTitleItemWidget('Progress', 100),
        onPressed: () {
          sortProgress=true;
          setState(() {});
        },
      ),
    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
      width: width,
      height: 56,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      child: Text(user.userInfo[index].name),
      width: 100,
      height: 52,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return Row(
      children: <Widget>[
        Container(
          child: stars(user.userInfo[index].rank),
          width: 150,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(user.userInfo[index].progress.toString()+"%"),
          width: 200,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
      ],
    );
  }

  Widget rankStars(int rank){
    switch(rank){
      case 1:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.all(5),
                child: Text('Freshman level',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,
                color: Global.getBackgroundColor(600))),
              ),
              Spacer(),
              buildStars(context,Colors.black,Colors.black,Colors.black,Colors.black,Global.goldStars),
            ],
          ),
        );
      case 2:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.all(5),
                child: Text('Junior level',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,
                        color: Global.getBackgroundColor(600))),
              ),
              Spacer(),
              buildStars(context,Colors.black,Colors.black,Colors.black,Global.goldStars,Global.goldStars),
            ],
          ),
        );
      case 3:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.all(5),
                child: Text('Intermediate level',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,
                        color: Global.getBackgroundColor(600))),
              ),
              Spacer(),
              buildStars(context,Colors.black,Colors.black,Global.goldStars,Global.goldStars,Global.goldStars),
            ],
          ),
        );
      case 4:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.all(5),
                child: Text('Doctor level',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,
                        color: Global.getBackgroundColor(600))),
              ),
              Spacer(),
              buildStars(context,Colors.black,Global.goldStars,Global.goldStars,Global.goldStars,Global.goldStars),
            ],
          ),
        );
      case 5:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.all(5),
                child: Text('Professor level',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,
                        color: Global.getBackgroundColor(600))),
              ),
              Spacer(),
              buildStars(context,Global.goldStars,Global.goldStars,Global.goldStars,Global.goldStars,Global.goldStars),
            ],
          ),
        );
    }
    return buildStars(context,Colors.black,Colors.black,Colors.black,Colors.black,Global.goldStars);
  }

  Widget buildStars(BuildContext context, Color color1, Color color2,Color color3,Color color4,Color color5){
    return Row(
      children: <Widget>[
        starIcon(context , color1),
        starIcon(context , color2),
        starIcon(context , color3),
        starIcon(context , color4),
        starIcon(context , color5)
      ],
    );
  }

  starIcon(BuildContext context, Color color) {
    return Align(
        alignment: Alignment.topRight,
        child: color == Colors.black ? Padding(
          padding: const EdgeInsets.all(2),
          child: ImageIcon(AssetImage("images/hat_border.png")),
        ) : Padding(
          padding: const EdgeInsets.all(2),
          child: ImageIcon(AssetImage("images/hat.png")),
        ),
//        IconButton(
//          icon: color == Colors.black ? ImageIcon(AssetImage("images/hat_border.png")) : ImageIcon(AssetImage("images/hat.png")),
////          Icon(color == Colors.black ? Icons.star_border : Icons.star,color: color,),
////          onPressed: () {
//////            showStarDialog(context);
////          },
//        )
    );
  }
}


Widget stars(int rank){
  switch(rank){
    case 1:
      return ImageIcon(AssetImage("images/hat.png"));
//        Icon(Icons.star,color: Global.goldStars,);
    case 2:
      return Row(
        children: <Widget>[
          ImageIcon(AssetImage("images/hat.png")),
          ImageIcon(AssetImage("images/hat.png")),
//          Icon(Icons.star,color: Global.goldStars),
//          Icon(Icons.star,color: Global.goldStars),
        ],
      );
    case 3:
      return Row(
        children: <Widget>[
          ImageIcon(AssetImage("images/hat.png")),
          ImageIcon(AssetImage("images/hat.png")),
          ImageIcon(AssetImage("images/hat.png")),
//          Icon(Icons.star,color: Global.goldStars),
//          Icon(Icons.star,color: Global.goldStars),
//          Icon(Icons.star,color: Global.goldStars),
        ],
      );
    case 4:
      return Row(
        children: <Widget>[
          ImageIcon(AssetImage("images/hat.png")),
          ImageIcon(AssetImage("images/hat.png")),
          ImageIcon(AssetImage("images/hat.png")),
          ImageIcon(AssetImage("images/hat.png")),
//          Icon(Icons.star,color: Global.goldStars),
//          Icon(Icons.star,color: Global.goldStars),
//          Icon(Icons.star,color: Global.goldStars),
//          Icon(Icons.star,color: Global.goldStars),
        ],
      );
    case 5:
      return Row(
        children: <Widget>[
          ImageIcon(AssetImage("images/hat.png")),
          ImageIcon(AssetImage("images/hat.png")),
          ImageIcon(AssetImage("images/hat.png")),
          ImageIcon(AssetImage("images/hat.png")),
          ImageIcon(AssetImage("images/hat.png")),
//          Icon(Icons.star,color: Global.goldStars),
//          Icon(Icons.star,color: Global.goldStars),
//          Icon(Icons.star,color: Global.goldStars),
//          Icon(Icons.star,color: Global.goldStars),
//          Icon(Icons.star,color: Global.goldStars),
        ],
      );
    default:
      return ImageIcon(AssetImage("images/hat.png"));
//        Icon(Icons.star,color: Global.goldStars);
  }
}

User user = User();

class User {
  List<UserInfo> _userInfo = List<UserInfo>();


  void initData(List<String> friends, List<double> progress, List<int> rank){

    _userInfo.clear();
    for (int i = 0; i < friends.length; i++) {

      _userInfo.add(UserInfo(
          friends[i], progress[i], rank[i]));

    }
    _RankState.sortProgress? user.sortProgress():user.sortRank();

  }

  List<UserInfo> get userInfo => _userInfo;

  set userInfo(List<UserInfo> value) {
    _userInfo = value;
  }

  ///
  /// Single sort, sort Name's id
  void sortName(bool isAscending) {
    _userInfo.sort((a, b) {
      int aId = int.tryParse(a.name.replaceFirst('User_', ''));
      int bId = int.tryParse(b.name.replaceFirst('User_', ''));
      return (aId - bId) * (isAscending ? 1 : -1);
    });
  }


  void sortProgress() {
    _userInfo.sort((a, b) {
      double aProg = a.progress;
      double bProg = b.progress;
      return (bProg-aProg).floor();
    });
  }

  void sortRank() {
    _userInfo.sort((a, b) {
      int aProg = a.rank;
      int bProg = b.rank;
      return bProg-aProg;
    });
  }


}

class UserInfo {
  String name;
  double progress;
  int rank;
  UserInfo(this.name,this.progress,this.rank);
}