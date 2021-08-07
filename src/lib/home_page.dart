import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:dictionary/home_page_components.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String url = 'https://owlbot.info/api/v4/dictionary/';
const String token = '10967fb5fb548b5f0e6ac1a53d643573810324ad';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _textController = TextEditingController();
  late StreamController _streamController;
  late Stream _stream;

  void _search() async {
    if (_textController.text == null || _textController.text.length == 0) {
      _streamController.add(null);
      return;
    }

    final uri = Uri.parse(url + _textController.text.trim());
    _streamController.add('waiting');
    http.Response resposne =
        await http.get(uri, headers: {"Authorization": "Token " + token});
    //print(resposne);

    if (resposne.statusCode == 404) {
      _streamController.add('No data');
      return;
    }
    _streamController.add(json.decode(resposne.body));
  }

  @override
  void initState() {
    _streamController = StreamController();
    _stream = _streamController.stream;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.greenAccent[700],
        title: Center(
          child: Text(
            'Dictionary',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Enter a word',
                      hintStyle: TextStyle(color: Colors.grey),
                      contentPadding: const EdgeInsets.only(left: 24.0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _search();
                  },
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: _stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            );
          }
          if (snapshot.data == 'No data') {
            return Center(
              child: CannotFindWord(),
            );
          }
          switch (snapshot.data) {
            case null:
              return Center(
                child: Text('Enter some word'),
              );
            case 'waiting':
              return Center(
                child: CircularProgressIndicator(),
              );
            default:
              return _buildWordCard(snapshot);
          }
        },
      ),
    );
  }

  ListView _buildWordCard(AsyncSnapshot<dynamic> snapshot) {
    return ListView.builder(
      itemCount: snapshot.data['definitions'].length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 20,
          ),
          decoration: BoxDecoration(
            color: Colors.greenAccent[400],
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListBody(
            children: [
              Column(
                children: [
                  if (snapshot.data["definitions"][index]["image_url"] != null)
                    ImgView(
                      img: snapshot.data["definitions"][index]["image_url"],
                    )
                  else
                    Container(),
                  SizedBox(
                    height: 10,
                  ),
                  WordAndTypeText(
                    word: snapshot.data["word"],
                    type: snapshot.data["definitions"][index]["type"],
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              DefinitionAndExampleText(
                definition: snapshot.data["definitions"][index]["definition"],
                example: snapshot.data["definitions"][index]["example"],
              ),
            ],
          ),
        );
      },
    );
  }
}


