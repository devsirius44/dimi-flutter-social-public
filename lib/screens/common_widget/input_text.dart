import 'package:flutter/material.dart';

class InputText extends StatefulWidget {
  final bool obscureText;
  final String hint;
  final String initialText;
  final String fontFamily;
  final double fSize;
  final TextAlign textAlign;
  final bool containerFlag;
  final bool suffixIconFlag ;
  final int maxlines;
  final ValueChanged<String> onChangedText;

  const InputText({Key key, this.obscureText = false, this.hint, this.fontFamily, this.fSize, this.textAlign = TextAlign.start, this.containerFlag = false,
                    this.suffixIconFlag = false, this.maxlines = 1, this.onChangedText, this.initialText = '' }) : super(key: key);

  @override
  InputTextState createState() => InputTextState();
}

class InputTextState extends State<InputText> {
  final TextEditingController _textController = new TextEditingController();
  
  @override
  void initState() {
    super.initState();
    //_textController.text = widget.initialText;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(width: constraints.maxWidth, child: Column(children: <Widget>[
          TextFormField(
            controller: _textController,
            obscureText: widget.obscureText,
            textAlign: widget.textAlign,
            style: TextStyle(color: Color(0xFF423547),fontFamily: widget.fontFamily, fontSize: widget.fSize),
            maxLines: widget.maxlines,
            onChanged: (value) {
              widget.onChangedText(value);
            },
            
            decoration: InputDecoration(
              border: widget.containerFlag ? new OutlineInputBorder() : UnderlineInputBorder( borderSide: BorderSide(color: Color(0xff99939c), width: 1)),              
              contentPadding: EdgeInsets.all(10),
              hintText: widget.hint,
              suffixIcon: widget.suffixIconFlag ? IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    _textController.clear();
                  }); 
                }
              ) : SizedBox(width:0),
              //semanticCounterText: true;
            )
          ),
        ]));
      }
    );
  }
}

