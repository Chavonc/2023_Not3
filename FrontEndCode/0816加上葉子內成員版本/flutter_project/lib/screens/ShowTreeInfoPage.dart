import 'package:flutter/material.dart';

class ShowTreeInfoPage extends StatelessWidget {
  const ShowTreeInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tree信息'),
      ),
      body: Center(
        child: Text(
          '这是Tree的信息页面',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}