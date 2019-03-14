import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_stetho/flutter_stetho.dart';
import 'package:http/http.dart' as http;

void main() {
  Stetho.initialize();

  runApp(new FlutterStethoExample(
    client: new http.Client(),
    client2: new HttpClient(),
  ));
}

class FlutterStethoExample extends StatelessWidget {
  final http.Client client;
  final HttpClient client2;

  FlutterStethoExample({Key key, this.client, this.client2}) : super(key: key);

  fetchImage() {
    client.get(
      'https://flutter.io/images/flutter-mark-square-100.png',
      headers: {'Authorization': 'token'},
    );
  }

  fetchJson() async {
    HttpClientRequest req = await client2.openUrl(
        "POST", Uri.parse("https://jsonplaceholder.typicode.com/posts"));
    req.add(utf8.encode(json.encode({"name": "kondel"})));

    HttpClientResponse res = await req.close();
    // todo - you should check the response.statusCode
    String reply = await res.transform(utf8.decoder).join();
    client2.close();
  }

  fetchError() {
    client.get('https://jsonplaceholder.typicode.com/postadsass/1');
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Plugin example app'),
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Padding(
                padding: new EdgeInsets.all(16.0),
                child: new RaisedButton(
                  onPressed: fetchJson,
                  child: new Text("Fetch json"),
                ),
              ),
              new Padding(
                padding: new EdgeInsets.all(16.0),
                child: new RaisedButton(
                  onPressed: fetchImage,
                  child: new Text("Fetch image"),
                ),
              ),
              new Padding(
                padding: new EdgeInsets.all(16.0),
                child: new RaisedButton(
                  onPressed: fetchError,
                  child: new Text("Fetch with Error"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
