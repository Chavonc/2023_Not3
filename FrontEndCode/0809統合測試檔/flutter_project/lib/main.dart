import "package:flutter/material.dart";
//import "package:flutter_project/SignUp.dart";
import "package:flutter_project/HomePage.dart";
void main()=>runApp(const MyApp());
class MyApp extends StatelessWidget
{
  const MyApp({Key? key}):super(key: key);
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp
    (
      title: "Not3 App",
      debugShowCheckedModeBanner: false,
      theme:ThemeData
      (
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}