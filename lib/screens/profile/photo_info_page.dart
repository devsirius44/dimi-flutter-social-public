import 'dart:io';
import 'package:flutter/material.dart';
import 'package:social_app/firebase/profile_manage.dart';
import 'package:social_app/models/photo_info.dart';
import 'package:social_app/screens/common_widget/bottom_region.dart';
import 'package:social_app/screens/common_widget/confirm_dialog.dart';
import 'package:social_app/screens/common_widget/custom_button.dart';
import 'package:social_app/screens/profile/image_picker_dialog.dart';
import 'package:social_app/utils/singletons/global.dart';
import 'package:social_app/utils/singletons/session_manager.dart';

class PhotoInfoPage extends StatefulWidget {
  final Function onLoadStarted;
  final Function onImagePickered;
  final Function onAvatarChanged;
  
  const PhotoInfoPage({Key key, this.onAvatarChanged, this.onImagePickered, this.onLoadStarted}) : super(key: key);
  @override
  PhotoInfoPageState createState() => PhotoInfoPageState();
}

class PhotoInfoPageState extends State<PhotoInfoPage> with ImagePickListener {
  File avatar;
  bool publicFlag = false;
  bool avatarFlag = false; 
  String imgUrl;
  List<String> publicImgUrls = [];
  List<String> privateImgUrls = [];
  String email = '';
  
  @override
  void initState() {
    super.initState();
    email = SessionManager.getEmail();
    avatar = File(SessionManager.getAvatarPath(email));
    getPhotoInfo();
  }
  
