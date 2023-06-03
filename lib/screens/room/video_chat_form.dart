import 'dart:io';

import 'package:flutter_webrtc/webrtc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/blocs/chatbloc/chat_bloc.dart';
import 'package:social_app/blocs/chatbloc/chat_event.dart';
import 'package:social_app/blocs/chatbloc/chat_state.dart';
import 'package:social_app/models/chat.dart';
import 'package:social_app/screens/message/chat_screen/chat_box_region.dart';
import 'package:social_app/screens/message/chat_screen/message_send_region.dart';
import 'package:social_app/screens/common_widget/app_popup_menu.dart';
import 'package:social_app/screens/common_widget/bottom_region.dart';
import 'package:social_app/screens/dashboard/nav_menu.dart';
import 'package:social_app/screens/login_screen.dart';
import 'package:social_app/screens/profile/profile_screen.dart';
import 'package:social_app/utils/singletons/global.dart';
import 'package:social_app/utils/singletons/session_manager.dart';

class VideoChatForm extends StatefulWidget {
  //final bool peerOnline;
  final Chat chat;
  
  const VideoChatForm({Key key, this.chat}) : super(key: key);
  @override
  VideoChatFormState createState() => VideoChatFormState();
}

class VideoChatFormState extends State<VideoChatForm> {
  bool showDropdownList = false;
  String peerIdr='';
  bool isInvite = false; 

  @override
  void initState() {
    super.initState();
    initRenderers();
    _invitePeer(widget.chat.opponentName, false);  // if videocall, false and if screen sharing, true 
  }
  
  @override
  deactivate() {
    super.deactivate();
    if (Global.signaling != null && isInvite) Global.signaling.close();
    Global.localRenderer.dispose();
    Global.remoteRenderer.dispose();
  }

  initRenderers() async {
    await Global.localRenderer.initialize();
    await Global.remoteRenderer.initialize();
  }

  void _invitePeer(String peerName, bool useScreen) async {
    // if(Global.peers == null){
    //   Global.showToastMessage('Video Chat Server does not work perfectly. Please check the server!');
    // } else {
    for(int i=0; i<Global.peers.length; i++){
      var peer = Global.peers[i];
      if(peerName==peer['name']) {
        peerIdr = peer['id'];
      }
    }
    if(peerIdr == ''){
      //     Global.showToastMessage('This User is not in Online.');
      //   } else if (Global.signaling != null && peerIdr != Global.selfId) {
      Global.signaling.invite(peerIdr, 'video', useScreen);
      isInvite = true;
    }
    // }
  }

  _hangUp() {
    if (Global.signaling != null) {
      if(isInvite){
        Global.signaling.bye();
        peerIdr = '';
        isInvite = false;
      } else {
        _invitePeer(widget.chat.opponentName, false);
      }
    }
    this.setState(() {      
    });
  }

  fetchMessages(ChatBloc chatBloc) {
    chatBloc.add(Fetch());
  }
  
  @override
  Widget build(BuildContext context) {
    fetchMessages(BlocProvider.of<ChatBloc>(context));
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
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
                  }, child: Align(alignment: Alignment.centerRight, child: Image.file(File(SessionManager.getAvatarPath(Global.email)), height: 70))),
                
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
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 5,),
                            Row(
                              children: <Widget>[
                                Image.network(widget.chat.opponentAvatar, height: 45,),
                                SizedBox(width: 10,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text('${widget.chat.opponentName}, ${widget.chat.opponentAge} ', style: TextStyle(color: Color(0xff342e37), fontFamily: 'PlayfairDisplay', fontSize: 14),),
                                        Text('age', style: TextStyle(color: Color(0xff342e37), fontFamily: 'PlayfairDisplay-Italic', fontSize: 14),) 
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Image.asset('assets/images/addr-small-icon.png', height: 15,),
                                        Text(widget.chat.opponentLocation, style: TextStyle(color: Color(0xff939094), fontFamily: 'Lato-Regular', fontSize: 11)),
                                      ],
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Container(
                                  height: 40,
                                  padding: EdgeInsets.only(left: 15, right:15),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Color(0xfff2a941),
                                        Color(0xfff2c645)
                                      ],
                                    ),
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.favorite, color: Colors.white, size: 15,),
                                      SizedBox(width: 5,),
                                      Text('FAVORITE', style:TextStyle(color: Colors.white, fontFamily: 'Lato-Regular', fontSize:13, fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                )
                              ],
                            ),

                            SizedBox(height: 40,),
                            peerIdr != '' ? OrientationBuilder(builder: (context, orientation) {
                              return new Container(
                                color: Colors.black,
                                width: MediaQuery.of(context).size.width,
                                height: 400,
                                child: new Stack(fit: StackFit.expand, children: <Widget>[
                                  new RTCVideoView(Global.remoteRenderer),
                                  new Positioned(
                                    right: 15.0,
                                    top: 15.0,
                                    child: new Container(
                                      width: orientation == Orientation.portrait ? 90.0 : 120.0,
                                      height:
                                          orientation == Orientation.portrait ? 120.0 : 90.0,
                                      child: new RTCVideoView(Global.localRenderer),
                                      decoration: new BoxDecoration(color: Colors.black54),
                                    ),
                                  ),
                                ]),
                              );
                            }) : Container(),
                            
                            SizedBox(height: 20,),
                            InkWell(
                              onTap: () {
                                _hangUp();
                              },
                              child: Container(
                                height: 42,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xff443849), width: 1.3)
                                ),
                                child: Center(child: Text(isInvite ? 'STOP' : 'START' ,style: TextStyle(color: Color(0xff4a414e), fontFamily: 'Lato-Regular', fontSize: 12, fontWeight: FontWeight.bold),)),
                              ),
                            ),

                            SizedBox(height: 15,),
                            Stack(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: FractionallySizedBox(
                                    widthFactor: 0.4,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Stack(
                                        children: <Widget>[
                                          LayoutBuilder(
                                            builder: (context, constraints) {
                                              return Stack(
                                                children: <Widget>[
                                                  Image.asset('assets/images/back-frd-button-img.png', height: 40, width: constraints.maxWidth, fit: BoxFit.fill),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 12),
                                                    child: Center(child: Text('BACK', style: TextStyle(color: Color(0xff4a414e), fontFamily: 'Lato-Regular', fontSize: 12, fontWeight: FontWeight.bold),)),
                                                  )
                                                ],
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: FractionallySizedBox(
                                    widthFactor: 0.65,
                                    child: Stack(
                                      children: <Widget>[
                                        LayoutBuilder(
                                          builder: (context, constraints) {
                                            return InkWell(
                                              onTap: () {
                                                Global.showToastMessage('Clicked REPORT AND SKIP Button.');
                                              },
                                              child: Stack(
                                                children: <Widget>[
                                                  Image.asset('assets/images/report-skip-button.png', height: 40, width: constraints.maxWidth, fit: BoxFit.fill),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 12),
                                                    child: Center(child: Text('REPORT AND SKIP', style: TextStyle(color: Color(0xff4a414e), fontFamily: 'Lato-Regular', fontSize: 12, fontWeight: FontWeight.bold))),
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ], 
                            ),
                      
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      Container(
                        child: Column(
                          children: <Widget>[
                            ChatBoxRegion(),
                            Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: MessageSendRegion(),
                            ),
                            SizedBox(height: 7),       
                            BottomRegion(),
                          ],
                        ),
                      )
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
    );
  }
}