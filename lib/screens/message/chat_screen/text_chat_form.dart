import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/blocs/chatbloc/chat_bloc.dart';
import 'package:social_app/blocs/chatbloc/chat_event.dart';
import 'package:social_app/blocs/chatbloc/chat_state.dart';
import 'package:social_app/screens/message/chat_screen/back_button_img.dart';
import 'package:social_app/screens/message/chat_screen/block_dlg_button.dart';
import 'package:social_app/screens/message/chat_screen/chat_box_region.dart';
import 'package:social_app/screens/message/chat_screen/message_send_region.dart';
import 'package:social_app/screens/common_widget/app_popup_menu.dart';
import 'package:social_app/screens/login_screen.dart';
import 'package:social_app/screens/common_widget/bottom_region.dart';
import 'package:social_app/screens/dashboard/nav_menu.dart';
import 'package:social_app/screens/profile/profile_screen.dart';
import 'package:social_app/utils/singletons/global.dart';
import 'package:social_app/utils/singletons/session_manager.dart';
import 'package:social_app/models/models.dart';

class TextChatForm extends StatefulWidget {
  
  final Chat chat;
  const TextChatForm({Key key, this.chat}) : super(key: key);
  
  @override
  TextChatFormState createState() => TextChatFormState();
}

class TextChatFormState extends State<TextChatForm> {
  
  String email;
  bool showDropdownList = false;
  
  @override
  void initState() {
    super.initState();
    
    email = SessionManager.getEmail();
  }
  
  fetchMessages(ChatBloc chatBloc) {
    chatBloc.add(Fetch());
  }
  
  @override
  Widget build(BuildContext context) {
    fetchMessages(BlocProvider.of<ChatBloc>(context));
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        return  Stack(
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
                }, child: Align(alignment: Alignment.centerRight, child: Image.file(File(SessionManager.getAvatarPath(email)), height: 70)))
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
                scrollDirection: Axis.vertical,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Row(              
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10, right: 3),
                                child: BackButtonImg(onPressed: () {
                                  Navigator.pop(context);
                                },),
                              )),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 3, right: 10),
                                child: BlockDlgButton(onPressed: () {
                                  // must add the codes after
                                }),
                              )),
                          ],
                        ),
                      ),
                      ChatBoxRegion(),
                      MessageSendRegion(),
                      BottomRegion(),
                    ],
                  ),
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
              Global.freeSignaling();
              setState(() {
                showDropdownList = false;
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
              }); 
            },
          )
        ],
      );}
    );
  }
}