import 'package:flutter/material.dart';

class ShareIcon extends StatelessWidget {
  final String iconName;

  const ShareIcon(this.iconName, {Key key, }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Image.asset(iconName, width: 35, fit: BoxFit.fitWidth);
  }
}

class BottomRegion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        width: constraints.maxWidth,
        color: Color(0xFF493f4e), 
        padding: EdgeInsets.only(top: 35),
        child: Column(children: <Widget>[
          Image.asset('assets/images/da-bottom-icon.png', width: 40, fit: BoxFit.fitWidth),
          SizedBox(height: 10),
          Text('Dream Arrangements is the leading Daddy dating\nsite where over 5+ million members fuel mutually\nbeneficial relationships on their terms.', 
            style: TextStyle(color: Colors.white, fontFamily: 'Lato-Regular', fontSize: 14, height: 1.3),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text('Share app:', style: TextStyle(color: Colors.white60, fontFamily: 'Lato-Regular', fontSize: 14),),
          SizedBox(height: 5),
          Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
            ShareIcon('assets/images/facebook-icon.png'),
            SizedBox(width: 5),
            ShareIcon('assets/images/twiter-icon.png'),
            SizedBox(width: 5),
            ShareIcon('assets/images/youtube-icon.png'),
            SizedBox(width: 5),
            ShareIcon('assets/images/google-icon.png'),
          ]),
          
          Padding(
            padding: EdgeInsets.only(top: 30, bottom: 25, left: 20, right: 20),
            child: Container(
              height: 1.0,
              color: Colors.white10,
            ),
          ),
          Text('\u00a9 2016 Dream arrangements.com in conjunction with W8 Tech\nLimited, Reflex Media and their related companies, Privacy Terms',
            style: TextStyle(color: Colors.white54, fontFamily: 'Lato-Regular',fontSize: 11),
          ),
          SizedBox(height: 20)
        ]),  
      );
    });
  }
}