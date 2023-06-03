import 'dart:io';
import 'package:flutter/material.dart';
import 'package:social_app/screens/message/message_list_item.dart';
import 'package:social_app/screens/chat_screen.dart';
import 'package:social_app/screens/common_widget/app_popup_menu.dart';
import 'package:social_app/screens/common_widget/bottom_region.dart';
import 'package:social_app/screens/common_widget/loading_indicator.dart';
import 'package:social_app/screens/common_widget/search_bar.dart';
import 'package:social_app/screens/dashboard/nav_menu.dart';
import 'package:social_app/screens/login_screen.dart';
import 'package:social_app/screens/profile/profile_screen.dart';
import 'package:social_app/utils/singletons/global.dart';
import 'package:social_app/utils/singletons/session_manager.dart';
import 'package:social_app/models/models.dart';
import 'package:social_app/repositories/repositories.dart';

class MessageScreen extends StatefulWidget {
  final int tabIndex;

  const MessageScreen({Key key, this.tabIndex = 0}) : super(key: key);
  @override
  MessagesScreenState createState() => MessagesScreenState();
}

class MessagesScreenState extends State<MessageScreen> {
  
  bool showDropdownList = false;
  String email;
  String userID;
  bool loading = false;
  List<Chat> chatList = [];
  ChatRepository chatRepository;

  // loadChats() {
  //   ChatRepository chatRepository = ChatRepository();
  //   chatRepository.getAllChats(userID).then((chats) {
  //     setState(() {
  //       loading = false;
  //     });
  //     if(chats != null) {
  //       setState(() {
  //         chatList = chats;
  //       });
  //     }
  //   });
  // }

  loadSearchChats(String oppNameKey) {
    setState(() {
      loading = true;
    });
    chatRepository.getSearchAllChats(userID, oppNameKey).then((chats) {
      setState(() {
        loading = false;
      });
      if(chats != null) {
        setState(() {
          chatList = chats;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    userID = SessionManager.getUserID();
    email = SessionManager.getEmail();
    chatRepository = ChatRepository();
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
          body: Container(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(children: <Widget>[
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(chatFlag: true, chat: chatList[index])));
                    });
                  }),
                ),
                const SizedBox(height: 10),
                BottomRegion()
              ],),
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
            }); 
          },
        )

      ],
    );
  }
}

