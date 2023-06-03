import 'package:flutter/material.dart';
import 'package:social_app/models/new_member.dart';
import 'package:social_app/screens/common_widget/status_mark.dart';

class FavoriteMembersItemSmall extends StatelessWidget {
  
  final NewMember member;
  //final MemberType memberType;

  const FavoriteMembersItemSmall({Key key, this.member}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
      color: Color(0xFFEBEBEC),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(height: 90, width: 100, child: Stack(children: <Widget>[
            Image.network(member.photoUrl, width: 90,  height: 90, fit: BoxFit.fill),
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 5),
              child: StatusMark(member.online ? 'Online' : 'Offline', backgroundColor: Color(0x99000000),),
            )
          ])),
          
          Column(  
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 5),
                child: Text(member.name + ', ${member.age} age', style: TextStyle(fontSize: 20, fontFamily: 'PlayfairDisplay', color: Color(0xFF342E37))),
              ),
              Row(children: <Widget>[
                Icon(Icons.location_on, size: 15, color: Color(0xFF939094)),
                Text(member.location, style: TextStyle(color: Color(0xFF939094),  fontFamily: 'Lato-Regular',  height: 1, fontSize: 13),),
                
              ]),
              // SizedBox(height: 12),
              // Row(children: <Widget>[
              //     this.memberType == MemberType.FeaturedMembers ? StatusMark('Premium', backgroundColor: Color(0xFFDE6DA3)) : Container(),
              //     SizedBox(width: 5),
              //     this.memberType == MemberType.BackgroundVerified ? StatusMark('Background verified', backgroundColor: Color(0xFF854FC5),) : Container(),
              //   ],),
              
            ],
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(top: 12, right: 20),
            child: Image.asset('assets/images/heart-icon.png', width: 20, fit: BoxFit.fitWidth),
          )
        ],
      ),
    );
  }
}