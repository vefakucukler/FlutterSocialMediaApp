import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/sayfalar/renk.dart';
import 'package:socialapp/servisler/yetkilendirmeservisi.dart';

class SifremiUnuttum extends StatefulWidget {
  @override
  _SifremiUnuttumState createState() => _SifremiUnuttumState();
}

class _SifremiUnuttumState extends State<SifremiUnuttum> {
  bool yukleniyor = false;
  final _formAnahtari = GlobalKey<FormState>();
  final _scaffoldAnahtari = GlobalKey<ScaffoldState>();
  String email;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: KprimaryColor,
      key: _scaffoldAnahtari,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text("Şifremi Unuttum"),
        backgroundColor: KprimaryColor,
      ),
      body: Center(
          child: Container(
      width: size.width*0.97,
      height: size.height*0.88,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35), color: Colors.white),
      child: ListView(
        children: <Widget>[
          yukleniyor
            ? LinearProgressIndicator()
            : SizedBox(
        height: 0.0,
      ),
          SizedBox(height: 20.0),
          Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
      key: _formAnahtari,
      child: Column(
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(
                    color: KprimaryColor,
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                hintText: "Email adresinizi girin",
                errorStyle: TextStyle(fontSize: 16.0),
                prefixIcon: Icon(Icons.mail,color: Colors.black,),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                )),
                
                
            validator: (girilenDeger) {
              if (girilenDeger.isEmpty) {
                return "Email alanı boş bırakılamaz!";
              } else if (!girilenDeger.contains("@")) {
                return "Girilen değer mail formatında olmalı!";
              }
              return null;
            },
            onSaved: (girilenDeger) => email = girilenDeger,
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            width: size.width*0.4,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: KprimaryColor,
                shadowColor: KprimaryColor,
                elevation:10,
                shape: new RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: _sifreyiSifirla,
              child: Text(
                "Şifremi Sıfırla",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // color: Theme.of(context).primaryColor,
              // textColor: Colors.white,
            ),
          ),
        ],
      )),
          ),
        ],
      ),
            ),
        ),
    );
  }

  void _sifreyiSifirla() async {
    final _yetkilendirmeServisi =
        Provider.of<YetkilendirmeServisi>(context, listen: false);

    var _formState = _formAnahtari.currentState;

    if (_formState.validate()) {
      _formState.save();
      setState(() {
        yukleniyor = true;
      });

      try {
        await _yetkilendirmeServisi.sifremiSifirla(email);
        Navigator.pop(context);
      } catch (hata) {
        setState(() {
          yukleniyor = false;
        });
        uyariGoster(hataKodu: hata.code);
      }
    }
  }

  uyariGoster({hataKodu}) {
    String hataMesaji;

    if (hataKodu == "ERROR_INVALID_EMAIL") {
      hataMesaji = "Girdiğiniz mail adresi geçersizdir";
    } else if (hataKodu == "ERROR_USER_NOT_FOUND") {
      hataMesaji = "Bu mailde bir kullanıcı bulunmuyor";
    }

    final snackBar = SnackBar(content: Text(hataMesaji));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    // var snackBar = SnackBar(content: Text(hataMesaji));
    // _scaffoldAnahtari.currentState.showSnackBar(snackBar);
  }
}
