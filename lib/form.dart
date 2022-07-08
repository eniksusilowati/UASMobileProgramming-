    // ignore_for_file: unnecessary_new, unused_field, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, unused_import, use_key_in_widget_constructors, avoid_print, unused_element, unnecessary_import

        import 'package:cloud_firestore/cloud_firestore.dart';
        import 'package:flutter/material.dart';
        import 'package:flutter/rendering.dart';
        import 'package:firebase_core/firebase_core.dart';
        import 'main.dart';
        
        class FormPage extends StatefulWidget {
          //konstruktor memiliki satu parameter, parameter opsional
          // jika memiliki id kami akan menampilkan data dan menjalankan metode pembaruan
          // jika tidak jalankan tambahkan data
          const FormPage({this.id});
        
          final String? id;
        
          @override
          State<FormPage> createState() => _FormPageState();
        }
        
        class _FormPageState extends State<FormPage> {
          //set kunci formulir
          final _formKey = GlobalKey<FormState>();
        
          //set variabel texteditingcontroller
          var nameController = TextEditingController();
          var phoneNumberController = TextEditingController();
          var emailController = TextEditingController();
          var addressController = TextEditingController();
        
         //inisialisasi instance firebase
          FirebaseFirestore firebase = FirebaseFirestore.instance;
          CollectionReference? users;
        
          void getData() async {
            //dapatkan koleksi pengguna dari firebase
            //koleksi adalah tabel di mysql
            users = firebase.collection('users');
        
            //jika punya id
            if (widget.id != null) {
              //mendapatkan data pengguna berdasarkan dokumen id
              var data = await users!.doc(widget.id).get();
        
              //kita mendapatkan data.data()
              //agar bisa diakses, kita jadikan sebagai peta
              var item = data.data() as Map<String, dynamic>;
        
              //set state untuk mengisi data controller dari data firebase
              setState(() {
                nameController = TextEditingController(text: item['name']);
                phoneNumberController =
                    TextEditingController(text: item['phoneNumber']);
                emailController = TextEditingController(text: item['email']);
                addressController = TextEditingController(text: item['address']);
              });
            }
          }
        
          @override
          void initState() {
           
            // ignore: todo
            // TODO: implementasikan initState
            getData();
            super.initState();
          }
        
          @override
          Widget build(BuildContext context) {
            return Scaffold(
                appBar: AppBar(
                  title: Text("CONTACT FORM"),
                  actions: [
                    
                    //jika ada data tampilkan tombol hapus
                    widget.id != null
                        ? IconButton(
                            onPressed: () {

                              //cara menghapus data berdasarkan id
                              users!.doc(widget.id).delete();
        
                              //kembali ke halaman utama
                              // '/' adalah rumah
                              Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                            },
                            icon: Icon(Icons.delete))
                        : SizedBox()
                  ],
                ),
              
               //formulir ini untuk menambah dan mengedit data
              //jika id sudah lewat dari main, field akan menampilkan data
                body: Form(
                  key: _formKey,
                  child: ListView(padding: EdgeInsets.all(16.0), children: [
                    SizedBox(height: 10,),
                    CircleAvatar(
                      radius: 30,
                      child: Icon(Icons.person, size: 30,),
                    ),
                    Text(
                      'Name',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                          hintText: "Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          fillColor: Colors.white,
                          filled: true),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Name is Required!';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Phone Number',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: phoneNumberController,
                      decoration: InputDecoration(
                          hintText: "Phone Number",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          fillColor: Colors.white,
                          filled: true),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Phone Number is Required!';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                          hintText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          fillColor: Colors.white,
                          filled: true),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Email is Required!';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Address',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: addressController,
                      keyboardType: TextInputType.multiline,
                      minLines: 5,
                      maxLines: null,
                      decoration: InputDecoration(
                          hintText: "Address",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          fillColor: Colors.white,
                          filled: true),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Address is Required!';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20,),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          "Submit",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          
                          //jika id bukan null run tambahkan data untuk menyimpan data ke firebase
                          //lain perbarui data berdasarkan id
                          if (widget.id == null) {
                            users!.add({
                              'name': nameController.text,
                              'phoneNumber': phoneNumberController.text,
                              'email': emailController.text,
                              'address': addressController.text
                            });
                          } else {
                            users!.doc(widget.id).update({
                              'name': nameController.text,
                              'phoneNumber': phoneNumberController.text,
                              'email': emailController.text,
                              'address': addressController.text
                            });
                          }

                          //pemberitahuan snack bar
                          final snackBar = SnackBar(content: Text('Data saved successfully!'));    
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          
                          //kembali ke halaman utama
                          //halaman depan => '/'
                          Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                        }
                         
                      },
                    )
                  ]),
                ));
          }
        }