import 'dart:io';

import 'package:connection_sqlite/src/database/data.dart';
import 'package:connection_sqlite/src/entities/Dog.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  Data bd = new Data();

  @override
  initState() {
    super.initState();
  }
  void _incrementCounter() {
    setState(() {
      _counter++;
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
            RaisedButton(
              onPressed: (){
                this.bd.openDB();
              },
              child: Text('Crear DB'),
            ),
            RaisedButton(
              onPressed: (){
                Dog dog = new Dog(id: 1, name: 'yan', age: 5);
                this.bd.insertDog(dog);
              },
              child: Text('Insertar dato'),
            ),
            RaisedButton(
              onPressed: ()async{
                Dog dog = new Dog(id: 1, name: 'yan', age: 10);
                await this.bd.updateDog(dog);
                List<Dog> dogs = await this.bd.dogs();
                print(dogs[0].age);
              },
              child: Text('update dato'),
            ),
            RaisedButton(
              onPressed: ()async{
                var image = await ImagePicker.pickImage(source: ImageSource.camera);
                // String dir = path.dirname(image.path);
                // String newPath = path.join(dir, 'image.jpg');
                // print('NewPath: ${newPath}');
                // image.renameSync(newPath);
                // await image.rename(newPath);
                print(image.path);
                await GallerySaver.saveImage(image.path, albumName: 'testAlbum')
                  .then((bool success) {
                    print(success);
                });
              },
              child: Text('Tomar foto y guardar con galley saver'),
            ),
            RaisedButton(
              onPressed: ()async{
                var image = await ImagePicker.pickImage(source: ImageSource.camera);
                Directory pp = new Directory('/storage/emulated/0/test');
                var path = (await getExternalStorageDirectories(type: StorageDirectory.dcim))[0].path+ '/image.png';
                File loaImagen = await image.copy(path);
                print(loaImagen.path);
                // print(Platform.isIOS);
                // print(await pp.exists());
                // List<Directory> appDocDir = await getExternalStorageDirectories(type: StorageDirectory.dcim);
                // getExternalStorageDirectory();
                // appDocDir.forEach((f){
                //   print(f.path);
                // });
                // String path = appDocDir[0].path;
                // var fileName = basename((image.path));
                // print(fileName);
                // final File localImage = await image.copy('/storage/emulated/0/test/image.jpg');
                // print(localImage.path);
              },
              child: Text('Tomar foto y guardar con image.copy(path)'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
