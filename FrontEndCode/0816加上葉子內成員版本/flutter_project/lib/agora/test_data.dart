import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// 定義CloudFile類，用於儲存雲端檔案的資訊
class CloudFile {
  String type; // 檔案類型
  String url; // 檔案URL
  String name; // 檔案名稱
  String? taskUUID; // 任務UUID
  String? taskToken; // 任務令牌
  int? width; // 圖片寬度
  int? height; // 圖片高度

  CloudFile({
    required this.type,
    required this.name,
    required this.url,
    this.width = null,
    this.height = null,
    this.taskUUID = null,
    this.taskToken = null,
  });

  // 從JSON解析資料，並建立CloudFile物件
  CloudFile.fromJson(Map<String, dynamic> map)
      : this(
          type: map["type"], // 從JSON中獲取檔案類型
          name: map["name"], // 從JSON中獲取檔案名稱
          url: map["url"], // 從JSON中獲取檔案URL
          taskUUID: map["taskUUID"], // 從JSON中獲取任務UUID（如果有的話）
          taskToken: map["taskToken"], // 從JSON中獲取任務令牌（如果有的話）
          width: map["width"], // 從JSON中獲取圖片寬度（如果有的話）
          height: map["height"], // 從JSON中獲取圖片高度（如果有的話）
        );
}

class TestData {
  // 定義測試用的JSON資料，包含多個雲端檔案的資訊
  static var kCloudJson = '''
        [{
            "type": "pdf",
            "name": "开始使用 Flat.pdf",
            "url": "https://flat-storage.oss-accelerate.aliyuncs.com/cloud-storage/2022-02/15/09faea1a-42f2-4ef6-a40d-7866cc5e1104/09faea1a-42f2-4ef6-a40d-7866cc5e1104.pdf",
            "taskUUID": "fddaeb908e0b11ecb94f39bd66b92986",
            "taskToken": "NETLESSTASK_YWs9NWJod2NUeXk2MmRZWC11WiZub25jZT1mZTFlZjk3MC04ZTBiLTExZWMtYTMzNS01MWEyMGJkNzRiZjYmcm9sZT0yJnNpZz1jZGQwMzMyZTFlZTkwNGEyNjhlMjQ0NDc0NWQ4MTY0ZTAzNzNiOTIxZmI4ZDY0YTE0MTJiZTU5MmUwMjM3MzM4JnV1aWQ9ZmRkYWViOTA4ZTBiMTFlY2I5NGYzOWJkNjZiOTI5ODY"
        }, {
            "type": "pptx",
            "name": "Get Started with Flat.pptx",
            "url": "https://flat-storage.oss-accelerate.aliyuncs.com/cloud-storage/2022-02/15/d9e8a040-5b44-4867-b4ea-dcd5551dd5a8/d9e8a040-5b44-4867-b4ea-dcd5551dd5a8.pptx",
            "taskUUID": "feae41208e0b11ecb954e907f43a0c2c",
            "taskToken": "NETLESSTASK_YWs9NWJod2NUeXk2MmRZWC11WiZub25jZT1mZWI5YjJkMC04ZTBiLTExZWMtYTMzNS01MWEyMGJkNzRiZjYmcm9sZT0yJnNpZz00MDc2MjU2YmIwNzI3YmU1NWUxMGQ1YmMxOTI1ZjNjZWZlMDIyZjE3Yzg2MzU4MWM3MjQzZDdhZGQ0MzVkOGM4JnV1aWQ9ZmVhZTQxMjA4ZTBiMTFlY2I5NTRlOTA3ZjQzYTBjMmM"
        }, {
            "type": "mp4",
            "name": "oceans.mp4",
            "url": "https://flat-storage.oss-accelerate.aliyuncs.com/cloud-storage/2022-02/15/55509848-5437-463e-b52c-f81d1319c837/55509848-5437-463e-b52c-f81d1319c837.mp4"
        }, {
            "type": "png",
            "name": "lena_color.png",
            "url": "https://flat-storage.oss-accelerate.aliyuncs.com/cloud-storage/2022-02/15/ebe8320a-a90e-4e03-ad3a-a5dc06ae6eda/ebe8320a-a90e-4e03-ad3a-a5dc06ae6eda.png",
            "width": 512,
            "height": 512
        }, {
            "type": "png",
            "name": "lena_gray.png",
            "url": "https://flat-storage.oss-accelerate.aliyuncs.com/cloud-storage/2022-02/15/8d487d84-e527-4760-aeb6-e13235fd541f/8d487d84-e527-4760-aeb6-e13235fd541f.png",
            "width": 512,
            "height": 512
        }, {
            "type": "leave", 
            "name": "點選離開葉子",
            "url": "",
            "taskUUID": "",
            "taskToken": ""
        } ]
        ''';
  //最後一筆資料暫時當作離開葉子測試
  // 解析JSON資料為List<CloudFile>
  static List<CloudFile> kCloudFiles = (jsonDecode(kCloudJson) as List)
      .map((e) => CloudFile.fromJson(e))
      .toList();

  // 定義不同檔案類型的SVG圖示
  static Widget iconAdd = SvgPicture.asset(
    "assets/ic_cloud_add.svg",
  );
  static Widget iconImage = SvgPicture.asset(
    "assets/ic_cloud_image.svg",
  );
  static Widget iconPdf = SvgPicture.asset(
    "assets/ic_cloud_pdf.svg",
  );
  static Widget iconPpt = SvgPicture.asset(
    "assets/ic_cloud_ppt.svg",
  );
  static Widget iconVideo = SvgPicture.asset(
    "assets/ic_cloud_video.svg",
  );
}
