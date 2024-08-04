// ignore: file_names
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_project/MyPage1.dart';
// import 'package:flutter_project/MyPage2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_project/screens/GardenerSettingPage.dart';

class CreateNormalLeafPage extends StatefulWidget 
{
  const CreateNormalLeafPage({super.key});
  @override
  //ignore: library_private_types_in_public_api
  _CreateNormalLeafPageState createState() => _CreateNormalLeafPageState();
}

class _CreateNormalLeafPageState extends State<CreateNormalLeafPage> 
{
  // ignore: non_constant_identifier_names
  bool switchValue_Volume = true;
  // ignore: non_constant_identifier_names
  bool switchValue_Mic = true;
  // ignore: non_constant_identifier_names
  bool switchValue_Camera = true;
  // ignore: non_constant_identifier_names
  bool switchValue_Notify = true;
  //加Controller
  // ignore: unused_field
  final TextEditingController _searchController = TextEditingController();
  final _textController = TextEditingController();
  final List<String> dropdownItems = [];
  // ignore: non_constant_identifier_names
  String PostSeach = '';

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar
      (
        title: const Center(child: Text('創建筆跡葉子')),
        backgroundColor: Colors.green,
        elevation: 0.0, //陰影
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
                                builder: (_) =>
                                const GardenerSettingPage()
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
                childrenPadding:
                    const EdgeInsets.only(left: 25), // children padding
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
        crossAxisAlignment: CrossAxisAlignment.center,
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
          const Center
          (
            child: Text("筆跡葉子設定",
                style: TextStyle
                (
                  color: Colors.black45,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)
                ),
          ),
          Center(
            child: Container
            (
              alignment: Alignment.center, //橫的
              height: 500.0,
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
                      children: <Widget>
                      [
                        const SizedBox
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
                                hintText: '輸入會議名稱',
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
                            padding: const EdgeInsets.only
                            (
                              left: 30, top: 15, right: 10
                            ),
                            child: DropdownSearch<String>
                            (
                              popupProps: PopupProps.menu
                              (
                                showSelectedItems: true,
                                disabledItemFn: (String s) => s.startsWith('I'),
                              ),
                              items: const ["Xian", "Chavon", "Ting", 'Ping'],
                              dropdownDecoratorProps:
                                  const DropDownDecoratorProps
                                  (
                                dropdownSearchDecoration: InputDecoration
                                (
                                  labelText: "選擇演講者",
                                  hintText: "country in menu mode",
                                ),
                              ),
                              onChanged: print,
                              selectedItem: "Ping",
                            ),
                          ),
                        ),
                        SizedBox
                        (
                          width: 250, //width:350,
                          height: 100,
                          child: Padding
                          (
                              padding: const EdgeInsets.only
                              (
                                  left: 30, top: 15, right: 10),
                              child: DropdownSearch<String>
                              (
                                popupProps: PopupProps.menu
                                (
                                  showSelectedItems: true,
                                  disabledItemFn: (String s) =>
                                      s.startsWith('I'),
                                ),
                                items: const 
                                [
                                  " ",
                                  "Xian",
                                  "Chavon",
                                  "Ting",
                                  'Ping'
                                ],
                                dropdownDecoratorProps:
                                    const DropDownDecoratorProps
                                    (
                                  dropdownSearchDecoration: InputDecoration
                                  (
                                    labelText: "選擇管理者",
                                    hintText: "country in menu mode",
                                  ),
                                ),
                                onChanged: print,
                                selectedItem: "Chavon",
                              )),
                        ),
                        SizedBox
                        (
                          width: 250, //width:350,
                          height: 100,
                          child: Padding
                          (
                              padding: const EdgeInsets.only
                              (
                                  left: 30, top: 15, right: 10),
                              child: DropdownSearch<String>
                              (
                                popupProps: PopupProps.menu
                                (
                                  showSelectedItems: true,
                                  disabledItemFn: (String s) =>
                                      s.startsWith('I'),
                                ),
                                items: const 
                                [
                                  " ",
                                  "Xian",
                                  "Chavon",
                                  "Ting",
                                  'Ping'
                                ],
                                dropdownDecoratorProps:const DropDownDecoratorProps
                                (
                                  dropdownSearchDecoration: InputDecoration
                                  (
                                    labelText: "選擇管理者",
                                    hintText: "country in menu mode",
                                  ),
                                ),
                                onChanged: print,
                                selectedItem: " ",
                              )),
                        ),
                        const Padding
                        (
                          padding:
                              EdgeInsets.only(left: 10, top: 35, right: 10),
                          child: Text
                          (
                            '選擇要上傳的檔案',
                            textAlign: TextAlign.justify,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.w100),
                          ),
                        ),
                      ],
                    ),
                    Column
                    (
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>
                      [
                        Padding
                        (
                          padding: const EdgeInsets.only
                          (
                              top: 15, left: 20, right: 10),
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
                        Padding
                        (
                          padding: const EdgeInsets.only
                          (
                              top: 15, left: 20, right: 10),
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
                        Padding
                        (
                          padding: const EdgeInsets.only
                          (
                              top: 40, left: 20, right: 10),
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
                        Padding
                        (
                          padding: const EdgeInsets.only
                          (
                              top: 40, left: 20, right: 10),
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
                        Padding
                        (
                          //padding: const EdgeInsets.only(top: 30,left:180),//pc
                          padding: const EdgeInsets.only
                          (
                              top: 30, left: 20, right: 10), //android phone
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
                                '檔案上傳',
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                      ],
                    ),
                  ]),
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
                  Navigator.of(context).pop();
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