  void getPhotoInfo() async {
    await ProfileManage.getCurUserPhotoList();
    publicImgUrls = ProfileManage.getPublicPhotos();
    privateImgUrls = ProfileManage.getPrivatePhotos();
    setState(() {
      
    });
    
    widget.onLoadStarted(false);
  } 

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 25, left: 15, right: 15),            
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Avatar Photo', style:TextStyle(color: Color(0xff342e37), fontFamily: 'PlayfairDisplay', fontSize: 28)),
                    SizedBox(height: 10),
                    Text('Please update your avatar.', style: TextStyle(fontFamily: 'Lato-Regular', height: 1.4, fontSize: 16, color: Color(0xFF635f65))),
                    SizedBox(height: 25), 

                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        width: MediaQuery.of(context).size.width*2/3,
                        height: MediaQuery.of(context).size.width*2/3,
                        alignment: Alignment.center,
                        child: Image.file(avatar)
                      ),
                    ),

                    SizedBox(height: 25),
                    PhotoAddButton('ADD AVATAR PHOTO', onPressed: () {
                      setState(() {
                        avatarFlag = true;
                      }); 
                      ImagePickerDialog(context, this).show();
                    }),

                    SizedBox(height: 60),
                    Text('Public Photos', style:TextStyle(color: Color(0xff342e37), fontFamily: 'PlayfairDisplay', fontSize: 28)),
                    SizedBox(height: 10),
                    Text('Public photos that you add can be seen by all\nmembers that visit your profile.', style: TextStyle(fontFamily: 'Lato-Regular', height: 1.4, fontSize: 16, color: Color(0xFF635f65))),
                    SizedBox(height: 25), 

                    Column(
                      children: List.generate(publicImgUrls.length, (int index) {
                        return Container(
                          margin: EdgeInsets.only(top: 10),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width,

                          child: Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              Image.network(publicImgUrls[index], fit: BoxFit.cover,),
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(icon: Icon(Icons.settings, color: Color(0xff5B4961)), onPressed: () {
                                  ConfirmDialog(context, onConfirm: () async {
                                    String pUrl = publicImgUrls[index];
                                    publicImgUrls.remove(pUrl);
                                    await deleteSelectedPhoto(pUrl);
                                    setState(() {
                                      
                                    });
                                  },).show();

                                }),
                              )
                            ]
                          )
                        );
                      }),
                    ),
                    SizedBox(height: 25),
                    PhotoAddButton('ADD PUBLIC PHOTOS', onPressed: () {
                      setState(() {
                        publicFlag = true;
                      }); 
                      ImagePickerDialog(context, this).show();
                    }),

                    SizedBox(height: 60),
                    Text('Private Photos', style:TextStyle(color: Color(0xff342e37), fontFamily: 'PlayfairDisplay', fontSize: 28)),
                    SizedBox(height: 10),
                    Text('Private photo can only be seen by members\nthat you have shared access with. Who I’ve\nshared with.', style: TextStyle(fontFamily: 'Lato-Regular', height: 1.4, fontSize: 16, color: Color(0xFF635f65))),
                    SizedBox(height: 25), 

                    Column(
                      children: List.generate(privateImgUrls.length, (int index) {
                        return Container(
                          margin: EdgeInsets.only(top: 10),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width,

                          child: Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              Image.network(privateImgUrls[index], fit: BoxFit.cover,),
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(icon: Icon(Icons.settings, color: Color(0xff5B4961)), onPressed: () {
                                  ConfirmDialog(context, onConfirm: () async {
                                    String pUrl = privateImgUrls[index];
                                    privateImgUrls.remove(pUrl);
                                    await deleteSelectedPhoto(pUrl);
                                    setState(() {
                                      
                                    });
                                  },).show();

                                }),
                              )
                            ]
                          )
                        );
                      }),
                    ),

                    SizedBox(height: 25),
                    PhotoAddButton('ADD PRIVATE PHOTOS', onPressed: () {
                      setState(() {
                        publicFlag = false;
                      }); 
                      ImagePickerDialog(context, this).show();
                    },),
                  ],
                )
              ),
              SizedBox(height: 30),
              BottomRegion()
            ],
          ),
        ),
      ],
    );
  }
  
  @override
  onImagePicked(File image) async {
    if(image == null)   return ;
    widget.onImagePickered(true); 
    if(avatarFlag){
      File avatarFile = File(SessionManager.getAvatarPath(email));
      try {
        await avatarFile.delete();
      } catch (e) {
        print(e.toString());
      }
      String avatarUrl = await ProfileManage.getUploadedPhotoUrl(image);
      await ProfileManage.saveAvatarToBasicInfo(avatarUrl);
      
      String newFilePath = await ProfileManage.createNewAvatarPath(email);
      File newFile = File(newFilePath);      
      List<int> bytes = await image.readAsBytes();      
      await newFile.writeAsBytes(bytes);
      SessionManager.setAvatarPath(email, newFilePath);
      widget.onAvatarChanged(newFile);
      setState(() {
        avatar = newFile;
      });
      avatarFlag = false;
    }else {
      String imgUrl = await ProfileManage.getUploadedPhotoUrl(image);
      PhotoInfo photoInfo = PhotoInfo('', publicFlag, imgUrl);
      bool flag = await ProfileManage.savePhotoInfo(photoInfo);
      if(flag){
        if(publicFlag){
          publicImgUrls.add(imgUrl);
        }else {
          privateImgUrls.add(imgUrl);
        }
      }else{
        Global.showToastMessage('Photo uploading was failed.');
      }
      setState(() { });   
    }
    widget.onImagePickered(false); 
  }

  deleteSelectedPhoto(String photoUrl) async {
    await ProfileManage.deleteSelectedPhoto(photoUrl); 
  }

}

class PhotoAddButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  const PhotoAddButton(this.title, {Key key, this.onPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          elevation: 32,
          margin: EdgeInsets.all(0),
          child: InkWell(
            onTap: () {
              onPressed();
            },
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFEBEBEC),
                border: Border.all(
                  color: Color(0xFF979797),
                  width: 2.0
                )
              ),
              width: constraints.maxWidth,
              height: 250,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: CustomButton(
                    text: title,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

}