import 'package:flutter/material.dart';
import 'package:social_app/utils/singletons/global.dart';

class NavItem extends StatelessWidget {
  final VoidCallback onTap;
  final String title;

  const NavItem({Key key, this.onTap, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20, top: 22, bottom: 22),
            child: Text(title, style: TextStyle(color: Colors.white, fontFamily: 'Lato-Regular', fontSize: 16, height: 1),),
          ),
          Container(
            height: 1,
            color: Color(0xFFE5E6EA),
          ),
        ],
      ),
    );
  }
}

class NavMenu extends StatelessWidget {
  final ValueChanged<String> onMenuItemClicked;
  final VoidCallback onClose;
  const NavMenu({Key key, this.onClose, this.onMenuItemClicked}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Color(0xff493f4e),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 25, right: 35),
              child: Column(children: <Widget>[
                SizedBox(height: 45),
                Text('DREAM\nARRANGEMENTS', textAlign: TextAlign.center, style: Theme.of(context).textTheme.caption),
                SizedBox(height: 30),                
                Row(
                  children: <Widget>[
                    Image.asset('assets/images/nav-dashboard-icon.png', height: 28, width: 28,),
                    NavItem(
                      title: 'Dashboard Page',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamedAndRemoveUntil(context, '/dashboard', ModalRoute.withName('/dashboard'));
                      },
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Image.asset('assets/images/nav-favorite-icon.png', height: 28, width: 28,),
                    NavItem(
                      title: 'Favorite Page',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamedAndRemoveUntil(context, '/favorite', ModalRoute.withName('/favorite'));
                      },
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Image.asset('assets/images/nav-message-icon.png', height: 28, width: 28,),
                    NavItem(
                      title: 'Messages Page',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamedAndRemoveUntil(context, '/messages', ModalRoute.withName('/messages'));
                      },
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Image.asset('assets/images/nav-room-icon.png', height: 28, width: 28,),
                    NavItem(
                      title: 'Room Page',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamedAndRemoveUntil(context, '/room', ModalRoute.withName('/room'));
                      },
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Image.asset('assets/images/nav-search-icon.png', height: 28, width: 28,),
                    NavItem(
                      title: 'Search Page',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamedAndRemoveUntil(context, '/search', ModalRoute.withName('/search'));
                      },
                    ),
                  ],
                ),
                SizedBox(height: 220),                
                Row(
                  children: <Widget>[
                    Image.asset('assets/images/nav-logout-icon.png', height: 28, width: 28,),
                    NavItem(
                      title: 'LogOut',
                      onTap: () {
                        Navigator.pop(context);
                        Global.freeSignaling();
                        Navigator.pushNamedAndRemoveUntil(context, '/', ModalRoute.withName('/'));
                      },
                    ),
                  ],
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}