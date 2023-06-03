import 'package:flutter/material.dart';

class BlockDlgButton extends StatefulWidget {
  final VoidCallback onPressed;

  const BlockDlgButton({Key key, this.onPressed}) : super(key: key);
  @override

   BlockDlgButtonState createState() => BlockDlgButtonState();
}

class BlockDlgButtonState extends State<BlockDlgButton> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints){
        return InkWell(
          onTap: widget.onPressed,
          child: Container(
            height: 40,
            child: Stack(
              children: <Widget>[
                Image.asset('assets/images/block_dlg_button_img.png', width: constraints.maxWidth, fit: BoxFit.fill,),
                Align(
                  alignment: Alignment.center,
                  child: Text('BLOCK DIALOG', style: TextStyle(fontFamily: 'Lato-Heavy', fontSize: 12),)),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 28),
                    child: Image.asset('assets/images/lock-icon.png', height: 15, width: 15,),
                  ))  
              ],
            ),
            
          ),
        );
      },
    );
  }
}