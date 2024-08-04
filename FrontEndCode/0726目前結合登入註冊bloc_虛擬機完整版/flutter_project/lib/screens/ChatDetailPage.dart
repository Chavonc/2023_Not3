// ignore: file_names
import 'package:flutter/material.dart';

class ChatDetailPage extends StatefulWidget
{
  const ChatDetailPage({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> 
{

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: const Text("Chat Detail"),
      ),
      body: Container()
    );
  }
}