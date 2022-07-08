// ignore_for_file: prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, avoid_print, unnecessary_cast, prefer_is_empty

    import 'package:cloud_firestore/cloud_firestore.dart';
    import 'package:firebase_core/firebase_core.dart';
    import 'package:flutter/material.dart';
    
    import 'form.dart';
    
    void main() async {
      //lakukan inisialisasi untuk menggunakan firebase
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();

      runApp(
        MaterialApp(
          //hapus spanduk debug
          debugShowCheckedModeBanner: false, 
          title: "Flutter Contact Firebase", 
          home: MyApp()
        )
      );
    }
    
    class MyApp extends StatefulWidget {
      @override
      State<MyApp> createState() => _MyAppState();
    }
    
    class _MyAppState extends State<MyApp> {
      @override
      Widget build(BuildContext context) {
        //Titik masuk untuk mengakses [FirebaseFirestore].
        FirebaseFirestore firebase = FirebaseFirestore.instance;

        //dapatkan koleksi dari firebase, koleksi adalah tabel di mysql
        CollectionReference users = firebase.collection('users');
        return Scaffold(

          appBar: AppBar(
            //buat bilah aplikasi dengan ikon
            title: Center(
              child: Text("CONTACT APP"),
            )
          ),

          body: FutureBuilder<QuerySnapshot>(
          //data yang akan diambil di masa depan
            future: users.get(),
            builder: (_, snapshot) {

                //tampilkan jika ada data
              if (snapshot.hasData) {

             // kami mengambil dokumen dan meneruskannya ke variabel
                var alldata = snapshot.data!.docs;
             
             //jika ada data, buat daftar
                return alldata.length != 0 ? ListView.builder(

                  // ditampilkan sebanyak data variabel semua data
                    itemCount: alldata.length,

                    //membuat item khusus dengan ubin daftar.
                    itemBuilder: (_, index) {
                      return ListTile(
                        leading: CircleAvatar(

                          //mendapatkan karakter pertama dari nama
                          child: Text(alldata[index]['name'][0]),
    
                        ),
                        title: Text(alldata[index]['name'], style: TextStyle(fontSize: 20)),
                        subtitle: Text(alldata[index]['phoneNumber'], style: TextStyle(fontSize: 16)),
                        trailing: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,

                              // berikan data untuk mengedit formulir
                              MaterialPageRoute(builder: (context) => FormPage(id: snapshot.data!.docs[index].id,)),
                            );
                          },
                          icon: Icon(Icons.arrow_forward_rounded)),
                      );
                    }) : Center( child: Text('No Data', style: TextStyle(fontSize: 20),),);
              } else {
                return Center(child: Text("Loading...."));
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FormPage()),
              );
            },
            child: Icon(Icons.add),
          ),
        );
      }
    }