import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'convertir.dart';

import 'students.dart';
import 'crud_operations.dart';

class Insertar extends StatefulWidget {
  @override
  _Insertar createState() => new _Insertar();
}

class _Insertar extends State<Insertar> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

//Variables referentes al manejo de la bd
  Future<List<Student>> Studentss;
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerPaterno = TextEditingController();
  TextEditingController controllerMaterno = TextEditingController();
  TextEditingController controllerPhone = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerMatricula = TextEditingController();
  TextEditingController controllerPhoto = TextEditingController();
  String name;
  String paterno;
  String materno;
  String email;
  String phone;
  String image;
  String matricula = null;
  String photo;
  int count;
  int currentUserId;
  var bdHelper;
  bool isUpdating;

  @override
  void initState() {
    super.initState();
    bdHelper = DBHelper();
    isUpdating = false;
    refreshList();
  }

  void refreshList() {
    setState(() {
      Studentss = bdHelper.getStudents(matricula);
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

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        backgroundColor: Colors.redAccent,
        content: new Text(
          value,
          style: TextStyle(fontSize: 20.0, color: Colors.white),
        )));
  }

  void verificar() async {
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      if (isUpdating) {
        Student stu = Student(currentUserId, name, paterno, materno, phone,
            email, matricula, image);
        bdHelper.update(stu);
        setState(() {
          isUpdating = false;
        });
      } else {
        Student stu = Student(
            null, name, paterno, materno, phone, email, matricula, image);
        var col = await bdHelper.getMatricula(matricula);
        print(col);
        if (col == 0) {
          bdHelper.insert(stu);
          showInSnackBar("Data saved");
        } else {
          showInSnackBar("Error! Ya existe esta matricula");
        }
      }
      cleanData();
      refreshList();
    }
  }

  ImageGallery(BuildContext context) {
    ImagePicker.pickImage(source: ImageSource.gallery).then((imgFile) {
      String imgString = Convertir.base64String(imgFile.readAsBytesSync());
      image = imgString;
      Navigator.of(context).pop();
      controllerPhoto.text = "Imagen lista";
      return image;
    });
  }

  ImageCamera(BuildContext context) {
    ImagePicker.pickImage(source: ImageSource.camera).then((imgFile) {
      String imgString = Convertir.base64String(imgFile.readAsBytesSync());
      image = imgString;
      Navigator.of(context).pop();
      controllerPhoto.text = "Imagen lista";
      return image;
    });
  }

  //Select the image
  Future<void> _selectphoto(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(
                "Elige una imagen",
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.red[400],
              content: SingleChildScrollView(
                child: ListBody(children: <Widget>[
                  GestureDetector(
                    child: Text("Galeria"),
                    onTap: () {
                      ImageGallery(context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                  ),
                  GestureDetector(
                    child: Text(
                      "Camara",
                    ),
                    onTap: () {
                      ImageCamera(context);
                    },
                  )
                ]),
              ));
        });
  }

  final formkey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text(
          "Insertar",
        ),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              key: formkey,
              child: Padding(
                padding: EdgeInsets.only(
                    top: 35.0, right: 15.0, bottom: 35.0, left: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  verticalDirection: VerticalDirection.down,
                  children: <Widget>[
                    TextFormField(
                      readOnly: true,
                      controller: controllerPhoto,
                      decoration: InputDecoration(
                          labelText: "Fotografia",
                          suffixIcon: RaisedButton(
                            color: Colors.redAccent,
                            onPressed: () {
                              _selectphoto(context);
                            },
                            child: Text(
                              "Select image",
                              textAlign: TextAlign.center,
                            ),
                          )),
                      validator: (val) => val.length == 0
                          ? 'Debes subir una imagen'
                          : controllerPhoto.text == "Imagen lista"
                              ? null
                              : "Solo imagenes",
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    TextFormField(
                      controller: controllerName,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: 'Nombre',
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          icon: Icon(
                            Icons.person_outline,
                            size: 35.0,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                      validator: (val) => val.length == 0 ? 'Ingresa el nombre' : null,
                      onSaved: (val) => name = val.toUpperCase(),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: controllerPaterno,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: 'Apellido paterno',
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          icon: Icon(
                            Icons.person_outline,
                            size: 35.0,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                      validator: (val) =>
                          val.length == 0 ? 'Ingrese apellido' : null,
                      onSaved: (val) => paterno = val.toUpperCase(),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: controllerMaterno,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: 'Apellido materno',
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          icon: Icon(
                            Icons.person_outline,
                            size: 35.0,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                      validator: (val) =>
                          val.length == 0 ? 'Ingrese apellido' : null,
                      onSaved: (val) => materno = val.toUpperCase(),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: controllerEmail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: 'Email',
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          icon: Icon(
                            Icons.email,
                            size: 35.0,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                      validator: (val) =>
                          !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                  .hasMatch(val)
                              ? 'Introduce el email'
                              : null,
                      onSaved: (val) => email = val.toUpperCase(),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: controllerPhone,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          labelText: 'Telefono',
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          icon: Icon(
                            Icons.phone,
                            size: 35.0,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                      maxLength: 10,
                      validator: (val) =>
                          val.length < 10 ? 'Numero de telefono' : null,
                      onSaved: (val) => phone = val,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: controllerMatricula,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Matricula',
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          icon: Icon(
                            Icons.perm_identity,
                            size: 35.0,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                      maxLength: 10,
                      validator: (val) =>
                          (val.length < 10) ? 'Ingresa la matricula' : null,
                      onSaved: (val) => matricula = val,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        MaterialButton(
                          color: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              ),
                          onPressed: () async {
                            verificar();
                          },
                          child: Text(
                            isUpdating ? 'Actualizando' : 'Insertar',
                            style: TextStyle(fontSize: 17.0),
                          ),
                        ),
                        MaterialButton(
                          color: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),),
                          onPressed: () {
                            setState(() {
                              isUpdating = false;
                            });
                            cleanData();
                          },
                          child:
                              Text('Cancelar', style: TextStyle(fontSize: 17.0)),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
