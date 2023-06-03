import 'package:flutter/material.dart';
//import 'package:social_app/models/member.dart';
import 'package:social_app/models/new_member.dart';

class FavoriteListItemBig extends StatelessWidget {

  final NewMember member;
  final VoidCallback onPressed;

  const FavoriteListItemBig({Key key, this.member, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: <Widget>[
            Card(
              elevation: 10,
              child: Column(children: <Widget>[
                AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(member.photoUrl, fit: BoxFit.fill),
                ),
                Container( 
                  height: 5, 
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      // stops: [0.1, 0.5, 0.7, 0.9],
                      colors: [
                        Color(0xff854fc4),
                        Color(0xffd86ba4)
                      ],
                    ),
                  ),
                ),
              ],),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Text(member.name + ', ${member.age} age', style: TextStyle(fontSize: 28, fontFamily: 'PlayfairDisplay', color: Color(0xFF342E37)),),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.location_on, size: 15, color: Color(0xFF939094)),
                Text(member.location, style: TextStyle(fontSize: 15, fontFamily: 'Lato-Regular', color: Color(0xFF5F5B61))),
              ],
            ),
            SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}