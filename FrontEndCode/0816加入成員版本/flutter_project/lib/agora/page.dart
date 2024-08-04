import 'package:flutter/material.dart';

abstract class FastExamplePage extends StatelessWidget { //頁面框架設定
  const FastExamplePage(
    this.leading,
    this.title, {
    this.fullscreen = true,
  });

  final Widget leading;
  final String title;
  final bool fullscreen;
}
