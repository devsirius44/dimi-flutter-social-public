import 'package:flutter/material.dart';
import 'package:social_app/firebase/auth_manage.dart';
import 'package:social_app/firebase/dashboard_manage.dart';
import 'package:social_app/models/new_member.dart';
import 'package:social_app/models/user_detail.dart';
import 'package:social_app/screens/chat_screen.dart';
import 'package:social_app/screens/common_widget/back_button.dart';
import 'package:social_app/screens/common_widget/bottom_region.dart';
import 'package:social_app/screens/common_widget/confirm_dialog.dart';
import 'package:social_app/screens/common_widget/decorated_tab_bar.dart';
import 'package:social_app/screens/common_widget/loading_indicator.dart';
import 'package:social_app/screens/common_widget/status_mark_large.dart';
import 'package:social_app/screens/user_detail/photo_list_screen.dart';
import 'package:social_app/utils/singletons/global.dart';
import 'package:social_app/repositories/repositories.dart';
import 'package:social_app/models/models.dart';
import 'package:progress_hud/progress_hud.dart';

class UserDetailScreen extends StatefulWidget {

  final NewMember member;

  const UserDetailScreen({Key key, this.member}) : super(key: key);
  @override
  UserDetailScreenState createState() => UserDetailScreenState();
}

class UserDetailScreenState extends State<UserDetailScreen> {
  ProgressHUD _progressHudLoad;
  bool loadingChat = false;
  bool showDropdownList = false;
  List<String> publicPhotos = [];
  List<String> privatePhotos = [];
  UserDetail usrDetail = UserDetail('', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
  
  getPhotoUrlLists() async {
    await DashboardManage.downlaodUserDetails(widget.member.id);
    setState(() {
      publicPhotos = DashboardManage.getPublicPhotos();
      privatePhotos = DashboardManage.getPrivatePhotos();
      usrDetail = DashboardManage.getUserDetails();
    });
    _progressHudLoad.state.dismiss();

  }
  
  @override
  void initState() {
    super.initState();

      _progressHudLoad = new ProgressHUD(loading: true, backgroundColor: Colors.black12, color: Color(0xFF493f4e),
    containerColor: Color(0xfff2b349), borderRadius: 5.0, text: 'Loading...',);    
    addViewedMember();  
    getPhotoUrlLists();
  }
  
  Future<Chat> getPrivateChat() async {
    String userId = await AuthManage.getFirebaseUserId();  //SessionManager.getUserID();
    ChatRepository chatRepository = ChatRepository();
    setState(() {
      loadingChat = true;
    });
    if(userId == widget.member.id) {
      ConfirmDialog(context, title: 'Message Error!   userId = $userId,   otherId = ${widget.member.id}',).show();
      return null;
    }
    Chat chat = await chatRepository.getPrivateChat(userId, widget.member.id);
    return chat;    
  }

  onMessage() async {    
    Chat rchat = await getPrivateChat();
    setState(() {
      loadingChat = false;
    });
    if(rchat != null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(chat: rchat, chatFlag: true,))); 
    }
  }

  onVideoChat() async {
    Chat rchat = await getPrivateChat();
    setState(() {
      loadingChat = false;
    });
    if(rchat != null) {
      //Navigator.push(context, MaterialPageRoute(builder: (context) => TextChatScreen(chat: chat)));
      if(widget.member.online){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(chat: rchat, chatFlag: false,))); 
      }else{
        Global.showToastMessage('This User is in Offline state. Please do Video Call him after.');
      }
    }
  }

  addFavoriteMember() async {
    bool flag = await DashboardManage.registerFavoriteMember(widget.member.id);
    if(flag) {
      Global.showToastMessage('It was saved successfully.');
    }else{
      Global.showToastMessage('Save was failed.');
    }
  }

  addViewedMember() async {
    bool flag =  await DashboardManage.registerViewMember(widget.member.id);
    if(flag) {
      Global.showToastMessage('It was saved successfully.');
    }else{
      Global.showToastMessage('Save was failed.');
    }

  }
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Scaffold(
          body:Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10),
            child: Stack(
              children: <Widget>[
                DefaultTabController(
                  length: 2,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(7),
                          color: Color(0xffedeced),  //2dbd4a
                          child: Stack(
                            children: <Widget>[
                              Center(child: Image.network(widget.member.photoUrl)),
                              Padding(
                                padding: const EdgeInsets.only(top: 15, right: 15),
                                child: Align(
                                  alignment: Alignment.centerRight, 
                                  child: StatusMarkLarge(widget.member.online ? 'Online' : 'Offline', backgroundColor: widget.member.online ? Color(0xaa1db33b) : Color(0x66000000),)
                                ),
                              ) 
                            ],                         
                          )
                        ),
                        
                        Container(
                          child: DecoratedTabBar(
                            tabBar: TabBar(
                              isScrollable: true,
                              tabs: [
                                Tab(text: "        PUBLIC PHOTOS        "),
                                Tab(text: "       PRIVATE PHOTOS        "),
                              ],
                              labelColor: Color(0xff4a414e),
                              labelStyle: TextStyle(
                                  fontSize: 12.0, fontWeight: FontWeight.w700, fontFamily: 'Lao-Heavy'),
                              unselectedLabelColor: Color(0xff69666b),
                              unselectedLabelStyle: TextStyle(
                                  fontSize: 12.0, fontWeight: FontWeight.w400, fontFamily: 'Lao-Heavy'),
                              indicatorColor: Colors.orange,
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
                        Container(
                          height: 150,
                          child: TabBarView(
                            children: <Widget>[
                              PhotoListScreen(photoList: publicPhotos),
                              PhotoListScreen(photoList: privatePhotos),
                            ],
                          ),
                        ),
                        
                        Padding(
                          padding: const EdgeInsets.only(left: 7, bottom: 3),
                          child: Row(                        
                            children: <Widget>[
                              Text('${widget.member.name}, ', style: TextStyle(fontFamily: 'PlayfairDisplay', fontSize: 31),),
                              Text('${widget.member.age} ', style: TextStyle(fontFamily: 'PlayfairDisplay', fontSize: 31),),
                              Text('age', style: TextStyle(fontFamily: 'PlayfairDisplay-Italic', fontSize: 31),)
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 7, bottom: 7),
                          child: Row(
                            children: <Widget>[
                              Image.asset('assets/images/addr-small-icon.png', height: 15, width: 15,), SizedBox(width: 3,),
                              Text(' ${widget.member.location}', style: TextStyle(color: Color(0xff4b474e), fontFamily: 'Lato-Regular', fontSize: 13),), SizedBox(width: 10,),
                              Image.asset('assets/images/gender-small-icon.png', height: 15, width: 15,), SizedBox(width: 3,),
                              Text('${widget.member.gender}', style: TextStyle(color: Color(0xff4b474e), fontFamily: 'Lato-Regular', fontSize: 13),),

                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 7, right: 7, bottom: 25),
                          child: Text('${usrDetail.heading}', style: TextStyle(color: Color(0xff635f65), fontFamily: 'Lato-Regular', fontSize: 16),),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 7, right:7, bottom: 15),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 10,
                                child: InkWell(
                                  onTap: onMessage,
                                  child: Container(
                                    height: 38,
                                    color: Color(0xff423547),
                                    child: Center(
                                      child: Text('MESSAGE', style: TextStyle(color: Colors.white, fontFamily: 'Lato-Rregular', fontSize: 13),
                                    ),),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                flex: 15,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      //print('FAVORITE taped');
                                      addFavoriteMember();                                  
                                    });
                                  },
                                  child: Container(
                                    height: 38,
                                    color: Color(0xfff2a941),
                                    child: Center(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Icon(Icons.favorite, size: 16, color: Colors.white), SizedBox(width: 5,),
                                          Text('FAVORITE', style: TextStyle(color: Colors.white, fontFamily: 'Lato-Rregular', fontSize: 13),
                                    ),
                                        ],
                                      ),),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                flex: 10,
                                child: InkWell(
                                  onTap: onVideoChat,
                                  // onTap: () {
                                  //   setState(() {
                                  //     if(widget.member.online){
                                  //       Navigator.push(context, MaterialPageRoute(builder: (context) => VideoChatScreen(member: widget.member)));
                                  //     }else{
                                  //       Global.showToastMessage('This User is in Offline state. Please call him after.');
                                  //     }
                                  //   });
                                  // },
                                  child: Container(
                                    height: 38,
                                    color: widget.member.online ? Color(0xff423547) : Colors.black45,
                                    child: Center(
                                      child: Text('VIDEO CHAT', style: TextStyle(color: Colors.white, fontFamily: 'Lato-Rregular', fontSize: 13),
                                    ),),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      Padding(
                        padding: const EdgeInsets.only(left: 7, right: 7, bottom: 5),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text('Last active', style: TextStyle(color: Color(0xff342e37), fontFamily: 'PlayfairDisplay-Italic', fontSize: 15),),
                            ),
                            Expanded(
                              child: Text('Member since', style: TextStyle(color: Color(0xff342e37), fontFamily: 'PlayfairDisplay-Italic', fontSize: 15)),
                            ),
                            Expanded(
                              child: Text('Recent location', style: TextStyle(color: Color(0xff342e37), fontFamily: 'PlayfairDisplay-Italic', fontSize: 15)),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 7, right: 7, bottom: 12),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text('July 8, 2016', style: TextStyle(color: Color(0xff342e37), fontFamily: 'Lato-Regular', fontSize: 15, fontWeight: FontWeight.bold)),
                            ),
                            Expanded(
                              child: Text('Alril 7, 2016', style: TextStyle(color: Color(0xff342e37), fontFamily: 'Lato-Regular', fontSize: 15, fontWeight: FontWeight.bold)),
                            ),
                            Expanded(
                              child: Text('${widget.member.location}', style: TextStyle(color: Color(0xff342e37), fontFamily: 'Lato-Regular', fontSize: 15, fontWeight: FontWeight.bold)),
                            )
                          ],
                        ),
                      ),

                      Divider(indent: 7, endIndent: 7, color: Color(0xff342e37), thickness: 1,),

                      Padding(
                        padding: const EdgeInsets.only(left: 7, top: 10, bottom: 17),
                        child: Text('About me', style: TextStyle(color: Color(0xff342e37), fontFamily: 'PlayfairDisplay', fontSize: 17, fontWeight: FontWeight.bold)),
                      ),   
                                        
                      Padding(
                        padding: const EdgeInsets.only(left: 7, right: 7, bottom: 25),
                        child: Text('${usrDetail.aboutme}',
                            style: TextStyle(color: Color(0xff342e37), fontFamily: 'Lato-Regular', fontSize: 16)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 7, bottom: 17),
                        child: Text('What I\'m looking for', style: TextStyle(color: Color(0xff342e37), fontFamily: 'PlayfairDisplay', fontSize: 17, fontWeight: FontWeight.bold)),
                      ),                    
                      Padding(
                        padding: const EdgeInsets.only(left: 7, right: 7, bottom: 12),
                        child: Text('${usrDetail.wilookfor}',
                            style: TextStyle(color: Color(0xff342e37), fontFamily: 'Lato-Regular', fontSize: 16)),
                      ),

                      Divider(indent: 7, endIndent: 7, color: Color(0xff342e37), thickness: 1,),

                      Padding(
                        padding: const EdgeInsets.only(left: 7, top: 10,  bottom: 12),
                        child: Text('Appearance', style: TextStyle(color: Color(0xff342e37), fontFamily: 'PlayfairDisplay', fontSize: 17, fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 7, right: 7, bottom: 7),
                        child: Container(
                          padding:  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                          color: Color(0xffedeced),
                          child: Row(
                            children: <Widget>[
                              Text('Looking for', style: TextStyle(color: Color(0xff635f65), fontFamily: 'Lato-Regular',fontSize: 16, fontWeight: FontWeight.bold),),
                              Spacer(),
                              Text('${usrDetail.lookfor}', style: TextStyle(color: Color(0xff635f65), fontFamily: 'Lato-Regular',fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 7, right: 7, bottom: 7),
                        child: Container(
                          padding:  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                          //color: Color(0xffedeced),
                          child: Row(
                            children: <Widget>[
                              Text('Lifestyle Expectation', style: TextStyle(color: Color(0xff635f65), fontFamily: 'Lato-Regular',fontSize: 16, fontWeight: FontWeight.bold),),
                              Spacer(),
                              Text('${usrDetail.lifestyle}', style: TextStyle(color: Color(0xff635f65), fontFamily: 'Lato-Regular',fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 7, right: 7, bottom: 7),
                        child: Container(
                          padding:  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                          color: Color(0xffedeced),
                          child: Row(
                            children: <Widget>[
                              Text('Height', style: TextStyle(color: Color(0xff635f65), fontFamily: 'Lato-Regular',fontSize: 16, fontWeight: FontWeight.bold),),
                              Spacer(),
                              Text('${usrDetail.height}', style: TextStyle(color: Color(0xff635f65), fontFamily: 'Lato-Regular',fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 7, right: 7, bottom: 7),
                        child: Container(
                          padding:  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                          child: Row(
                            children: <Widget>[
                              Text('Body Type', style: TextStyle(color: Color(0xff635f65), fontFamily: 'Lato-Regular',fontSize: 16, fontWeight: FontWeight.bold),),
                              Spacer(),
                              Text('${usrDetail.bodytype}', style: TextStyle(color: Color(0xff635f65), fontFamily: 'Lato-Regular',fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 7, right: 7, bottom: 7),
                        child: Container(
                          padding:  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                          color: Color(0xffedeced),
                          child: Row(
                            children: <Widget>[
                              Text('Ethnicity', style: TextStyle(color: Color(0xff635f65), fontFamily: 'Lato-Regular',fontSize: 16, fontWeight: FontWeight.bold),),
                              Spacer(),
                              Text('${usrDetail.ethnicity}', style: TextStyle(color: Color(0xff635f65), fontFamily: 'Lato-Regular',fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 7, right: 7, bottom: 7),
                        child: Container(
                          padding:  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                          //color: Color(0xffedeced),
                          child: Row(
                            children: <Widget>[
                              Text('Hair Color', style: TextStyle(color: Color(0xff635f65), fontFamily: 'Lato-Regular',fontSize: 16, fontWeight: FontWeight.bold),),
                              Spacer(),
                              Text('${usrDetail.haircolor}', style: TextStyle(color: Color(0xff635f65), fontFamily: 'Lato-Regular',fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 7, right: 7, bottom: 7),
                        child: Container(
                          padding:  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                          color: Color(0xffedeced),
                          child: Row(
                            children: <Widget>[
                              Text('Eye Color', style: TextStyle(color: Color(0xff635f65), fontFamily: 'Lato-Regular',fontSize: 16, fontWeight: FontWeight.bold),),
                              Spacer(),
                              Text('${usrDetail.eyecolor}', style: TextStyle(color: Color(0xff635f65), fontFamily: 'Lato-Regular',fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 7, right: 7, bottom: 7),
                        child: Container(
                          padding:  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                          //color: Color(0xffedeced),
                          child: Row(
                            children: <Widget>[
                              Text('Education', style: TextStyle(color: Color(0xff635f65), fontFamily: 'Lato-Regular',fontSize: 16, fontWeight: FontWeight.bold),),
                              Spacer(),
                              Text('${usrDetail.education}', style: TextStyle(color: Color(0xff635f65), fontFamily: 'Lato-Regular',fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 7, right: 7, bottom: 7),
                        child: Container(
                          padding:  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                          color: Color(0xffedeced),
                          child: Row(
                            children: <Widget>[
                              Text('Occupation', style: TextStyle(color: Color(0xff635f65), fontFamily: 'Lato-Regular',fontSize: 16, fontWeight: FontWeight.bold),),
                              Spacer(),
                              Text('${usrDetail.occupation}', style: TextStyle(color: Color(0xff635f65), fontFamily: 'Lato-Regular',fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 7, right: 7, bottom: 7),
                        child: Container(
                          padding:  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                          //color: Color(0xffedeced),
                          child: Row(
                            children: <Widget>[
                              Text('Relationship', style: TextStyle(color: Color(0xff635f65), fontFamily: 'Lato-Regular',fontSize: 16, fontWeight: FontWeight.bold),),
                              Spacer(),
                              Text('${usrDetail.relationship}', style: TextStyle(color: Color(0xff635f65), fontFamily: 'Lato-Regular',fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 7, right: 7, bottom: 7),
                        child: Container(
                          padding:  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                          color: Color(0xffedeced),
                          child: Row(
                            children: <Widget>[
                              Text('Children', style: TextStyle(color: Color(0xff635f65), fontFamily: 'Lato-Regular',fontSize: 16, fontWeight: FontWeight.bold),),
                              Spacer(),
                              Text('${usrDetail.children}', style: TextStyle(color: Color(0xff635f65), fontFamily: 'Lato-Regular',fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 7, right: 7, bottom: 7),
                        child: Container(
                          padding:  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                          //color: Color(0xffedeced),
                          child: Row(
                            children: <Widget>[
                              Text('Smokes', style: TextStyle(color: Color(0xff635f65), fontFamily: 'Lato-Regular',fontSize: 16, fontWeight: FontWeight.bold),),
                              Spacer(),
                              Text('${usrDetail.smokes}', style: TextStyle(color: Color(0xff635f65), fontFamily: 'Lato-Regular',fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 7, right: 7, bottom: 7),
                        child: Container(
                          padding:  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                          color: Color(0xffedeced),
                          child: Row(
                            children: <Widget>[
                              Text('Drinks', style: TextStyle(color: Color(0xff635f65), fontFamily: 'Lato-Regular',fontSize: 16, fontWeight: FontWeight.bold),),
                              Spacer(),
                              Text('${usrDetail.drinks}', style: TextStyle(color: Color(0xff635f65), fontFamily: 'Lato-Regular',fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                      BottomRegion(),
                      
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,                
                  child:  Visibility(
                      visible: true,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                          InkWell(onTap: () {
                            setState(() {
                              showDropdownList = false;
                            });
                          }, child: Padding(padding: EdgeInsets.only(top: 20, bottom: 10, left: 15, right: 15), child: BackButtonWidget())),
                        ]),
                      ),
                    ),
                ),
                Visibility(
                  visible: loadingChat,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Color(0x99000000),
                    child: Center(
                      child: LoadingIndicator(),
                    ), 
                  ),
                )
              ],
            ),
          )
        ),

        _progressHudLoad
      ],
    );
  }
}