// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_project/screens/StartFruitsPage.dart';
import 'package:flutter_project/screens/NewTreePage.dart';
class FruitsTreePage extends StatefulWidget 
{
  const FruitsTreePage({super.key});
  @override
  //ignore: library_private_types_in_public_api
  _FruitsTreePageState createState()=>_FruitsTreePageState();
}
class _FruitsTreePageState extends State<FruitsTreePage>
{
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      body:Column
      (
        mainAxisAlignment:MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>
        [
          Container
          (
            alignment: Alignment.topCenter,
            child:Image.asset('assets/images/StartFruits_1.png',width: 150,height: 150),
          ),
          Center
          (
            child:Container
            (
              height: 60,
              width: 150,
              alignment:Alignment.center,
              decoration: BoxDecoration
              (
                color: const Color.fromARGB(222, 5, 202, 169), borderRadius: BorderRadius.circular(0),
              ),
              padding: const EdgeInsets.all(8.0),
              child: TextButton
              (
                onPressed: () 
                {
                  Navigator.pop
                  (
                    context,MaterialPageRoute(builder:(_)=> const StartFruitsPage())
                  );
                },
                child: const Text
                (
                  '返回我的Tree',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation:FloatingActionButtonLocation.endDocked,
      floatingActionButton:FloatingActionButton
      (
        onPressed:()
        {
          Navigator.push
          (
            context,MaterialPageRoute(builder:(context)=> const NewTreePage())
          );
        },
        tooltip: '創建Tree',
        backgroundColor: Colors.greenAccent,
        child:const Icon(Icons.add),
      ),
    );
  }
}