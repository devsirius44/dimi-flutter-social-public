import 'package:flutter/material.dart';
//
class CustomCheckBox extends StatefulWidget {

  final bool isChecked;
  final ValueChanged<bool> onChanged;
  final String checkImage;
  final String uncheckImage;
  final double size;
  const CustomCheckBox({Key key, this.size = 17, this.checkImage = 'assets/images/checked-icon.png', this.uncheckImage = 'assets/images/unchecked-icon.png', this.isChecked = true, this.onChanged}) : super(key: key);
  
  @override
  CustomCheckBoxState createState() {
    return CustomCheckBoxState();
  }
}

class CustomCheckBoxState extends State<CustomCheckBox> {

  bool isChecked;
  
  void setCheck() {
    if(!isChecked) {
      setState(() {
        isChecked = true;
      });
    }
  }

  void setUncheck() {
    if(isChecked) {
      setState(() {
        isChecked = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    isChecked = widget.isChecked;
  }
 
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        color: Colors.transparent,
        child: InkWell(          
          onTap: () {
            setState(() {
              isChecked = !isChecked;
            });
            widget.onChanged(isChecked);
          },
          child: Image.asset(isChecked ? widget.checkImage : widget.uncheckImage, fit: BoxFit.fill, width: widget.size, height: widget.size),
        ),
      ),
    );
  }
}