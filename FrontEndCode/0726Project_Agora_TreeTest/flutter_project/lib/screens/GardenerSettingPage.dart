// ignore: file_names
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class GardenerSettingPage extends StatefulWidget 
{
  const GardenerSettingPage({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _GardenerSettingPageState createState()=>_GardenerSettingPageState();
}
class _GardenerSettingPageState extends State<GardenerSettingPage>
{
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: const Center(child: Text('編輯園丁檔案')),
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
                child: const Row
                (
                  // ignore: prefer_const_literals_to_create_immutables
                  children: 
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
                        height:50,
                        child:TextButton
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
                              context,MaterialPageRoute(builder:(_)=> const GardenerSettingPage())
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
                title: const Row
                (
                  // ignore: prefer_const_literals_to_create_immutables
                  children: 
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
                childrenPadding: const EdgeInsets.only(left: 25), // children padding
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
                      child: const Row
                      (
                        // ignore: prefer_const_literals_to_create_immutables
                        children: 
                        [
                          Icon
                          (
                            CupertinoIcons.waveform_circle_fill,
                            color: Colors.black87,
                          ),
                          SizedBox
                          (
                            width: 10,
                          ),
                          Text
                          (
                            "音量",
                            style: TextStyle
                            (
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87
                            ),
                          )
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
                      child: const Row
                      (
                        // ignore: prefer_const_literals_to_create_immutables
                        children: 
                        [
                          Icon(Icons.camera_alt_outlined),
                          SizedBox
                          (
                            width: 10,
                          ),
                          Text
                          (
                            "鏡頭",
                            style: TextStyle
                            (
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87
                            ),
                          )
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
                      child: const Row
                      (
                        // ignore: prefer_const_literals_to_create_immutables
                        children: 
                        [
                          Icon(Icons.mic),
                          SizedBox
                          (
                            width: 10,
                          ),
                          Text
                          (
                            "麥克風",
                            style: TextStyle
                            (
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87
                            ),
                          )
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
                      child: const Row
                      (
                        // ignore: prefer_const_literals_to_create_immutables
                        children: 
                        [
                          Icon(Icons.notifications),
                          SizedBox
                          (
                            width: 10,
                          ),
                          Text
                          (
                            "通知",
                            style: TextStyle
                            (
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87
                            ),
                          )
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
      body:const Setting(),
    );
  }
}
class Setting extends StatefulWidget
{
  const Setting({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _SettingState createState()=>_SettingState();

}
class _SettingState extends State<Setting>
{
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      backgroundColor: Colors.white,
      body:SafeArea
      (
        child:Container
        (
          padding:const EdgeInsets.all(16.0),
          child:Column
          (
            mainAxisAlignment: MainAxisAlignment.center,
            children:
            [
              Row
              (
                mainAxisAlignment: MainAxisAlignment.start,
                children:<Widget>
                [
                  IconButton
                  (
                    tooltip: '返回上一頁',
                    icon:const Icon(Icons.arrow_circle_left_outlined,size:30),
                    onPressed: (){Navigator.of(context).pop();},
                  ),
                ],
              ),
              const Row
              (
                mainAxisAlignment: MainAxisAlignment.center,
                children:<Widget>[Icon(Icons.account_circle,size:150),],
              ),
              Row
              (
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>
                [
                  IconButton//打開相簿上傳圖片
                  (
                    tooltip: '相簿上傳',
                    icon:const Icon(Icons.image,size:25), 
                    onPressed:(){_onAlbumButtonPressed();}
                  ),
                  IconButton//打開相機拍照
                  (
                    tooltip: '相機拍照',
                    icon:const Icon(Icons.camera_alt,size:25),
                    onPressed: () {_onCameraButtonPressed();}
                  ),
                  IconButton//打開雲端上傳圖片
                  (
                    tooltip: '雲端上傳',
                    icon:const Icon(Icons.upload_file,size:25),
                    onPressed: () {_onUploadButtonPressed();}
                  )
                ],
              ),
             const SizedBox
              (
                width:300,
                height:80,
                child:TextField
                (
                  obscureText: false,
                  decoration:InputDecoration
                  (
                    prefixIcon: Icon(Icons.person),
                    labelText: "姓名",
                    hintText: "請輸入欲更改的姓名",
                  ),
                ),
              ),
              const SizedBox
              (
                width:300,
                height:80,
                child:TextField
                (
                  obscureText: false,
                  decoration:InputDecoration
                  (
                    prefixIcon: Icon(Icons.email),
                    labelText: "帳號",
                    hintText: "請輸入欲更改的Email帳號",
                  ),
                ),
              ),
              const SizedBox
              (
                width:300,
                height:80,
                child:TextField
                (
                  obscureText: true,
                  decoration:InputDecoration
                  (
                    prefixIcon: Icon(Icons.lock),
                    labelText: "密碼",
                    hintText: "請輸入欲更改的密碼",
                  ),
                ),
              ),
              SizedBox
              (
                width:150,
                child: TextButton
                (
                  child: const Text
                  (
                    "確認更新/修改資料",
                    style:TextStyle(color:Colors.green),
                  ),
                  onPressed: () {_UpdateButtonOnPressed();},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  //目前沒有功能，用OnPressed之後在terminal出現
  void _onAlbumButtonPressed()
  {
    if (kDebugMode) 
    {
      print("The Button of Uploaded Picture from Album has been clicked!");
    }
  }
  void _onCameraButtonPressed()
  {
    if (kDebugMode) 
    {
      print("The Button of Camera has been clicked!");
    }
  }
  void _onUploadButtonPressed()
  {
    if (kDebugMode) 
    {
      print("The Button of Google Drive Uploading has been clicked!");
    }
  }
  // ignore: non_constant_identifier_names
  void _UpdateButtonOnPressed()
  {
    if(kDebugMode)
    {
      print("The Update Button has been clicked!");
    }
  }
}