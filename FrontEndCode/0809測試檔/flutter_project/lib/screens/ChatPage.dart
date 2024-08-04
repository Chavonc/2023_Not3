// ignore: file_names
import 'package:flutter/material.dart';

//import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_project/models/ChatPageUsersModel.dart';
import 'package:flutter_project/components/ConversationList.dart';
import 'chattest.dart';
class ChatPage extends StatefulWidget 
{
  const ChatPage({super.key});
  @override
  //ignore: library_private_types_in_public_api
  _ChatPageState createState()=>_ChatPageState();
}
class _ChatPageState extends State<ChatPage>
{
  final _textController=TextEditingController();
  String textSeach='';
  List<ChatPageUsersModel> chatPageUsersModel=
  [
    ChatPageUsersModel(name:'Xian',messageText:'Set',imageURL:'assets/images/twoside_leaf.png',time:'Now'),
    ChatPageUsersModel(name:'Ting',messageText:'Hi',imageURL:'assets/images/maple_leaf2.png',time:'Now'),
    ChatPageUsersModel(name:'Ping',messageText:'Bye',imageURL:'assets/images/normal_leaf2.png',time:'Now'),
  ];
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      body:SingleChildScrollView
      (
        physics: const BouncingScrollPhysics(),
        child:Container
        (
          padding:const EdgeInsets.all(16.0),
          child:Column
          (
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>
            [
              Row
              (
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>
                [
                  // Column
                  // (
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: const <Widget>
                  //   [
                  //     Padding
                  //     (
                  //       padding:EdgeInsets.only(left:3,top:0),
                  //       child:Text
                  //       (
                  //         "聊天室",
                  //         style:TextStyle(fontSize:20,fontWeight: FontWeight.bold),
                  //       ),
                  //     ),                    
                  //   ],
                  // ),
                  Column
                  (
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>
                    [
                      Column
                      (
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>
                        [
                          SizedBox
                          (
                            width: 270,
                            height:100,
                            child:Padding
                            (
                              padding:const EdgeInsets.only(top:35,left:5),
                              child:TextField
                              (
                                controller:_textController,
                                decoration:InputDecoration
                                (
                                  hintText:  "搜尋名字",
                                  hintStyle: TextStyle(color:Colors.grey.shade600),
                                  prefixIcon: Icon(Icons.search,color:Colors.grey.shade600,size:20),
                                  suffixIcon:IconButton
                                  (
                                    onPressed: ()
                                    {
                                      _textController.clear();
                                    },
                                    icon: const Icon(Icons.clear),
                                  ),
                                  filled:true,
                                  fillColor: Colors.grey.shade100,
                                  contentPadding: const EdgeInsets.all(8),
                                  enabledBorder: OutlineInputBorder
                                  (
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(color:Colors.grey.shade100)
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column
                  (
                    children: <Widget>
                    [
                      Padding
                      (
                        padding:const EdgeInsets.only(top:25,left:20),
                        child:MaterialButton
                        (
                          onPressed: ()
                          {
                            setState(()
                            {
                              textSeach=_textController.text;
                            });
                          },
                          color:const Color.fromARGB(255,0,158,71),
                          child: const Text('Search',style:TextStyle(color:Colors.white))
                        ),
                      ),
                    ],
                  ),
                  Column
                  (
                    children: <Widget>
                    [
                      Padding
                      (
                        padding:const EdgeInsets.only(top:25,left:20),
                        child:MaterialButton
                        (
                          onPressed: ()
                          {
                            Navigator.push
                            (
                              context,MaterialPageRoute(builder:(context)=> const ChatTest())
                            );
                          },
                          color:const Color.fromARGB(255,0,158,71),
                          child: const Text('測試',style:TextStyle(color:Colors.white))
                        ),
                      ),
                    ],
                  ),

                ],
              ),
              ListView.builder
              (
                itemCount: chatPageUsersModel.length,
                shrinkWrap: true,
                padding:const EdgeInsets.only(top:16),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context,index)
                {
                  return ConversationList
                  (
                    name:chatPageUsersModel[index].name,
                    messageText:chatPageUsersModel[index].messageText,
                    imageUrl:chatPageUsersModel[index].imageURL,
                    time:chatPageUsersModel[index].time,
                    isMessageRead:(index==0||index==3)?true:false
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}