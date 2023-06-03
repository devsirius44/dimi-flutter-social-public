import 'package:flutter/material.dart';
import 'package:social_app/models/models.dart';

class ChatListItem extends StatelessWidget {

  final VoidCallback onPressed;
  final Chat chat;
  final bool notiflag;
  
  const ChatListItem({Key key, this.chat, this.onPressed, this.notiflag = true,}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
        color: Color(0xFFEBEBEC),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(height: 90, width: 100, child: Stack(children: <Widget>[

                  Image.network(chat.avatar, width: 90,  height: 90, fit: BoxFit.fill),
                
                ])),
                
                Expanded(
                  child: Column(  
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(chat.title , style: TextStyle(fontSize: 15, fontFamily: 'Lao-Heavy', color: Color(0xff342e37))),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(chat.lastSentMessage?.message ?? 'No messages yet', maxLines: 1, style: TextStyle(color: Color(0xFF939094),  fontFamily: 'Lato-Regular',  height: 1.3, fontSize: 11, fontStyle: FontStyle.italic),),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: Text('2 min ago', style: TextStyle(color: Color(0xff342e37),  fontFamily: 'Lato-Regular',  height: 1, fontSize: 13),),
                      ),                    
                    ],
                  ),
                ),
                notiflag ? Container(
                  height: 17,
                  width: 17,
                  color: Color(0xfffad06b),
                  child: Center(child: Text('member.notificationNumber', style: TextStyle(color: Color(0xff403245), fontSize: 12, fontFamily: 'Lato-Regular',),)),
                ) : Container(),
                
              ],
            ),
          ],
        ),
      ),
    );
  }
}