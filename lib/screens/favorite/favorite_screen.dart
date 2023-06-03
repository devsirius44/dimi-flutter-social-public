import 'dart:io';

import 'package:flutter/material.dart';
import 'package:social_app/screens/common_widget/app_popup_menu.dart';
import 'package:social_app/screens/common_widget/decorated_tab_bar.dart';
import 'package:social_app/screens/dashboard/nav_menu.dart';
import 'package:social_app/screens/favorite/favorite_list_screen.dart';
import 'package:social_app/screens/login_screen.dart';
import 'package:social_app/screens/profile/profile_screen.dart';
import 'package:social_app/utils/singletons/global.dart';
import 'package:social_app/utils/singletons/session_manager.dart';
import 'package:progress_hud/progress_hud.dart';

class FavoriteScreen extends StatefulWidget {
  final int tabIndex;

  const FavoriteScreen({Key key, this.tabIndex = 1}) : super(key: key);
  @override  
  FavoriteScreenState createState() => FavoriteScreenState();
}

class FavoriteScreenState extends State<FavoriteScreen> {
  ProgressHUD _progressHudLoad;
  final GlobalKey dropdownKey = GlobalKey();
  bool showDropdownList = false;
  String email;
  int tapIndex = 0;

  @override
  void initState() {
    super.initState();
    email = SessionManager.getEmail();
    _progressHudLoad = new ProgressHUD(loading: true, backgroundColor: Colors.black12, color: Color(0xFF493f4e),
      containerColor: Color(0xddd1d1de), borderRadius: 5.0, text: 'Loading...',);    
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
              }, child: Align(alignment: Alignment.centerRight, child: Image.file(File(SessionManager.getAvatarPath(email)), height: 70))),
            
            ],
          ),

          drawer: Drawer(
            child: NavMenu(onMenuItemClicked: (value) {
              
            }, onClose: () {
              Navigator.pop(context);
            }),
          ),
          
          body:Container(
            width: MediaQuery.of(context).size.width,

            child: DefaultTabController(
              length: 3,
              initialIndex: widget.tabIndex,
              child: Column(
                children: <Widget>[
                  Container(
                    child: DecoratedTabBar(
                      tabBar: TabBar(
                        isScrollable: true,
                        tabs: [
                          Tab(text: "FAVORITED ME"),
                          Tab(text: "FAVORITES"),
                          Tab(text: "VIEWED ME"),
                        ],
                        labelColor: Color(0xff4a414e),
                        labelStyle: TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.w700, fontFamily: 'Lao-Heavy'),
                        unselectedLabelColor: Color(0xff69666b),
                        unselectedLabelStyle: TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.w400, fontFamily: 'Lao-Heavy'),
                        indicatorColor: Colors.orange,
                        onTap: (index){
                          if(index != tapIndex){
                            _progressHudLoad.state.show();
                            tapIndex = index;
                          }
                        },
                      ),
                      decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xff4a414e),
                          width: 2.0,
                        ),
                      ),
                    ),
                    ), 
                  ),
                  Expanded(
                    child: TabBarView(
                      children: <Widget>[
                        FavoriteListScreen(fMode: FavoriteMode.FavoritedMe, onLoadStarted: (hudFlag){
                          setState(() {
                            if(!hudFlag) {
                              _progressHudLoad.state.dismiss();
                            }
                          });
                        },),
                        FavoriteListScreen(fMode: FavoriteMode.Favorite, onLoadStarted: (hudFlag){
                          setState(() {
                            if(!hudFlag){
                              _progressHudLoad.state.dismiss();
                            }
                          });
                        },),
                        FavoriteListScreen(fMode: FavoriteMode.ViewedMe, onLoadStarted: (hudFlag) {
                          setState(() {
                            if(!hudFlag){
                              _progressHudLoad.state.dismiss();
                            }
                          });
                        },),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ) 
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
        ),

        _progressHudLoad

      ],
    );
  }
}