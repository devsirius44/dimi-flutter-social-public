import 'package:flutter/material.dart';
import 'package:social_app/firebase/auth_manage.dart';
import 'package:social_app/firebase/dashboard_manage.dart';
import 'package:social_app/firebase/profile_manage.dart';
import 'package:social_app/models/basic_info.dart';
import 'package:social_app/models/user_tbl.dart';
import 'package:social_app/screens/common_widget/bottom_region.dart';
import 'package:social_app/screens/common_widget/custom_button.dart';
import 'package:social_app/screens/common_widget/input_loginfo.dart';
import 'package:social_app/utils/singletons/global.dart';
import 'package:progress_hud/progress_hud.dart';
import 'package:social_app/utils/singletons/session_manager.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  bool rememberChecked = false;
  String email = '';
  String password = '';
  ProgressHUD _progressHUD;

  @override
  void initState() {
    super.initState();
    _progressHUD = new ProgressHUD(loading: false, backgroundColor: Colors.black12, color: Colors.white,
      containerColor: Color(0xff5B4961), borderRadius: 5.0, text: 'Log In...',);
  }

  void  signIn() async {
    try {
      if(email == ''){
        Global.showToastMessage('Please write the email.');
      } else if(password.length < 6 ) {
        Global.showToastMessage('Password should be at least 6 characters.');
      } else {

        _progressHUD.state.show();

        await AuthManage.signIn(email, password); 

        UserTbl userInfo = await AuthManage.getUserInfo();
        BasicInfo basicInfo  = await DashboardManage.getBasicInfo(userInfo.id);
        SessionManager.setEmail(email);
        SessionManager.setGender(userInfo.gender);
        SessionManager.setUserID(userInfo.id);
        String path = '';       
        
        if(basicInfo != null) {
          path = await ProfileManage.createAvatar(email, userInfo.gender, basicInfo.dashphotourl);
        }else{
          path = await ProfileManage.createAvatar(email, userInfo.gender, '');
        }
        SessionManager.setAvatarPath(email, path);
        Global.email = email;
        Global.connect();
        Navigator.pushNamed(context, '/dashboard');
        _progressHUD.state.dismiss();
  
      }
    } catch(e) {
      print(e.toString());
      Global.showToastMessage('Incorrect username or password provided.');
      _progressHUD.state.dismiss();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Text('Log in', style: Theme.of(context).textTheme.title),
                  SizedBox(height: 20,),
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      margin: EdgeInsets.all(7),
                      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12, width: 1.0)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          InputLogInfo(hint: 'Enter email', onChangedText: (value) {
                            email = value;
                          },),

                          SizedBox(height: 20),
                          InputLogInfo(obscureText: true, hint: 'Enter password', onChangedText: (value) {
                            password = value;
                          },),

                          SizedBox(height: 20),
                          CustomButton(text: 'LOG IN', onPressed: () {
                            setState(() {
                              signIn(); 
                            });
                          },),
                          SizedBox(height: 13,),
                          Row(
                            children: <Widget>[
                              Container(
                                color: rememberChecked == true ? Color(0xff423647) : Colors.white,
                                width: 22, height: 22,

                                child: Checkbox(                              
                                  checkColor: Color(0xff423647),
                                  activeColor: Colors.white,
                                  value: rememberChecked,
                                  onChanged: (bool value) {
                                    setState(() {
                                        rememberChecked = value;
                                    });
                                  },
                                ),
                              ),

                              Padding(padding: EdgeInsets.only(left: 5), child: Text('Remember me', style: TextStyle(color: Color(0xFF363139), fontFamily: 'Lato-Regular', fontSize: 16, fontWeight: FontWeight.normal),),)
                            ],
                          ),
                        ]                  
                      )
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('Don\' have an account?', style: TextStyle(color: Theme.of(context).primaryColor, fontFamily: 'Lato-Regular', fontSize: 14),),
                      InkWell(onTap: () {
                        Navigator.pushNamed(context, '/signUp');
                      }, child: Text('Join ', style: TextStyle(decoration: TextDecoration.underline, color: Theme.of(context).primaryColor, fontFamily: 'Lato-Regular'), )),
                      Text('today.')
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Container(
                      height: 1,
                      color: Colors.black12,
                    ),
                  ),
                  Text('By continuing you agree to Dream Arrangements Terms\nand Privacy Policy.Promoting illegal commercial\nactivities(such as prostitution) is prohibited.', 
                    style: TextStyle(color: Theme.of(context).primaryColor, fontFamily: 'Lato-Regular', fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 5),
                  Text('If you are an ESCORT, DO NOT use this website', 
                    style: TextStyle(color: Theme.of(context).primaryColor, fontFamily: 'Lato-Regular', fontSize: 11),
                    textAlign: TextAlign.center,
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