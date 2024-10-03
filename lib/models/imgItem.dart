// To parse this JSON data, do
//
//     final imgItem = imgItemFromJson(jsonString);

import 'dart:convert';

ImgItem imgItemFromJson(String str) => ImgItem.fromJson(json.decode(str));

String imgItemToJson(ImgItem data) => json.encode(data.toJson());

class ImgItem {
    int total;
    int totalHits;
    List<Hit> hits;

    ImgItem({ 
        required this.total,
        required this.totalHits,
        required this.hits,
    });

    factory ImgItem.fromJson(Map<String, dynamic> json) => ImgItem(
        total: json["total"],
        totalHits: json["totalHits"],
        hits: List<Hit>.from(json["hits"].map((x) => Hit.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "total": total,
        "totalHits": totalHits,
        "hits": List<dynamic>.from(hits.map((x) => x.toJson())),
    };
}

class Hit {
  int id;
  String? pageUrl;
  String? type;
  String? tags;
  String? previewUrl;
  int previewWidth;
  int previewHeight;
  String? webformatUrl;
  int webformatWidth;
  int webformatHeight;
  String? largeImageUrl;
  String? fullHdurl;
  String? imageUrl;
  int imageWidth;
  int imageHeight;
  int imageSize;
  int views;
  int downloads;
  int likes;
  int comments;
  int userId;
  String? user;
  String? userImageUrl;

  Hit({
    required this.id,
    this.pageUrl,
    this.type,
    this.tags,
    this.previewUrl,
    required this.previewWidth,
    required this.previewHeight,
    this.webformatUrl,
    required this.webformatWidth,
    required this.webformatHeight,
    this.largeImageUrl,
    this.fullHdurl,
    this.imageUrl,
    required this.imageWidth,
    required this.imageHeight,
    required this.imageSize,
    required this.views,
    required this.downloads,
    required this.likes,
    required this.comments,
    required this.userId,
    this.user,
    this.userImageUrl,
  });

  factory Hit.fromJson(Map<String, dynamic> json) => Hit(
        id: json["id"],
        pageUrl: json["pageURL"] ?? '', // Using an empty string as a default
        type: json["type"] ?? '',
        tags: json["tags"] ?? '',
        previewUrl: json["previewURL"] ?? '',
        previewWidth: json["previewWidth"] ?? 0,
        previewHeight: json["previewHeight"] ?? 0,
        webformatUrl: json["webformatURL"] ?? '',
        webformatWidth: json["webformatWidth"] ?? 0,
        webformatHeight: json["webformatHeight"] ?? 0,
        largeImageUrl: json["largeImageURL"] ?? '', // Handle null here
        fullHdurl: json["fullHDURL"] ?? '',
        imageUrl: json["imageURL"] ?? '',
        imageWidth: json["imageWidth"] ?? 0,
        imageHeight: json["imageHeight"] ?? 0,
        imageSize: json["imageSize"] ?? 0,
        views: json["views"] ?? 0,
        downloads: json["downloads"] ?? 0,
        likes: json["likes"] ?? 0,
        comments: json["comments"] ?? 0,
        userId: json["user_id"] ?? 0,
        user: json["user"] ?? '',
        userImageUrl: json["userImageURL"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "pageURL": pageUrl,
        "type": type,
        "tags": tags,
        "previewURL": previewUrl,
        "previewWidth": previewWidth,
        "previewHeight": previewHeight,
        "webformatURL": webformatUrl,
        "webformatWidth": webformatWidth,
        "webformatHeight": webformatHeight,
        "largeImageURL": largeImageUrl,
        "fullHDURL": fullHdurl,
        "imageURL": imageUrl,
        "imageWidth": imageWidth,
        "imageHeight": imageHeight,
        "imageSize": imageSize,
        "views": views,
        "downloads": downloads,
        "likes": likes,
        "comments": comments,
        "user_id": userId,
        "user": user,
        "userImageURL": userImageUrl,
      };
}