
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'package:pyramidion_two/controller/provider/provider.dart';
import 'package:pyramidion_two/view/widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderClass>(context, listen: false);

    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            requestStoragePermission(height);
          },
          child: const Icon(Icons.add)),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 121, 47, 195),
        title: const Text(
          "HomeScreen",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: provider.getAllSongs(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!.isEmpty
                  ? const Center(
                      child: Text(
                      'Empty Songlist',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))
                  : Consumer<ProviderClass>(
                      builder: (context, value, child) => ListView.builder(
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            final data = snapshot.data![index];
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 4, top: 4),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: ListTile(
                                    trailing: CupertinoSwitch(
                                      activeColor: const Color.fromARGB(
                                          255, 121, 47, 195),
                                      value: data.isFav,
                                      onChanged: (state) {
                                        value.isFav = state;
                                        value.db
                                            .collection('songs')
                                            .doc(data.id)
                                            .update({"isFav": state});
                                        value.reload();
                                        if (state) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                "${data.title} added to favourite"),
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 121, 47, 195),
                                          ));
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                "${data.title} removed from favourite"),
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 121, 47, 195),
                                          ));
                                        }
                                      },
                                    ),
                                    title: Text(
                                      data.title,
                                      style: const TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Center(
                  child: Text(
                'Empty Songlist',
                style: TextStyle(fontWeight: FontWeight.bold),
              ));
            }
          }),
    );
  }

  Future<void> requestStoragePermission(height) async {
    final PermissionStatus status = await Permission.storage.request();

    if (status.isGranted) {
      Widgets().showSimpleBottomSheet(context, height);
    } else if (status.isDenied) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text("You can't get songs without enabling storage permission"),
          backgroundColor: Colors.red,
        ));
      }
    } else if (status.isPermanentlyDenied) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("You need to enable storage permission in settings"),
          backgroundColor: Colors.red,
        ));
      }
    }
  }
}
