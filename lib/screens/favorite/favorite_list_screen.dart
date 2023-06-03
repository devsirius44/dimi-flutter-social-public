import 'package:flutter/material.dart';
import 'package:social_app/firebase/dashboard_manage.dart';
import 'package:social_app/models/new_member.dart';
import 'package:social_app/screens/common_widget/bottom_region.dart';
import 'package:social_app/screens/favorite/favorite_list_item_big.dart';
import 'package:social_app/screens/favorite/favorite_list_item_small.dart';
import 'package:social_app/screens/user_detail/photo_list_screen.dart';
import 'package:social_app/screens/user_detail/user_detail_screen.dart';

enum FavoriteMode {
  FavoritedMe,
  Favorite,
  ViewedMe,
}

class FavoriteListScreen extends StatefulWidget {
  final Function onLoadStarted;
  final FavoriteMode fMode;

  const FavoriteListScreen({Key key, this.fMode = FavoriteMode.Favorite, this.onLoadStarted}) : super(key: key);
 
  @override
  FavoriteListScreenState createState() => FavoriteListScreenState();
}

class FavoriteListScreenState extends State<FavoriteListScreen> {
  
  bool bigMode = true;
  List<NewMember> favoriteList = [];
  List<NewMember> lastFavorMeList = [];
  String lastFavorMeNames = '';
  List<String> lastFavorMePhotos = [];
  
  void loadMembers()  async {
    if(widget.fMode == FavoriteMode.FavoritedMe){      
      favoriteList = await DashboardManage.getFavoritedMeMembers();
    } else if(widget.fMode == FavoriteMode.Favorite){
      favoriteList = await DashboardManage.getFavoritedMembers();
    } else if(widget.fMode == FavoriteMode.ViewedMe){
      favoriteList = await DashboardManage.getViewedMeMembers();
      lastFavorMeList = await DashboardManage.getLastFavoritedMeMembers();
      for(int i=0; i<lastFavorMeList.length; i++){
        NewMember user = lastFavorMeList[i];
        lastFavorMeNames += user.name;
        lastFavorMePhotos.add(user.photoUrl);

        if(i < lastFavorMeList.length -1) {
          lastFavorMeNames += ', ';
        }
      }
    }
    setState(() {
      
    });
    widget.onLoadStarted(false);
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
    return Container(
      child: SingleChildScrollView(
        child: Column(children: <Widget>[
          
          Visibility(
            visible: widget.fMode == FavoriteMode.ViewedMe ? true : false,
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
                      child: Text('${lastFavorMeNames} added you as\nfavorite', style: TextStyle(color: Color(0xff69666b), fontFamily: 'Lato-Heavy', fontSize: 15),),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Container(
                  height: 50,
                  child: PhotoListScreen(photoList: lastFavorMePhotos, reverseFlag: true,),
                ),
              ]),
            ),
          ),

          Column(
            children: List.generate(favoriteList.length, (int index) {
              if(bigMode) {
                return FavoriteListItemBig(member: favoriteList[index], onPressed: () {
                  goToUserDetailScreen(favoriteList[index]);  
                },);
              } else {
                 return FavoriteListItemSmall(member: favoriteList[index]);
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
    );
  }
}