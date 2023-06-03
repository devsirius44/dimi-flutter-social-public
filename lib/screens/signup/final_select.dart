import 'package:flutter/material.dart';
import 'package:social_app/screens/common_widget/custom_button.dart';
import 'package:social_app/screens/common_widget/input_loginfo.dart';
import 'package:social_app/utils/singletons/global.dart';

class FinalSelect extends StatefulWidget {
  //final Gender gender_;
  //final Role role_;
  //final Imwe imwe_;
  //final Imwe intrst_;
  //final String avatar_;
  final ValueChanged<SignInfo> onSuccessed;
  
  const FinalSelect({Key key, /*this.gender_, this.role_, this.imwe_, this.intrst_, this.avatar_,*/ this.onSuccessed }) : super(key: key);

  @override
  _FinalSelectState createState() => _FinalSelectState();
}

class _FinalSelectState extends State<FinalSelect> {
  String email = '';
  String password = '';
  String confirmPass = '';

  //void signUp() async {
  bool checkPassword() {  
    //print('email=${email}, password=${password}, conf_password=${confirmPass}, gender=${genderToString(widget.gender_)}, role=${roleToString(widget.role_)}, imwe=${imweToString(widget.imwe_)}, intrst=${imweToString(widget.intrst_)}');
    if(email == ''){
      Global.showToastMessage('Please write the email.');
    } else if(password.length < 6 ) {
      Global.showToastMessage('Password should be at least 6 characters.');
      return false; 
    } else if (password != confirmPass){
      Global.showToastMessage('Password does not match! Please confirm the password.');
      return false;
    }
    return true;
  } 

  @override 
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: <Widget>[          
          SizedBox(height: 20),
          Card(
            elevation: 10,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),            
            child: Container(
              margin: EdgeInsets.all(7),
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12, width: 1.0)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,

                children: <Widget>[
                  Image.asset('assets/images/mail-icon.png', width: 70, fit: BoxFit.fitWidth),                  
                  Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 15),
                    child: Text('E-mail & Password', style:TextStyle(fontFamily: 'PlayfairDisplay-Italic', fontSize: 20)),
                  ),
                  InputLogInfo(hint: 'E-mail', onChangedText: (val) {
                    email = val;
                  },),
                  SizedBox(height: 20),
                  InputLogInfo(obscureText: true, hint: 'Password', onChangedText: (val) {
                    password = val;
                  },),
                  SizedBox(height: 20),
                  InputLogInfo(obscureText: true, hint: 'Confirm password', onChangedText: (val) {
                    confirmPass = val;
                  },),
                  SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      Checkbox(checkColor: Theme.of(context).primaryColor, activeColor: Colors.white, onChanged: (bool value) {}, value: true),
                      Padding(padding: EdgeInsets.only(left: 5), child: Text('Remember me', style: TextStyle(color: Color(0xFF363139), fontFamily: 'Lato-Regular', fontSize: 16, fontWeight: FontWeight.normal),),)
                    ],
                  ),
                  CustomButton(text: 'JOIN', onPressed: () {                    
                    //signUp();
                    if(checkPassword()){
                      //User user = User('', email, widget.gender_, widget.role_, widget.imwe_, widget.intrst_, 0, widget.avatar_);
                      SignInfo signInfo = SignInfo(email, confirmPass);
                      widget.onSuccessed(signInfo);
                    }                    

                  },),
                ]                  
              )
            ),
          )
        ],
      ),
    );
  }
}

class SignInfo {
  String email;
  String password;
  
  SignInfo(this.email, this.password);

}

