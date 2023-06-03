import 'dart:io';
import 'package:flutter/material.dart';
import 'package:social_app/models/message.dart';

class RightMessageItem extends StatelessWidget {
  
  final Message message;
  
  const RightMessageItem({Key key, this.message}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 27),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
            Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 150),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Color(0xffd8d8d8),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))
                    ),
                    child: Text(this.message.message, style: TextStyle(color: Color(0xff69666b), fontFamily: 'Lao-Regular', fontSize: 13),
                    ),
                  ),
                  Text('2 minutes ago', style: TextStyle(color: Color(0x66000000), fontSize: 11)),      
                ],
              )),
            SizedBox(width: 5),
            message.first ? Image.file(File(message.senderAvatar), width: 34, height: 34, fit: BoxFit.cover) : SizedBox(width: 34) /* : ''Image.network(BASE_IMAGE_URL + imageName, width: 34, fit: BoxFit.fitWidth)*/,
          ]),
        ],
      ),
    );
  }
}