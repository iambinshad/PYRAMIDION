import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pyramidion_two/model/song_model.dart';

class ProviderClass with ChangeNotifier {
  int currentBottomIndex = 0;
  bool isFav = false;

  List<SongsModel> arr = [];

  final db = FirebaseFirestore.instance;
  
  void setBottomIndex(value) {
    currentBottomIndex = value;
    notifyListeners();
  }

  void reload(){
    notifyListeners();
  }

  void setFavourite(data,value) {
    db.collection('songs').doc(data!.id).update({"isFav": value});
    notifyListeners();
  }

    Stream<List<SongsModel>> getAllSongs() {
    return db.collection('songs').snapshots().map((event) {
      return event.docs.map((e) {
        return SongsModel.fromjson(e.data());
      }).toList();
    });
  }

}
