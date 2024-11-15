import 'package:flutter/material.dart';
import 'package:flutter_rest_api/pages/album.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Album> getAlbum() async {
    await Future.delayed(const Duration(seconds: 3));
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

    if (response.statusCode == 200) {
      return Album.fromJson(response.body);
    } else {
      throw Exception('error');
    }
  }

  late Future<Album> futureAlbum;

  TextEditingController tittleController = TextEditingController();
  TextEditingController updateController = TextEditingController();
  @override
  void initState() {
    super.initState();
    futureAlbum = getAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        FutureBuilder<Album>(
          future: futureAlbum,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(snapshot.data!.id == 0
                      ? 'Deleted'
                      : snapshot.data!.title),
                  ElevatedButton(
                    child: const Text('Delete Data'),
                    onPressed: () {
                      setState(() {
                        futureAlbum = deleteAlbum(snapshot.data!.id.toString());
                      });
                    },
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            }
            return const CircularProgressIndicator();
          },
        ),
        const Divider(),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: tittleController,
              decoration: const InputDecoration(hintText: 'Enter Title'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blue),
              onPressed: () {
                setState(() {
                  futureAlbum = createAlbum(tittleController.text);
                  tittleController.clear();
                });
              },
              child: const Text('Create Data'),
            ),
            const SizedBox(
              height: 50,
            ),
            const Divider(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    controller: updateController,
                    decoration: const InputDecoration(hintText: 'Enter Title'),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    setState(() {
                      futureAlbum = updateAlbum(updateController.text);
                      updateController.clear();
                    });
                  },
                  child: const Text('Update Data'),
                ),
              ],
            ),
          ],
        )
      ]),
    );
  }
}
