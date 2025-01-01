import 'package:duygucarki/Views/UpdateDescription.dart';
import 'package:duygucarki/Views/UpdateLink.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text("Admin Paneli"),
      ),
      body: ListView(
        children: [
          Card(
            elevation: 4,  // Yükseklik ve gölge eklemek için elevation
            child: ListTile(
              
              title:Row(
                children: [
                  Icon(Icons.settings),
                  Container(
                      margin:EdgeInsets.only(left: 10)),
                      Text('Linki Düzenle')
                ],
              ),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Updatelink())),
            ),
          ),
          Card(
            elevation: 4,  // Yükseklik ve gölge eklemek için elevation
            child: ListTile(
              title: Row(
                children: [
                  Icon(Icons.settings),
                  Container(
                      margin:EdgeInsets.only(left: 10)),
                  Text('Açıklamayı Düzenle')
                ],
              ),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Updatedescription())),
            ),
          ),
        ],
      ),
    );
  }
}
