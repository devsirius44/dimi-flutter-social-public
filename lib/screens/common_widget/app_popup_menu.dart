import 'package:flutter/material.dart';

class AppPopUpMenu extends StatelessWidget {
  final VoidCallback onAnyPressed;
  final VoidCallback onProfilePressed;
  final VoidCallback onLogOutPressed;
  final bool showDDL;

  const AppPopUpMenu({ Key key, this.showDDL, this.onAnyPressed, this.onProfilePressed, this.onLogOutPressed,  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Visibility(
          visible: showDDL,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: InkWell(
                onTap: onAnyPressed,
                child: Align(
                  alignment: Alignment.topRight,
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
                    color: Color(0xFF2C2330),
                    margin: EdgeInsets.only(top: AppBar().preferredSize.height + MediaQuery.of(context).padding.top),
                    elevation: 8,
                    child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                      InkWell(
                        onTap: onProfilePressed,
                        child: Padding(padding: EdgeInsets.only(top: 20, bottom: 10, left: 15, right: 15), child: Text('YOUR PROFILE', style: TextStyle(color: Colors.white, fontSize: 14),))
                      ),
                      Container(color: Color(0xFF28202B), height: 1, width: 150),
                      InkWell(
                        onTap: onLogOutPressed,
                        child: Padding(padding: EdgeInsets.only(top: 10, bottom: 20, left: 15, right: 15), child: Text('LOG OUT', style: TextStyle(color: Colors.white, fontSize: 14)))
                      ),
                    ]),
                  ),
                ),
              )

            ),
          ),
        );
      },
    );
  }
}