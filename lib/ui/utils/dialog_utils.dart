import 'package:flutter/material.dart';

void showLoading(BuildContext context, Color color, TextStyle style)
{
  showDialog(barrierDismissible: false,context: context, builder: (context) {
        return AlertDialog(
          backgroundColor: color,
          content: Row(
            children: [
              Text("Loading...", style: style,),
              const Spacer(),
              const CircularProgressIndicator()
            ],
          ),
        );
      },);
}

void hideLoading(BuildContext context)
{
  Navigator.pop(context);
}

void showErrorDialog(BuildContext context, String message, Color color, TextStyle style)
{
  showDialog(barrierDismissible: false,context: context, builder: (context) {
    return AlertDialog(
      backgroundColor: color,
      title: Text("Error!", style: style,),
      content: Text(message, style: style,),
      actions: [
        TextButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text("OK", style: style,))
      ],
    );
  },);
}