import 'package:flutter/cupertino.dart';
import 'crud_operations.dart';
import 'details.dart';
import 'students.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'convertir.dart';

class Busqueda extends StatefulWidget {
  @override
  _myHomePageState createState() => new _myHomePageState();
}

class _myHomePageState extends State<Busqueda> {
  //ELEMENTOS PARA BUSCAR
  String searchString = "";
  bool _isSearching = false;

  Future<List<Student>> studentss;
  var bdHelper;
  TextEditingController searchController = TextEditingController();
  String name;
  String paterno;
  String materno;
  String email;
  String phone;
  String matricula;
  String photo;
  String image;

  @override
  void initState() {
    super.initState();
    bdHelper = DBHelper();
    _isSearching = false;
    refreshList();
  }

  void refreshList() {
    setState(() {
      studentss = bdHelper.select(searchController.text);
    });
  }

  void cleanData() {
    searchController.text = "";
  }



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        title: _isSearching
            ? TextField(
          decoration: InputDecoration(hintText: "espere porfavor"),
          onChanged: (value) {
            setState(() {
              searchString = value;
            });
          },
          controller: searchController,
        )
            : Text(
          "Buscar",
          style: TextStyle(color: Colors.white),
        ),
        actions:  <Widget>[
          !_isSearching
              ? IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                searchString = "";
                this._isSearching = !this._isSearching;
              });
            },
          )
              : IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              setState(() {
                this._isSearching = !this._isSearching;
              });
            },
          ),
        ],

      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          child: FutureBuilder(
            future: studentss,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: Text("Cargando información..."),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return snapshot.data[index].matricula
                        .contains(searchController.text)
                        ? ListTile(
                      leading: CircleAvatar(
                        minRadius: 30.0,
                        maxRadius: 30.0,
                        backgroundImage: Convertir.imageFromBase64sString(
                            snapshot.data[index].photo)
                            .image,
                      ),
                      title: new Text(
                        snapshot.data[index].matricula
                            .toString()
                            .toUpperCase(),
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey
                        ),
                      ),
                      subtitle: new Text(
                        snapshot.data[index].name
                            .toString()
                            .toUpperCase() +" "+ snapshot.data[index].paterno
                            .toString()
                            .toUpperCase()+ " " + snapshot.data[index].materno
                            .toString()
                            .toUpperCase(),
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.white
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) =>
                                    DetailPage(snapshot.data[index])));
                      },
                    )
                        : Container();
                  },
                );
              }
            },
          ),
        ),
      ),

    );
  }
}
