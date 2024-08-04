// ignore: file_names
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FloatExpendButtonAdd extends StatefulWidget 
{
  List<Icon> iconList;//按鈕圖標
  double? fabHeight;//按鈕高度
  double? iconsize;//主菜單按鈕圖標大小
  double? tabspace;//按鈕間隔
  Color? tabcolor;//按鈕颜色
  Color? MainTabBeginColor; //主菜單卡收起后颜色
  Color? MainTabAfterColor;//主菜單卡展开后颜色
  AnimatedIconData? MainAnimatedIcon;//主菜單卡變化圖標
  ButtonType1 type;//展开方向
  final Function(int index) callback;//按鈕的點擊事件
  FloatExpendButtonAdd
  (
    this.iconList,
    {
      super.key,
      required this.callback,
      this.fabHeight = 30,
      this.tabspace = 10,
      this.tabcolor = Colors.blue,
      this.MainTabBeginColor = Colors.red,
      this.MainTabAfterColor = Colors.grey,
      this.MainAnimatedIcon = AnimatedIcons.menu_close,
      this.iconsize = 15,
      this.type = ButtonType1.Left
    }
  );
  @override
  // ignore: library_private_types_in_public_api
  _FloatExpendButtonAddState createState() => _FloatExpendButtonAddState();
}

//旋轉變換按鈕 向上彈出的效果
class _FloatExpendButtonAddState extends State<FloatExpendButtonAdd>with SingleTickerProviderStateMixin 
{
  bool isOpened = false;//記錄是否打開
  late AnimationController _animationController;//動畫控制器
  late Animation<Color?> _animateColor;//颜色變化取值
  late Animation<double> _animateIcon;//圖標變化取值
  late Animation<double> _fabtween;//按鈕的位置動畫
  final Curve _curve = Curves.easeOut;//動畫執行速率
  @override
  initState() 
  {
    super.initState();
    _animationController =AnimationController(vsync: this, duration: const Duration(milliseconds: 300));//初始化動畫控制器
    _animationController.addListener(()
    {
      setState(() {});
    });
    //300毫秒內執行一个從0.0到0.1的變換過程
    _animateIcon =Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    //Colors的動畫過渡
    _animateColor = ColorTween
    (
      begin: widget.MainTabBeginColor,
      end: widget.MainTabAfterColor,
    ).animate(CurvedAnimation(parent: _animationController, curve: _curve));

    _fabtween = Tween<double>
    (
      begin: 0,
      end: _getfabtweenAfter(),
    ).animate
    (
      CurvedAnimation
      (
        parent: _animationController,
        curve: Interval
        (
        0.0,
        0.75,
        curve: _curve,
        ),
      )
    );
  }

  //根據類型獲取變化結束值
  double _getfabtweenAfter() 
  {
    if (widget.type == ButtonType1.Right || widget.type == ButtonType1.Bottom) 
    {
      return widget.fabHeight! + widget.tabspace!;
    } 
    else 
    {
      return -(widget.fabHeight! + widget.tabspace!);
    }
  }

  //根據類型獲取X轴移動數值
  double _getfabtranslateX(int i) 
  {
    if (widget.type == ButtonType1.Left || widget.type == ButtonType1.Right) 
    {
      return _fabtween.value * (i + 1);
    } 
    else 
    {
      return 0;
    }
  }

  //根據類型獲取Y轴移動數值
  double _getfabtranslateY(int i) 
  {
    if (widget.type == ButtonType1.Top || widget.type == ButtonType1.Bottom) 
    {
      return _fabtween.value * (i + 1);
    } 
    else 
    {
      return 0;
    }
  }

  //根據類型獲取主菜單位置
  AlignmentGeometry _getAligment() 
  {
    if (widget.type == ButtonType1.Top) 
    {
      return Alignment.bottomCenter;
    } 
    else if (widget.type == ButtonType1.Left) 
    {
      return Alignment.centerRight;
    } 
    else if (widget.type == ButtonType1.Bottom) 
    {
      return Alignment.topCenter;
    } 
    else 
    {
      return Alignment.centerLeft;
    }
  }
  @override
  Widget build(BuildContext context) 
  {
    //構建子菜單
    List<Widget> itemList = [];
    for (int i = 0; i < widget.iconList.length; i++) 
    {
      //FloatingActionButton的平移
      itemList.add
      (
        Transform
        (
          transform: Matrix4.translationValues(_getfabtranslateX(i), _getfabtranslateY(i), 0.0),
          child: Container
          (
            width: widget.fabHeight,
            height: widget.fabHeight,
            //margin: EdgeInsets.only(left: 10),
            child: FloatingActionButton
            (
              heroTag: "$i",
              elevation: 0.5,
              backgroundColor: widget.tabcolor,
              onPressed: () 
              {
                //點擊菜单子選項要求菜單彈縮回去
                //if(isOpened)
                //{
                floatClick();
                widget.callback(i);
                //}
              },
              child: Icon
              (
                widget.iconList[i].icon,
                key: widget.iconList[i].key,
                size: widget.iconList[i].size,
                semanticLabel: widget.iconList[i].semanticLabel,
                textDirection: widget.iconList[i].textDirection,
              ),
            ),
          ),
        ),
      );
    }

    return Stack
    (
      alignment: _getAligment(),
      children: 
      [
        widget.type == ButtonType1.Left || widget.type == ButtonType1.Right
            ? SizedBox
            (
              width: (widget.fabHeight! + widget.tabspace!) *widget.iconList.length +widget.fabHeight!
            )
            : SizedBox
            (
              height: (widget.fabHeight! + widget.tabspace!) *widget.iconList.length +widget.fabHeight!
            ),
      ]
      //根據横縱情况拓展點擊區域
      ..addAll(itemList)
      ..add
      (
        Positioned
        (
          child: floatButton(),
        )
      ),
    );
  }

  //構建固定旋轉菜單按鈕
  Widget floatButton() 
  {
    return Container
    (
      width: widget.fabHeight,
      height: widget.fabHeight,
      child: FloatingActionButton
      (
        //_animateColor實现背景颜色的過渡
        backgroundColor: _animateColor.value, // _animateColor.value
        onPressed: floatClick,
        elevation: 0.5,
        //AnimatedIcon實现icon的過渡
        child: AnimatedIcon
        (
          icon: widget.MainAnimatedIcon!,
          size: widget.iconsize,
          progress: _animateIcon,
        ),
      ),
    );
  }

  //FloatingActionButton的點擊事件，用来控制按鈕的動畫變換
  floatClick() 
  {
    if (!isOpened) 
    {
      _animationController.forward(); //展開動畫
    } else 
    {
      _animationController.reverse(); //收回動畫
    }
    isOpened = !isOpened;
  }

  //頁面銷毁時，銷毁動畫控制器
  @override
  dispose() 
  {
    _animationController.dispose();
    super.dispose();
  }
}
enum ButtonType1 { Left, Right, Top, Bottom }