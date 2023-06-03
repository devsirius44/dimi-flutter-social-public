import 'package:flutter/material.dart';
import 'package:social_app/screens/common_widget/custom_expansion_panel.dart';

class ExpandablePanel extends StatefulWidget {
  final String title;
  final Widget child;
  const ExpandablePanel({
    Key key, this.title, this.child,
  }) : super(key: key);

  @override
  _ExpandablePanelState createState() => _ExpandablePanelState();
}

class _ExpandablePanelState extends State<ExpandablePanel> {
  bool expFlag = false;

  @override
  Widget build(BuildContext context) {
    return CustomExpansionPanel(
      title: Row(
        children: <Widget>[
          Container(
            height: 15, width: 15,
            decoration: BoxDecoration(
              color: Color(0xfff4b639),
              borderRadius: BorderRadius.all(Radius.circular(8)) ),
            child: Icon(expFlag ? Icons.remove : Icons.add, color: Colors.white, size: 15,),

          ),
          SizedBox(width: 15,),
          Text(widget.title, style: TextStyle(color: Color(0xff423547), fontFamily: 'Lato-Regular', fontSize: 19, fontWeight: FontWeight.bold)),
        ],
      ),
      trailing: SizedBox(width: 0),
      
      onExpansionChanged: (value) {
        setState(() {
          expFlag = value;
        });
      },
      children: <Widget>[
        widget.child,        
      ],
    );
  }
}