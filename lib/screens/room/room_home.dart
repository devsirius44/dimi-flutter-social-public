import 'dart:io';
import 'package:flutter/material.dart';
import 'package:social_app/screens/common_widget/app_popup_menu.dart';
import 'package:social_app/screens/common_widget/bottom_region.dart';
import 'package:social_app/screens/common_widget/custom_button.dart';
import 'package:social_app/screens/dashboard/nav_menu.dart';
import 'package:social_app/screens/login_screen.dart';
import 'package:social_app/screens/profile/profile_screen.dart';
import 'package:social_app/screens/room/room_screen.dart';
import 'package:social_app/screens/room/vchat_image_list.dart';
import 'package:social_app/utils/singletons/global.dart';
import 'package:social_app/utils/singletons/session_manager.dart';

class RoomHome extends StatefulWidget {

  const RoomHome({ Key key }) : super(key: key);
  @override
  RoomHomeState createState() => RoomHomeState();
}

class RoomHomeState extends State<RoomHome> {
  String email;
  bool showDropdownList = false;
  List <String> iitems = [
    'assets/images/vchat-startU-icon.png',
    'assets/images/vchat-reportU-icon.png',
    'assets/images/vchat-favoriteU-icon.png'
  ];
  
  List <String> titems = [
    'START',
    'REPORT AND SKIP',
    'FAVORITE'
  ];
  List <String> litems = [
    'Start chat and \n get to know',
    'Block and move \n on to another',
    'To add a person \n to favorites'
  ];

  @override
  void initState() {
    super.initState();

    email = SessionManager.getEmail();
  }
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff4a414e),
            titleSpacing: 0,
            leading: Align(alignment: Alignment.centerLeft, child: Image.asset('assets/images/da-top-icon.png'),),
            title: Row(
              children: <Widget>[
                Builder(
                  builder: (context) {
                    return IconButton(
                      icon: Icon(Icons.menu, color: Colors.white),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    );
                  },
                )
              ],
            ),
            actions: <Widget>[
              InkWell(onTap: () {
                setState(() {
                  showDropdownList = true;
                });
              },
              child: Align(alignment: Alignment.centerRight, child: Image.file(File(SessionManager.getAvatarPath(email)), height: 70))),
            ],
          ),

          drawer: Drawer(
            child: NavMenu(onMenuItemClicked: (value) { },
              onClose: () {
                Navigator.pop(context);
              }
            ),
          ),
          
          body: Container(
            width: MediaQuery.of(context).size.width,
            
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0, bottom: 15.0, left: 30, right: 30),
                    child: CustomButton( text: 'START CHAT', fontSize: 13, onPressed: () {
                      setState(() {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => RoomScreen() ));
                      });
                    },),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Card(
                      elevation: 15,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(bottom: 25),
                        child: Column(
                          children: List.generate(litems.length, (int index){
                            return VChatImageList(imageUrlU: iitems[index], title: titems[index], label: litems[index]);
                          })
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 30,),
                  BottomRegion()
                ],
              ),
            )   
          ),
        ),

        AppPopUpMenu(showDDL: showDropdownList, 
          onAnyPressed: () {
            setState(() {
              showDropdownList = false;
            },);
          }, onProfilePressed: () {
            setState(() {
              showDropdownList = false;
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
            });
          }, onLogOutPressed: () {
            setState(() {
              showDropdownList = false;
              Global.freeSignaling();
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen())); 
            }); 
          },
        )

      ],
    );
  }
}

