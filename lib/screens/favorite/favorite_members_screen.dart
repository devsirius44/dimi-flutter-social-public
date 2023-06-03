import 'package:flutter/material.dart';
import 'package:social_app/firebase/dashboard_manage.dart';
import 'package:social_app/models/new_member.dart';
import 'package:social_app/screens/common_widget/bottom_region.dart';
import 'package:social_app/screens/favorite/favorite_members_item_big.dart';
import 'package:social_app/screens/favorite/favorite_members_item_small.dart';
import 'package:social_app/screens/user_detail/user_detail_screen.dart';
import 'package:social_app/utils/singletons/global.dart';

class FavoriteMembersScreen extends StatefulWidget {

  const FavoriteMembersScreen({Key key}) : super(key: key);
  @override
  FavoriteMembersScreenState createState() => FavoriteMembersScreenState();
}

class FavoriteMembersScreenState extends State<FavoriteMembersScreen> {

  bool bigMode = true;  
  List<NewMember> favoriteMembers = [];
  
  void loadMembers() async {
      favoriteMembers = await DashboardManage.getFavoritedMembers(); //getNewestMembers();
      if(favoriteMembers.length == 0) {
        Global.showToastMessage('There is not newest members.');
      }
      setState(() {
        
      });
  }
  
  @override
  void initState() {
    super.initState();    
    loadMembers();
  }
  
  void goToUserDetailScreen(NewMember user){
     Navigator.push(context, MaterialPageRoute(builder: (context) => UserDetailScreen(member: user)));
  }
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          child: SingleChildScrollView(
            child: Column(children: <Widget>[
              Visibility(
                visible: false,
                child: Container(
                  color: Color(0xFFEBEBEC),
                  margin: EdgeInsets.only(left: 15, right:15, bottom: 10),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Image.asset('assets/images/small-heart-icon.png', width: 12, fit: BoxFit.fitWidth),
                        ),
                        SizedBox(width: 5,),
                        Expanded(
                          child: Text('Christine, Spontaneous added you as\nfavorite', style: TextStyle(color: Color(0xff69666b), fontFamily: 'Lato-Heavy', fontSize: 15),),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
                      Image.asset('assets/images/photos/christina-photo.png', width: 25, fit: BoxFit.fitWidth),
                      SizedBox(width: 7),
                      Image.asset('assets/images/photos/spontaneous-photo.png', width: 25, fit: BoxFit.fitWidth),
                    ]),
                  ]),
                ),
              ),

              Column(
                children: List.generate(favoriteMembers.length, (int index) {
                  if(bigMode) {
                    return FavoriteMembersItemBig(member: favoriteMembers[index], onPressed: () {

                      goToUserDetailScreen(favoriteMembers[index]);  

                    },);
                  } else {
                    return FavoriteMembersItemSmall(member: favoriteMembers[index]);
                  }
                }),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    bigMode = !bigMode; 
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Image.asset('assets/images/ring-icon.png', width: 40, fit: BoxFit.fitWidth),
                ),
              ),
              BottomRegion()
            ],),
          ),
        ),
        
        // _progressHUD,

      ],

    );
  }
}