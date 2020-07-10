import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'actualizar.dart';
import 'borrar.dart';
import 'buscar.dart';
import 'convertir.dart';
import 'crud_operations.dart';
import 'insertar.dart';
import 'students.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark),
      home: homePage(),
    );
  }
}

class homePage extends StatefulWidget {
  @override
  _myHomePageState createState() => new _myHomePageState();
}

class _myHomePageState extends State<homePage> {
  //Variables referentes al manejo de la bd
  Future<List<Student>> Studentss;
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerPaterno = TextEditingController();
  TextEditingController controllerMaterno = TextEditingController();
  TextEditingController controllerPhone = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerMatricula = TextEditingController();
  String name;
  String paterno;
  String materno;
  String email;
  String phone;
  String matricula;
  int currentUserId;
  var bdHelper;
  bool isUpdating;
  final _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    bdHelper = DBHelper();
    isUpdating = false;
    refreshList();
  }

  void refreshList() {
    setState(() {
      Studentss = bdHelper.getStudents(null);
    });
  }

  void cleanData() {
    controllerName.text = "";
    controllerPaterno.text = "";
    controllerMaterno.text = "";
    controllerPhone.text = "";
    controllerEmail.text = "";
    controllerMatricula.text = "";
  }

  Widget menu() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            padding: EdgeInsets.all(55.0),
            child: Text(
              "Menú",
              style: TextStyle(color: Colors.white, fontSize: 35),
              textAlign: TextAlign.center,
            ),
            decoration: BoxDecoration(color: Colors.redAccent),
          ),
          ListTile(
            leading: Icon(Icons.search, size: 28.0, color: Colors.white),
            title: Text('Buscar', style: TextStyle(fontSize: 15.0, color: Colors.white)),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Busqueda()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.settings_backup_restore,
              color: Colors.white,
              size: 28.0,
            ),
            title: Text(
              'Actualizar',
              style: TextStyle(fontSize: 15.0, color: Colors.white),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Actualizar()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.add,
              color: Colors.white,
              size: 28.0,
            ),
            title: Text('Insertar',
                style: TextStyle(fontSize: 15.0, color: Colors.white)),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Insertar()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.delete,
              color: Colors.redAccent,
              size: 28.0,
            ),
            title: Text('Eliminar',
                style: TextStyle(fontSize: 15.0, color: Colors.white)),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => borrar()));
            },
          ),
        ],
      ),
    );
  }

  //Mostrar datos
  SingleChildScrollView dataTable(List<Student> Studentss) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(
                label: Text(
                  "Control",
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              DataColumn(
                label: Text("Matricula",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
              DataColumn(
                label: Text("Name",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
              DataColumn(
                label: Text("A Paterno",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
              DataColumn(
                label: Text("A Materno",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
              DataColumn(
                label: Text("telefono",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
              DataColumn(
                label: Text("Email",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
              DataColumn(label: Text("Foto",
                  style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),)
            ],
            rows: Studentss.map((student) => DataRow(cells: [
              DataCell(Text(student.controlum.toString(),
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey))),
              DataCell(Text(student.matricula.toString(),
                  style:
                  TextStyle(fontSize: 16.0, color: Colors.white))),
              DataCell(
                Text(student.name.toString(),
                    style: TextStyle(
                        fontSize: 16.0, color: Colors.white)),
              ),
              DataCell(Text(student.paterno.toString(),
                  style:
                  TextStyle(fontSize: 16.0, color: Colors.white))),
              DataCell(Text(student.materno.toString(),
                  style:
                  TextStyle(fontSize: 16.0, color: Colors.white))),
              DataCell(Text(student.phone.toString(),
                  style:
                  TextStyle(fontSize: 16.0, color: Colors.white))),
              DataCell(Text(student.email.toString(),
                  style:
                  TextStyle(fontSize: 16.0, color: Colors.white))),
              DataCell(
                ListTile(
                  leading: CircleAvatar(
                  radius: 20,
                  child: ClipOval(
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: Convertir.imageFromBase64sString(student.photo),
                    ),
                  ),  
              ),
                )
              ),
            ])).toList(),
          ),
        ));
  }

  Widget list() {
    return Expanded(
      child: FutureBuilder(
        future: Studentss,
        // ignore: missing_return
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return dataTable(snapshot.data);
          }
          if (snapshot.data == null || snapshot.data.length == 0) {
            return Text("Not data founded");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldkey,
      drawer: menu(),
      appBar: new AppBar(
        title: Text("Crud SQLite"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),

      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            list(),
            Row(

              children: <Widget>[
                Center(
                    child: Container(
                        padding: EdgeInsets.all(15.0),
                        width: MediaQuery.of(context).size.width,
                        child: MaterialButton(
                          color: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          onPressed: refreshList,
                          child: Text(
                            'UPDATE',
                            style: TextStyle(fontSize: 25.0),
                          ),
                        )))
              ],
            ),

            //NavDrawer(),
          ],
        ),
      ),
    );
  }
}
