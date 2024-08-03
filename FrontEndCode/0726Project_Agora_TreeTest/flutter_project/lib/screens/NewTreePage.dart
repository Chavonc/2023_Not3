// ignore: file_names
import 'package:flutter/material.dart';

class NewTreePage extends StatefulWidget 
{
  const NewTreePage({super.key});
  @override
  //ignore: library_private_types_in_public_api
  _NewTreePageState createState()=>_NewTreePageState();
}
class _NewTreePageState extends State<NewTreePage>
{
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      appBar:AppBar
      (
        title: const Center(child: Text('創建Tree')),
        backgroundColor: Colors.green,
        elevation: 0.0, //陰影
      ),
      body:SingleChildScrollView
      (
        physics: const BouncingScrollPhysics(),
        child:Column
        (
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>
          [
            SafeArea
            (
              child:Padding
              (
                padding:const EdgeInsets.only(left:16,right:16,top:10),
                child:Row
                (
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const <Widget>
                  [
                    Text
                    (
                      "Build New Tree",
                      style:TextStyle(fontSize:30,fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}