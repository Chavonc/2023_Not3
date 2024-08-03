// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_project/screens/CreateOverLappingLeafPage.dart';
import 'package:flutter_project/screens/CreateNormalLeafPage.dart';
import 'package:flutter_project/screens/CreateFreeLeafPage.dart';
class StartLeafPage extends StatefulWidget
{
  const StartLeafPage({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _StartLeafPageState createState()=>_StartLeafPageState();
}
class _StartLeafPageState extends State<StartLeafPage> 
{
  Widget getListView(BuildContext context) 
  {
    var listView=ListView
    (
      children:
      [
        Card
        (
          margin: const EdgeInsets.all(20),
          child:Column
          (
            children: <Widget>
            [
              ListTile
              (
                title:const Text
                (
                  "筆跡葉子",
                  style:TextStyle(fontWeight:FontWeight.bold),
                ),
                subtitle: const Text
                (
                  "普通模式",
                ),
                onTap:()
                {
                  Navigator.push
                  (
                    context,MaterialPageRoute(builder: (context)=>const CreateNormalLeafPage())
                  );
                },
                leading:const SizedBox
                (
                  width:150,
                  height:200,
                  child:Center
                  (
                    child:Image
                    (
                      image:AssetImage('assets/images/normal_leaf1.png'),
                      fit:BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
              const Divider(),
              const ListTile
              (
                title:Text
                (
                  "說明: 在同一份演講者檔案上，所有參與者能同時參與每頁筆記，會存取所有參與者的在檔案上寫的內容為一個檔案",
                ),
              ),
              const ListTile(),
            ],
          ),
        ),
        Card
        (
          margin: const EdgeInsets.all(20),
          child:Column
          (
            children: <Widget>
            [
              ListTile
              (
                title:const Text
                (
                  "圖層葉子",
                  style:TextStyle(fontWeight:FontWeight.bold),
                ),
                subtitle: const Text("普通模式"),
                onTap:()
                {
                  Navigator.push
                  (
                    context,MaterialPageRoute(builder: (context)=>const CreateOverLappingLeafPage())
                  );
                },
                leading:const SizedBox
                (
                  width:150,
                  height:200,
                  child:Center
                  (
                    child:Image
                    (
                      image:AssetImage('assets/images/overlapping_leaf1.png'),
                      fit:BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
              const Divider(),
              const ListTile
              (
                title:Text
                (
                  "說明: 在同一份演講者檔案上，所有參與者能選擇單獨只參與自己的每頁筆記圖層，過程中可檢視他人的圖層筆記，可只存取自己的圖層筆記",
                ),
              ),
              const ListTile(),
            ],
          ),
        ),
        Card
        (
          margin: const EdgeInsets.all(20),
          child:Column
          (
            children: <Widget>
            [
              ListTile
              (
                title:const Text
                (
                  "自由葉子",
                  style:TextStyle(fontWeight:FontWeight.bold),
                ),
                subtitle: const Text("空白模式"),
                onTap:()
                {
                  Navigator.push
                  (
                    context,MaterialPageRoute(builder: (context)=>const CreateFreeLeafPage())
                  );
                },
                leading:const SizedBox
                (
                  width:150,
                  height:200,
                  child:Center
                  (
                    child:Image
                    (
                      image:AssetImage('assets/images/free_leaf.png'),
                      fit:BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
              const Divider(),
              const ListTile
              (
                title:Text
                (
                  "說明: 不限制演講者等身分，只提供空白筆記，所有參與者能同時參與每頁筆記，按下直接進入葉子",
                ),
              ),
              const ListTile(),
            ],
          ),
        ),
      ], 
    );
    return listView;
  }
  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
       body:getListView(context)
    );
  }
}
