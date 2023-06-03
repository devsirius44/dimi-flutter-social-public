import 'package:flutter/material.dart';

class InputLogInfo extends StatelessWidget {

  final bool obscureText;
  final String hint;
  final ValueChanged<String> onChangedText;

  const InputLogInfo({Key key, this.hint = '', this.obscureText = false, this.onChangedText }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(width: constraints.maxWidth, child: Column(children: <Widget>[
          TextFormField(
            obscureText: obscureText,
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF423547)),
            onChanged: (value) {
              this.onChangedText(value);
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(10),
              hintText: hint,
            )
          ),
          Container(width: constraints.maxWidth, height: 1, color: Color(0xFF3b363d))
        ]));
      }
    );
  }
}