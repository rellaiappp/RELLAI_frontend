import "package:flutter/material.dart";
import "package:rellai_frontend/widgets/chat_widget.dart";

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return const ChatWidget();
  }
}
