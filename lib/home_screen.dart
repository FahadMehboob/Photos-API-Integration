import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Homescreen extends StatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List<Photosmodel> photosList = [];

  Future<List<Photosmodel>> getPhotos() async {
    final responce = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));
    var data = jsonDecode(responce.body.toString());
    if (responce.statusCode == 200) {
      for (Map i in data) {
        Photosmodel photos =
            Photosmodel(title: i['title'], url: i['url'], id: i['id']);
        photosList.add(photos);
      }
      return photosList;
    } else {
      return photosList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Photos API'),
      ),
      body: FutureBuilder(
        future: getPhotos(),
        builder: (context, AsyncSnapshot<List<Photosmodel>> snapshot) {
          return ListView.builder(
            itemCount: photosList.length,
            itemBuilder: (context, index) {
              return ListTile(
                  title: Text(snapshot.data![index].title.toString()),
                  subtitle: Text('User ID:${snapshot.data![index].id}'),
                  leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(snapshot.data![index].url.toString())));
            },
          );
        },
      ),
    );
  }
}

class Photosmodel {
  String title;
  String url;
  int id;

  Photosmodel({required this.title, required this.url, required this.id});
}
