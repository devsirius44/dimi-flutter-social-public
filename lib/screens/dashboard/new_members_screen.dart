import 'package:flutter/material.dart';
import 'package:social_app/firebase/auth_manage.dart';
import 'package:social_app/models/new_member.dart';
import 'package:social_app/models/user_tbl.dart';
import 'package:social_app/screens/common_widget/bottom_region.dart';
import 'package:social_app/screens/dashboard/new_members_item_big.dart';
import 'package:social_app/screens/dashboard/new_members_item_small.dart';
import 'package:social_app/screens/user_detail/user_detail_screen.dart';
import 'package:social_app/utils/singletons/global.dart';

class NewMembersScreen extends StatefulWidget {
  //final Function onHubstarted;
  final List<NewMember> newMembers;
  const NewMembersScreen({Key key, this.newMembers, }) : super(key: key);
  @override
  NewMembersScreenState createState() => NewMembersScreenState();
}

class NewMembersScreenState extends State<NewMembersScreen> {
  bool bigMode = true;  
  
  @override
  void initState() {
    super.initState();
  }
  
  Future<void> goToUserDetailScreen(NewMember user) async {
    UserTbl peer = await AuthManage.getPeerInfo(user.id);
    user.online = Global.getPeerOnlineState(peer.email);
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
                children: List.generate(widget.newMembers.length, (int index) {
                  if(bigMode) {
                    return NewMembersItemBig(member: widget.newMembers[index], onPressed: () {

                      goToUserDetailScreen(widget.newMembers[index]);  

                    },);
                  } else {
                    return NewMembersItemSmall(member: widget.newMembers[index]);
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