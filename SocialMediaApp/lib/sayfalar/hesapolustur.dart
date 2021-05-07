import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/modeller/kullanici.dart';
import 'package:socialapp/sayfalar/renk.dart';
import 'package:socialapp/servisler/firestoreservisi.dart';
import 'package:socialapp/servisler/yetkilendirmeservisi.dart';

class HesapOlustur extends StatefulWidget {
  @override
  _HesapOlusturState createState() => _HesapOlusturState();
}

class _HesapOlusturState extends State<HesapOlustur> {
  bool yukleniyor = false;
  final _formAnahtari = GlobalKey<FormState>();
  final _scaffoldAnahtari = GlobalKey<ScaffoldState>();
  String kullaniciAdi, email, sifre;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: KprimaryColor,
      key: _scaffoldAnahtari,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Hesap Oluştur"),
        backgroundColor: KprimaryColor,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          width: size.width * 0.97,
          height: size.height * 0.88,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(35),
          ),
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
                            hintText: "Kullanıcı Adı",
                            errorStyle: TextStyle(fontSize: 16.0),
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.black,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          validator: (girilenDeger) {
                            if (girilenDeger.isEmpty) {
                              return "Kullanıcı adı boş bırakılamaz!";
                            } else if (girilenDeger.trim().length < 4 ||
                                girilenDeger.trim().length > 20) {
                              return "En az 4 en fazla 20 karakter olabilir!";
                            }
                            return null;
                          },
                          onSaved: (girilenDeger) =>
                              kullaniciAdi = girilenDeger,
                        ),
                        SizedBox(
                          height: 25.0,
                        ),
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
                              hintText: "Email Adresi",
                              errorStyle: TextStyle(fontSize: 16.0),
                              prefixIcon: Icon(
                                Icons.mail,
                                color: Colors.black,
                              ),
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
                        TextFormField(
                          obscureText: true,
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
                              hintText: "Şifre",
                              errorStyle: TextStyle(fontSize: 16.0),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.black,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                              )),
                          validator: (girilenDeger) {
                            if (girilenDeger.isEmpty) {
                              return "Şifre alanı boş bırakılamaz!";
                            } else if (girilenDeger.trim().length < 4) {
                              return "Şifre 4 karakterden az olamaz!";
                            }
                            return null;
                          },
                          onSaved: (girilenDeger) => sifre = girilenDeger,
                        ),
                        SizedBox(
                          height: 50.0,
                        ),
                        Container(
                          width: size.width * 0.5,
                          child: ElevatedButton(
                            onPressed: _kullaniciOlustur,
                            style: ElevatedButton.styleFrom(
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(50),
                              ),
                              primary: KprimaryColor,
                              shadowColor: KprimaryColor,
                              elevation: 15,
                            ),
                            child: Text(
                              "Hesap Oluştur",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            //style: ElevatedButton.styleFrom(primary:Theme.of(context).primaryColor,)
                            //color: Theme.of(context).primaryColor,
                            //textColor: Colors.white,
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

  void _kullaniciOlustur() async {
    final _yetkilendirmeServisi =
        Provider.of<YetkilendirmeServisi>(context, listen: false);

    var _formState = _formAnahtari.currentState;

    if (_formState.validate()) {
      _formState.save();
      setState(() {
        yukleniyor = true;
      });

      try {
        Kullanici kullanici =
            await _yetkilendirmeServisi.mailIleKayit(email, sifre);
        if (kullanici != null) {
          FireStoreServisi().kullaniciOlustur(
              id: kullanici.id, email: email, kullaniciAdi: kullaniciAdi);
        }
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

    if (hataKodu == "invalid-email") {
      hataMesaji = "Girdiğiniz mail adresi geçersizdir";
    } else if (hataKodu == "email-already-in-use") {
      hataMesaji = "Girdiğiniz mail kayıtlıdır";
    } else if (hataKodu == "weak-password") {
      hataMesaji = "Daha zor bir şifre tercih edin";
    }

    final snackBar = SnackBar(content: Text(hataMesaji));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
