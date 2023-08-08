import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pyramidion_two/model/song_model.dart';

class FavouriteScreen extends StatelessWidget {
  FavouriteScreen({Key? key}) : super(key: key);

  final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 121, 47, 195),
        title: const Text(
          "Favourite",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: getAllSongs(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<SongsModel> songs = snapshot.data as List<SongsModel>;
            final List<SongsModel> favoriteSongs =
                songs.where((song) => song.isFav == true).toList();
            return favoriteSongs.isEmpty
                ? const Center(child: Text('Empty Favourite',style: TextStyle(fontWeight: FontWeight.bold),))
                : ListView.builder(
                    itemCount: favoriteSongs.length,
                    itemBuilder: (context, index) {
                      final SongsModel song = favoriteSongs[index];
                      return Padding(
                              padding: const EdgeInsets.only(left: 10,right: 10,bottom: 4,top: 4),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ListTile(
                              title: Text(
                                song.title,
                                style: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(child: Text('Empty Favourite',style: TextStyle(fontWeight: FontWeight.bold),));
          }
        },
      ),
    );
  }

  Stream<List<SongsModel>> getAllSongs() {
    return db.collection('songs').snapshots().map((event) {
      return event.docs.map((e) {
        return SongsModel.fromjson(e.data());
      }).toList();
    });
  }
}
