import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_project/screens/GardenerSettingPage.dart';
//import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_project/FreeLeaf.dart';
import 'package:flutter_project/agora/agora_service.dart';

class CreateFreeLeafPage extends StatefulWidget 
{
  const CreateFreeLeafPage({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _CreateFreeLeafPageState createState() => _CreateFreeLeafPageState();
}

class _CreateFreeLeafPageState extends State<CreateFreeLeafPage> 
{
  // ignore: non_constant_identifier_names
  bool switchValue_Volume = true;
  // ignore: non_constant_identifier_names
  bool switchValue_Mic = true;
  // ignore: non_constant_identifier_names
  bool switchValue_Camera = true;
  // ignore: non_constant_identifier_names
  bool switchValue_Notify = true;

  final _textController = TextEditingController();

  String PostSeach = '';
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: const Center
        (
          child: Text('創建自由葉子'), //陰影
        ),
        backgroundColor: Colors.green,
        elevation: 0.0,
      ),
      drawer: Drawer
      (
        backgroundColor: Colors.white,
        child: SingleChildScrollView
        (
          child: Column
          (
            crossAxisAlignment: CrossAxisAlignment.start,
            children: 
            [
              Container
              (
                height: 100,
                color: Colors.green,
                child: Row
                (
                  // ignore: prefer_const_literals_to_create_immutables
                  children: const 
                  [
                    SizedBox(width: 20),
                    CircleAvatar
                    (
                      //圓形頭像
                      minRadius: 35,
                      maxRadius: 35,
                      backgroundImage: NetworkImage
                      (
                        'https://memeprod.ap-south-1.linodeobjects.com/user-maker-thumbnail/a3079365d1a6e3d7d6919a03ae9eaf82.gif',
                      ),
                    ),
                    SizedBox(width: 10),
                    Text
                    (
                      "Anya Forger",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
              ),
              // Divider(),
              const SizedBox
              (
                height: 20,
              ),
              Padding
              (
                //一個Padding是一個項目
                padding: const EdgeInsets.only(left: 15),
                child: GestureDetector
                (
                  onTap: (() 
                  {
                    // Navigator.pop(
                    //	 context,
                    //	 new MaterialPageRoute(
                    //		 builder: (context) => new HomePageMain()));
                  }),
                  child: Row
                  (
                    // ignore: prefer_const_literals_to_create_immutables
                    children: 
                    [
                      const Icon(Icons.person),
                      SizedBox
                      (
                        width: 150,
                        height: 50,
                        child: TextButton
                        (
                          child: const Text
                          (
                            "使用者檔案",
                            style: TextStyle
                            (
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black
                            ),
                          ),
                          onPressed: () 
                          {
                            Navigator.push
                            (
                              context,
                              MaterialPageRoute
                              (
                                builder: (_) =>const GardenerSettingPage()
                              )
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox
              (
                height: 10,
              ),
              ExpansionTile
              (
                //下拉式
                title: Row
                (
                  // ignore: prefer_const_literals_to_create_immutables
                  children: const 
                  [
                    Icon(CupertinoIcons.settings),
                    SizedBox
                    (
                      width: 10,
                    ),
                    Text
                    (
                      "設定",
                      style: TextStyle
                      (
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black
                      ),
                    )
                  ],
                ),
                childrenPadding:const EdgeInsets.only(left: 25), // children padding
                // ignore: prefer_const_literals_to_create_immutables
                children: 
                [
                  Padding
                  (
                    padding: const EdgeInsets.only(left: 15),
                    child: GestureDetector
                    (
                      onTap: (() 
                      {
                        // Navigator.push(
                        //	 context,
                        //	 new MaterialPageRoute(
                        //		 builder: (context) => new VendorVenuePage()));
                      }),
                      child: Row
                      (
                        // ignore: prefer_const_literals_to_create_immutables
                        children:
                        [
                          const Icon
                          (
                            CupertinoIcons.waveform_circle_fill,
                            color: Colors.black87,
                          ),
                          const SizedBox
                          (
                            width: 10,
                          ),
                          const Text
                          (
                            "音量",
                            style: TextStyle
                            (
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87
                            ),
                          ),
                          const Spacer(),
                          CupertinoSwitch
                          (
                            // This bool value toggles the switch.
                            value: switchValue_Volume,
                            activeColor: CupertinoColors.activeGreen,
                            onChanged: (bool? value) 
                            {
                              // This is called when the user toggles the switch.
                              setState(() 
                              {
                                switchValue_Volume = value ?? false;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding
                  (
                    padding: const EdgeInsets.only(left: 15),
                    child: GestureDetector
                    (
                      onTap: (() 
                      {
                        // Navigator.push(
                        //	 context,
                        //	 new MaterialPageRoute(
                        //		 builder: (context) =>
                        //			 new VendorPhotographerPage()));
                      }),
                      child: Row
                      (
                        // ignore: prefer_const_literals_to_create_immutables
                        //mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: 
                        [
                          const Icon(Icons.camera_alt_outlined),
                          const SizedBox
                          (
                            width: 10,
                          ),
                          const Text
                          (
                            "鏡頭",
                            style: TextStyle
                            (
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87
                            ),
                          ),
                          const Spacer(),
                          CupertinoSwitch
                          (
                            // This bool value toggles the switch.
                            value: switchValue_Camera,
                            activeColor: CupertinoColors.activeGreen,
                            onChanged: (bool? value) 
                            {
                              // This is called when the user toggles the switch.
                              setState(() 
                              {
                                switchValue_Camera = value ?? false;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding
                  (
                    padding: const EdgeInsets.only(left: 15),
                    child: GestureDetector
                    (
                      onTap: (() 
                      {
                        // Navigator.push(
                        //	 context,
                        //	 new MaterialPageRoute(
                        //		 builder: (context) =>
                        //			 new VendorCenematographyPage()));
                      }),
                      child: Row
                      (
                        // ignore: prefer_const_literals_to_create_immutables
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: 
                        [
                          const Icon(Icons.mic),
                          const SizedBox
                          (
                            width: 10,
                          ),
                          const Text
                          (
                            "麥克風",
                            style: TextStyle
                            (
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87
                            ),
                          ),
                          const Spacer(),
                          CupertinoSwitch
                          (
                            // This bool value toggles the switch.
                            value: switchValue_Mic,
                            activeColor: CupertinoColors.activeGreen,
                            onChanged: (bool? value) 
                            {
                              // This is called when the user toggles the switch.
                              setState(()
                              {
                                switchValue_Mic = value ?? false;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding
                  (
                    padding: const EdgeInsets.only(left: 15),
                    child: GestureDetector
                    (
                      onTap: (() 
                      {
                        // Navigator.push
                        // (
                        //	 context,
                        //	 new MaterialPageRoute
                        //(
                        //		 builder: (context) => new VendorMakeupPage()),
                        //);
                      }),
                      child: Row
                      (
                        // ignore: prefer_const_literals_to_create_immutables
                        children: 
                        [
                          const Icon(Icons.notifications),
                          const SizedBox
                          (
                            width: 10,
                          ),
                          const Text
                          (
                            "通知",
                            style: TextStyle
                            (
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87
                            ),
                          ),
                          const Spacer(),
                          CupertinoSwitch
                          (
                            // This bool value toggles the switch.
                            value: switchValue_Notify,
                            activeColor: CupertinoColors.activeGreen,
                            onChanged: (bool? value) 
                            {
                              // This is called when the user toggles the switch.
                              setState(() 
                              {
                                switchValue_Notify = value ?? false;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  //more child menu
                ],
              ),
              // const SizedBox
              // (
              // height: 10,
              // ),
            ],
          ),
        ),
      ),
      body: Column
      (
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>
        [
          Row
          (
            mainAxisAlignment: MainAxisAlignment.start,
            children: 
            [
              IconButton
              (
                tooltip: '返回上一頁',
                icon: const Icon(Icons.arrow_circle_left_outlined, size: 30),
                onPressed: () 
                {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          Center
          (
            child: Container
            (
              alignment: Alignment.center, //橫的
              height: 200.0,
              margin: const EdgeInsets.all(20.0),
              decoration: BoxDecoration
              (
                  borderRadius: const BorderRadius.only
                  (
                    topRight: Radius.circular(30.0),
                    topLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                  ),
                  color: Colors.green[300],
                  boxShadow: <BoxShadow>
                  [
                    BoxShadow
                    (
                      color: Colors.grey,
                      offset: Offset.fromDirection(1, 10)
                    ),
                  ]),
              child: Row
              (
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>
                  [
                    Column
                    (
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const <Widget>
                      [
                        SizedBox
                        (
                          width: 250,
                          height: 100,
                          child: Padding
                          (
                            padding: EdgeInsets.only(left: 30, top: 40),
                            child: TextField
                            (
                              obscureText: false,
                              decoration: InputDecoration
                              (
                                prefixIcon: Icon(Icons.eco),
                                hintText: '輸入葉子名稱',
                              ),
                            ),
                          ),
                        ),
                        SizedBox
                        (
                          width: 250, //width:350
                          height: 100,
                          child: Padding
                          (
                            padding:EdgeInsets.only(left: 40, top: 15, right: 10),
                            child: Text
                            (
                              "本葉子最高上限50人",
                              style: TextStyle
                              (
                                color: Colors.black45,
                                fontSize: 18,
                                fontWeight: FontWeight.w100
                              )
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column
                    (
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>
                      [
                        Padding
                        (
                          padding: const EdgeInsets.only(top: 50, left: 20, right: 10),
                          child: MaterialButton
                          (
                            onPressed: ()
                            {
                              setState(() 
                              {
                                PostSeach = _textController.text;
                              });
                            },
                            color: const Color.fromARGB(255, 0, 158, 71),
                            child: const Text
                            (
                              '確認',
                              style: TextStyle(color: Colors.white)
                            )
                          ),
                        ),
                      ],
                    ),
                  ]
              ),
            ),
          ),
          Row
          (
            mainAxisAlignment: MainAxisAlignment.end,
            children: 
            [
              ElevatedButton
              (
                onPressed: () 
                {
                  Navigator.push
                  (
                    context,MaterialPageRoute(builder:(context)=> const FreeLeafExample()) //20230726 here
                  );
                },
                style: ElevatedButton.styleFrom
                (
                  foregroundColor: Colors.white, //text
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder
                  (
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 15.0,
                ),
                child: const Padding
                (
                  padding: EdgeInsets.all(10.0),
                  child: Text
                  (
                    '進入葉子',
                    style: TextStyle(fontSize: 20),
                  )
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}