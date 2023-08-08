import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:pyramidion_two/controller/provider/provider.dart';

class Widgets {
  void showSimpleBottomSheet(context, height) {
    showModalBottomSheet(
      backgroundColor: Colors.black,
      enableDrag: true,
      showDragHandle: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      context: context,
      builder: (context) => SizedBox(
        height: height / 1.2,
        width: double.infinity,
        child: FutureBuilder(
            future: fetchMusicFiles(),
            builder: (context, item) {
              if (item.data == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (item.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'No Song Available',
                    style:
                        TextStyle(color: Colors.white, fontFamily: 'poppins'),
                  ),
                );
              }
              return ListView.builder(
                itemBuilder: ((context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(right: 14, left: 14, bottom: 7),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(255, 121, 47, 195)),
                      child: ListTile(
                          iconColor: Colors.white,
                          selectedColor: Colors.purpleAccent,
                          leading: QueryArtworkWidget(
                              id: item.data![index].id,
                              type: ArtworkType.AUDIO,
                              nullArtworkWidget: const CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 27,
                                  backgroundImage: NetworkImage(
                                      'https://i.pinimg.com/564x/2d/0b/62/2d0b62c8d00a8b689aa5dc9117292a9a.jpg'))),
                          title: SizedBox(
                            width: double.infinity / 2,
                            child: Text(
                              item.data![index].displayNameWOExt,
                              style: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontFamily: 'poppins',
                                  color: Colors.white),
                            ),
                          ),
                          subtitle: Text(
                            '${item.data![index].artist == "<unknown>" ? "Unknown Artist" : item.data![index].artist}',
                            maxLines: 1,
                            style: const TextStyle(
                                fontFamily: 'poppins',
                                fontSize: 12,
                                color: Colors.blueGrey),
                          ),
                          trailing: Wrap(children: [
                            IconButton(
                                onPressed: () {
                                  addSong(item.data![index].title,
                                      item.data![index].artist, context);
                                },
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ))
                          ])),
                    ),
                  );
                }),
                itemCount: item.data!.length,
              );
            }),
      ),
    );
  }

  Future<List<SongModel>> fetchMusicFiles() async {
    OnAudioQuery audioQuery = OnAudioQuery();

    List<SongModel> songs = await audioQuery.querySongs();

    List<SongModel> musicFiles = songs
        .where((song) =>
            song.isMusic! &&
            song.title.isNotEmpty &&
            song.displayName.toLowerCase().endsWith('.mp3'))
        .toList();
    return musicFiles;
  }

  void addSong(title, artist, context) {
    final provider = Provider.of<ProviderClass>(context, listen: false);
    provider.db
        .collection('songs')
        .add({'title': title, 'artist': artist, 'isFav': false}).then((value) {
      provider.db.collection('songs').doc(value.id).update({"id": value.id});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Song $title Added",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 121, 47, 195),
      ));
    });
  }
}
