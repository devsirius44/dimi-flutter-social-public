import 'package:flutter/material.dart';
import 'package:social_app/screens/common_widget/custom_button.dart';

class ChatOptionDialog extends StatelessWidget {

  final BuildContext context;
  final VoidCallback onVideoChat;
  final VoidCallback onTextChat;

  
  ChatOptionDialog(this.context, {this.onVideoChat, this.onTextChat});
  
  show() {
    showDialog(
      context: context,
      builder: (context) => Container(
        child: this
      )
    );
  }
  
  dismiss() {
    Navigator.pop(context);
  }
  
  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: Opacity(
          opacity: 1.0,
          child: Container(
            padding: EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 20.0),
            child: Center(
              child: Container(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5))
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerRight,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              dismiss();
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Icon(Icons.close, color: Colors.black),
                            ),
                          ),
                        )
                      ),
                      SizedBox(height: 10),
                      CustomButton(
                        text: 'VIDEO CHAT',
                        onPressed: () async {
                          dismiss();
                          onVideoChat();
                        },
                      ),
                      SizedBox(height: 15),
                      CustomButton(
                        text: 'TEXT CHAT',
                        onPressed: () async {
                          dismiss();
                          onTextChat();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )
          ),
        ));
  }
  
  Widget roundedButton(
      String buttonLabel, EdgeInsets margin, Color bgColor, Color textColor) {
    var loginBtn = Container(
      margin: margin,
      padding: EdgeInsets.all(15.0),
      alignment: FractionalOffset.center,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.all(const Radius.circular(100.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFF696969),
            offset: Offset(1.0, 6.0),
            blurRadius: 0.001,
          ),
        ],
      ),
      child: Text(
        buttonLabel,
        style: TextStyle(
            color: textColor, fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    );
    return loginBtn;
  }
}