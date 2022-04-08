import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'models/post.dart';

Future<Post> fetchPost(user, email) async {
  final response = await http.post(Uri.parse('http://localhost:8080/post'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({'user': user, 'email': email}));
  if (response.statusCode == 200) {
    return Post.fromJson(json.decode(response.body)['body']);
  } else {
    throw Exception('Failed to load data');
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<Post> post;

  @override
  void initState() {
    super.initState();
    post = fetchPost('Aiden', 'aiden@gmail.com');
  }

  void _fetchAgain() {
    setState(() {
      post = fetchPost('John', 'John@gmail.com');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Response Body',
              style: Theme.of(context).textTheme.headline4,
            ),
            const SizedBox(
              height: 10,
            ),
            FutureBuilder(
                future: post,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        Text(snapshot.data.user),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(snapshot.data.email)
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return const CircularProgressIndicator();
                })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchAgain,
        tooltip: 'fetch',
        child: Icon(Icons.refresh),
      ),
    );
  }
}
