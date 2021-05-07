import 'package:flutter/material.dart';
import 'package:socialapp/modeller/kullanici.dart';
import 'package:socialapp/sayfalar/profil.dart';
import 'package:socialapp/sayfalar/renk.dart';
import 'package:socialapp/servisler/firestoreservisi.dart';

class Ara extends StatefulWidget {
  @override
  _AraState createState() => _AraState();
}

class _AraState extends State<Ara> {
  TextEditingController _aramaController = TextEditingController();
  Future<List<Kullanici>> _aramaSonucu;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: KprimaryColor,
      appBar: _appBarOlustur(),
      body: Center(
        child: Container(
          width: size.width*0.98,
          height: size.height*0.9,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(35),
          ),
          child: _aramaSonucu != null ? sonuclariGetir() : aramaYok(),
        ),
      ),
      
    );
  }

  AppBar _appBarOlustur(){
    return AppBar(
      
      elevation: 0,
      titleSpacing: 0.0,
      backgroundColor: KprimaryColor,
      title: Padding(
        padding: const EdgeInsets.only(right: 7.5,left: 7.5),
        child: TextFormField(
          onFieldSubmitted: (girilenDeger){
            setState(() {
              _aramaSonucu = FireStoreServisi().kullaniciAra(girilenDeger);
            });
          },
          controller: _aramaController,
          decoration: InputDecoration(
            
            prefixIcon: Icon(Icons.search, size: 30.0,),
            suffixIcon: IconButton(icon: Icon(Icons.clear), onPressed: (){
              _aramaController.clear();
              setState(() {
                _aramaSonucu = null;
              });
              }),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(35),),
            fillColor: Colors.white,
            filled: true,
            hintText: "Kullanıcı Ara...",
            contentPadding: EdgeInsets.only(top: 16.0)
          ),
        ),
      ),
    );
  }

  aramaYok(){
    return Center(child: Text("Kullanıcı Ara"));
  }

  sonuclariGetir(){
    return FutureBuilder<List<Kullanici>>(
      future: _aramaSonucu ,
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator());
        }

        if(snapshot.data.length == 0){
          return Center(child: Text("Bu arama için sonuç bulunamadı!"));
        }

        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, index){
            Kullanici kullanici = snapshot.data[index];
            return kullaniciSatiri(kullanici);
          }
          );
      }
      );
  }

  kullaniciSatiri(Kullanici kullanici){
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Profil(profilSahibiId: kullanici.id,)));
      },
          child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(kullanici.fotoUrl),
        ),
        title: Text(kullanici.kullaniciAdi, style: TextStyle(fontWeight: FontWeight.bold),),
      ),
    );
  }
}