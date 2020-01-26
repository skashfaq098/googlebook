import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
class VolumeJson {
  final int totalItems;

  final String kind;

  final List<Item> items;

  VolumeJson({this.items, this.kind, this.totalItems});

  factory VolumeJson.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['items'] as List;

    List<Item> itemList = list.map((i) => Item.fromJson(i)).toList();
    print(itemList.length);

    return VolumeJson(
        items: itemList,
        kind: parsedJson['kind'],
        totalItems: parsedJson['totalItems']);
  }
}

class Item {
  final String kind;

  final String etag;

  final VolumeInfo volumeinfo;

  Item({this.kind, this.etag, this.volumeinfo});

  factory Item.fromJson(Map<String, dynamic> parsedJson) {
    return Item(
        kind: parsedJson['kind'],
        etag: parsedJson['etag'],
        volumeinfo: VolumeInfo.fromJson(parsedJson['volumeInfo']));
  }
}

class VolumeInfo {
  final String title;

  final String publisher;

  final String printType;

  final ImageLinks image;



  VolumeInfo(
      {this.printType, this.title, this.publisher, this.image, });

  factory VolumeInfo.fromJson(Map<String, dynamic> parsedJson) {

    print('GETTING DATA');
    //print(isbnList[1]);
    return VolumeInfo(
      title: parsedJson['title'],
      publisher: parsedJson['publisher'],
      printType: parsedJson['printType'],
      image: ImageLinks.fromJson(
        parsedJson['imageLinks'],
      ),

    );
  }
}

class ImageLinks {
  final String thumb;

  ImageLinks({this.thumb});

  factory ImageLinks.fromJson(Map<String, dynamic> parsedJson) {
    return ImageLinks(thumb: parsedJson['thumbnail']);
  }
}

class ISBN {
  final String iSBN13;
  final String type;

  ISBN({this.iSBN13, this.type});

  factory ISBN.fromJson(Map<String, dynamic> parsedJson) {
    return ISBN(
      iSBN13: parsedJson['identifier'],
      type: parsedJson['type'],
    );
  }
}

class _HomePageState extends State<HomePage> {

  Map data;
  List userData;

  Future<VolumeJson> getRelateds() async {
    print('Im Starting');
    final jsonResponse =
        await http.get('https://www.googleapis.com/books/v1/volumes?q=isbn:0070495432');

    var jsonBody = json.decode(jsonResponse.body);
    //print(jsonBody);

    return volumelist = VolumeJson.fromJson(jsonBody);
    


  }

  @override
  void initState() {
    super.initState();
getRelateds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fake Friends"),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
          itemCount: userData == null ? 0 : userData.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
              mainAxisSize: MainAxisSize.min,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  fit: FlexFit.loose,
                  child: Container(
                      margin: EdgeInsets.all(2.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(
                                bottom: 3.0,
                                top: 30.0,
                              ),
                              child: Text(
                                'ISBN',
                                textAlign: TextAlign.left,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                          Container(
                              width: 150.0,
                              margin: EdgeInsets.only(bottom: 10.0, top: 3.0),
                              child: Text(
                                'ISBN HERE',
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                              )),
                          Container(
                            margin: EdgeInsets.only(bottom: 3.0, top: 10.0),
                            child: Text('Author',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 10.0, top: 3.0),
                            child: Text(
                              book.record.coverAuthors,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 3.0, top: 10.0),
                            child: Text('Format',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 10.0, top: 3.0),
                            child: Text(
                              volumelist.items[index].volumeinfo.printType,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                FlatButton(
                                  onPressed: () {},
                                  child: Text(
                                    'VIEW MORE DETAILS',
                                    style: TextStyle(color: Colors.deepPurple),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )),
                )
              ]
                ),
            ));
          },
      ),
    );
  }
}
