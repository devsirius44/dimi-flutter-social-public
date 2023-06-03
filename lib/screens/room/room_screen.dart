import 'dart:io';

import 'package:flutter/material.dart';
import 'package:social_app/models/chat.dart';
import 'package:social_app/repositories/chat_repository.dart';
import 'package:social_app/screens/chat_screen.dart';
import 'package:social_app/screens/message/message_list_item.dart';
import 'package:social_app/screens/common_widget/app_popup_menu.dart';
import 'package:social_app/screens/common_widget/bottom_region.dart';
import 'package:social_app/screens/common_widget/search_bar.dart';
import 'package:social_app/screens/dashboard/nav_menu.dart';
import 'package:social_app/screens/profile/profile_screen.dart';
import 'package:social_app/utils/singletons/global.dart';
import 'package:social_app/utils/singletons/session_manager.dart';

class RoomScreen extends StatefulWidget {
  @override
  RoomScreenState createState() => RoomScreenState();
}

class RoomScreenState extends State<RoomScreen> {
  bool showDropdownList = false;
  bool loading = false;
  List<Chat> chatList = [];
  ChatRepository chatRepository;
  String email;
  String userID;

  
  @override
  void initState() {
    super.initState();
    userID = SessionManager.getUserID();
    email = SessionManager.getEmail();
    chatRepository = ChatRepository();
  }

  loadSearchChats(String oppNameKey) {
    setState(() {
      loading = true;
    });
    chatRepository.getSearchAllChats(userID, oppNameKey).then((chats) {
      setState(() {
        loading = false;
      });
      if(chats != null) {
        chatList = chats;
        setState(() {
          // chatList = chats;
        });
      }
    });
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
                children: <Widget>[
                  Container(
                    child: SearchBar(loading: loading,  onSearch: (String query) {
                    loadSearchChats(query);
                      setState(() {
                        
                      });
                    }),
                  ),
                  Column(
                    children: List.generate(chatList.length, (int index) {
                      return ChatListItem(notiflag: true, chat: chatList[index], onPressed:() {
                        bool onlineFlag = Global.getPeerOnlineState(chatList[index].opponentName);
                        if(onlineFlag) {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(chatFlag: false, chat: chatList[index])));
                        } else {
                          Global.showToastMessage('This User is in Offline state. Please do Video Call him after.');
                        }
                      });
                    }),
                  ),
                  BottomRegion()
                ],
              ),
            ),
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
              //print('Please write LOGOUT codes.'); 
            }); 
          },
        )

      ],
    );
  }
}