import 'package:flutter/material.dart';
import 'package:social_app/models/message.dart';

class LeftMessageItem extends StatelessWidget {

  final Message message;
  
  const LeftMessageItem({Key key, this.message}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 27),
      child: Column(
        children: <Widget>[
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
            message.first ? Image.network(message.senderAvatar, width: 34, height: 34, fit: BoxFit.cover) : SizedBox(width: 34) /* : ''Image.network(BASE_IMAGE_URL + imageName, width: 34, fit: BoxFit.fitWidth)*/,
            SizedBox(width: 5),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20)
                )
              ),
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 150),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Color(0xffd8d8d8),
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), topRight: Radius.circular(10), bottomRight: Radius.circular(10))
                    ),
                    child: Text(message.message, style: TextStyle(color: Color(0xff69666b), height: 1.4, fontFamily: 'Lao-Regular', fontSize: 13),
                    ),
                  ),
                  Text('3:23 PM', style: TextStyle(color: Color(0x66000000), fontSize: 11)),
                ],
              )),
            
          ]),

        ],
      ),
    );
  }
}