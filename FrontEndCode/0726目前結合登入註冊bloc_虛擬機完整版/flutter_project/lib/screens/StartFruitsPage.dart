// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_project/MyPage2.dart';
class StartFruitsPage extends StatefulWidget 
{
  const StartFruitsPage({super.key});
  @override
  //ignore: library_private_types_in_public_api
  _StartFruitsPageState createState()=>_StartFruitsPageState();
}
class _StartFruitsPageState extends State<StartFruitsPage>
{
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      body:Column
      (
        mainAxisAlignment:MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>
        [
          const Center
          (
            child:Text("透過創建Tree來分類您的葉子們優",style: TextStyle(color: Colors.black45,fontSize: 20,fontWeight: FontWeight.bold)),
          ),
          Center
          (
            child:Container
            (
              alignment: Alignment.topCenter,
              child:Image.asset('assets/images/StartFruits_2.png',width: 150,height: 150),
            ),
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
                  Navigator.push
                  (
                    context,MaterialPageRoute(builder:(_)=> const MyPage2())
                  );
                },
                child: const Text
                (
                  '創建我的Tree',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
            // ignore: avoid_unnecessary_containers
          ),
        ],
      ),
    );
  }
}
