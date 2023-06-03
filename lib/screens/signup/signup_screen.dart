import 'package:flutter/material.dart';
import 'package:social_app/firebase/auth_manage.dart';
import 'package:social_app/firebase/profile_manage.dart';
import 'package:social_app/models/user_tbl.dart';
import 'package:social_app/screens/common_widget/back_button.dart';
import 'package:social_app/screens/common_widget/bottom_region.dart';
import 'package:social_app/screens/signup/choice_info.dart';
import 'package:social_app/screens/signup/final_select.dart';
import 'package:social_app/screens/signup/gender_select.dart';
import 'package:social_app/screens/signup/imwe_select.dart';
import 'package:social_app/screens/signup/interest_select.dart';
import 'package:social_app/screens/signup/role_select.dart';
import 'package:progress_hud/progress_hud.dart';
import 'package:social_app/utils/singletons/global.dart';
import 'package:social_app/utils/singletons/session_manager.dart';

class SignUpScreen extends StatefulWidget {

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  Widget curWidget;
  Gender gender;
  Role role;
  Imwe imwe;
  Imwe intrst;
  String avatarPath = '';
  ProgressHUD _progressHUD;

  @override
  void initState() {
    super.initState();

    _progressHUD = new ProgressHUD(loading: false, backgroundColor: Colors.black12, color: Colors.white,
      containerColor: Color(0xff5B4961), borderRadius: 5.0, text: 'Registering...',);

    updateCurWidget();
  }

  void updateCurWidget(){
    curWidget = GenderSelect(onSelected: (val)  async {
      gender = val;
      avatarPath = ''; // await ProfileManage.getUploadedAvatarUrl(gender);

      setState(() {        
        curWidget = RoleSelect(onSelected: (val){
          setState(() {
            role = val;
            curWidget = ImWeSelect(role, onSelected: (val) {
              setState(() {
                imwe = val;
                curWidget = InterestSelect(imwe, onSelected: (val){
                  setState(() {
                    intrst = val;
                    curWidget = FinalSelect( onSuccessed: (val){
                      SignInfo signInfo = val;
                      UserTbl user = UserTbl('Unknown', signInfo.email, gender, role, imwe, intrst, 0);                      
                      signUp(signInfo, user);
                    },);
                  });
                });
              });
            });
          });
        });
      });
    });
  } 
  
  void signUp(SignInfo signInfo, UserTbl user) async {
    
    try {
      _progressHUD.state.show();

      avatarPath = await ProfileManage.createAvatar(signInfo.email, gender, '');      
      
      SessionManager.setEmail(signInfo.email);
      SessionManager.setAvatarPath(signInfo.email, avatarPath);
      await AuthManage.signUp(signInfo.email, signInfo.password, user); 
      //await  AuthManage.getUserInfo();
      Navigator.pushNamed(context, '/dashboard');
      _progressHUD.state.dismiss();
    } catch(e) {
      print(e.toString());
      Global.showToastMessage('Incorrect username or password provided.');
      _progressHUD.state.dismiss();
    }
  } 


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Visibility(
          visible: true,
          child: Padding(
            padding: const EdgeInsets.all(11.0),
            child: BackButtonWidget(),
          ),
        ),       
      ),

      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 45),
                  Text('DREAM\nARRANGEMENTS', textAlign: TextAlign.center, style: Theme.of(context).textTheme.caption),
                  SizedBox(height: 30),
                  Text('Create your account', style: Theme.of(context).textTheme.title),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 20),
                    child: Text('Signing up for\nDream Arrangements is fast and free.', style: TextStyle(height: 1.3, fontFamily: 'Lato-Regular', fontSize: 15), textAlign: TextAlign.center,),
                  ),
                  ChoiceInfo(visible: gender != null, imgUrl:'assets/images/gender-mark-icon.png', propName:'Gender', propValue: genderToString(gender)), 
                  ChoiceInfo(visible: role != null, imgUrl:'assets/images/role-mark-icon.png', propName:'Role', propValue: role == null ? '' : roleToString(role)),
                  ChoiceInfo(visible: imwe != null, imgUrl:'assets/images/person-mark-icon.png', propName:'I\'m/We are a', propValue: imwe == null ? '' : imweToString(imwe)),
                  ChoiceInfo(visible: intrst != null, imgUrl:'assets/images/interest-mark-icon.png', propName:'Interested in', propValue: intrst == null ? '' : imweToString(intrst)), 
                  
                  curWidget,

                  SizedBox(height: 30),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('Don\' have an account?', style: TextStyle(fontFamily: 'Lato-Regular', fontSize: 15),),
                      InkWell(onTap: () {
                        Navigator.pushNamed(context, '/signUp');
                      }, child: Text('Join ', style: TextStyle(decoration: TextDecoration.underline, fontFamily: 'Lato-Regular', fontSize: 16),)),
                      Text('today.', style: TextStyle(fontFamily: 'Lato-Regular', fontSize: 15))
                    ],
                  ),
                  SizedBox(height: 25),
                  BottomRegion()
                ],
              ),
            ),
          ),

          _progressHUD
        ],
      ),
    );
  }
}

