class SongsModel {
  final String? id;
  final String title;
  final String artist;
  final bool isFav;

  SongsModel({this.id, required this.title, required this.artist,required this.isFav});

  factory SongsModel.fromjson(Map<String, dynamic> json) {
    return SongsModel(
     title: json['title'], artist: json['artist'],isFav: json['isFav'],id: json['id']);
  }
}
