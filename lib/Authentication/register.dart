import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Store/storehome.dart';
import 'package:e_shop/Config/config.dart';



class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}



class _RegisterState extends State<Register>{
    final TextEditingController _nameTextEdditingController = TextEditingController();
final TextEditingController _emailTextEdditingController = TextEditingController();
final TextEditingController _passwordTextEdditingController = TextEditingController();
final TextEditingController _cpasswordTextEdditingController = TextEditingController();
final GlobalKey<FormState> _formKey= GlobalKey<FormState>();
String userImageUrl="";
File _imageFile;

  @override
  Widget build(BuildContext context) {
    double _screenwidth =MediaQuery.of(context).size.width,_screenHeigth =MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 10.0,),
            InkWell(
              onTap: _selectandpickImage,
              child: CircleAvatar(
                radius: _screenwidth *0.15,
                backgroundColor: Colors.white,
                backgroundImage: _imageFile==null?null:FileImage(_imageFile),
                child: _imageFile==null
                    ?Icon(Icons.add_photo_alternate,size: _screenwidth *0.15,color: Colors.grey,):null,
              ),
            ),
            SizedBox(height: 8.0,),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _nameTextEdditingController,
                    data: Icons.person,
                    hintText: "Name",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _emailTextEdditingController,
                    data: Icons.email,
                    hintText: "Email",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _passwordTextEdditingController,
                    data: Icons.person,
                    hintText: "password",
                    isObsecure: true,
                  ),
                  CustomTextField(
                    controller: _cpasswordTextEdditingController,
                    data: Icons.person,
                    hintText: "COnfirm Password",
                    isObsecure: true,
                  ),

                ],
              ),
            ),
            RaisedButton(onPressed: (){uploadAndSaveImage();},
            color: Colors.pink,
            child: Text("Sign UP",style: TextStyle(color: Colors.white),),),
            SizedBox(
              height: 30.0,
            ),
            Container(
              height: 4.0,
              width: _screenwidth*0.8,
              color: Colors.pink,
            ),
            SizedBox(
              height: 15.0,
            )
          ],

        ),
      ),
    );
  }
  Future<void> _selectandpickImage()async{
    _imageFile=await ImagePicker.pickImage(source: ImageSource.gallery);
  }
    Future<void> uploadAndSaveImage()async{
    if(_imageFile==null){
      showDialog(context: context,
      builder: (c){
        return ErrorAlertDialog(message: "Please selected Image",);
      });
    }
    else{

      _passwordTextEdditingController.text==_cpasswordTextEdditingController.text
          ? _emailTextEdditingController.text.isNotEmpty&& _passwordTextEdditingController.text.isNotEmpty&&_cpasswordTextEdditingController.text.isNotEmpty&&_nameTextEdditingController.text.isNotEmpty
          ?uploadToStorage()
          : displayDialog("Please fill up the complete form ")
          :displayDialog("Password do not match");
    }
    }
    displayDialog(String msg){
    showDialog(context: context,builder: (c){
      return ErrorAlertDialog( message: msg,);
    });
    }
    uploadToStorage()async{
    showDialog(context: context,builder: (c){
      return LoadingAlertDialog();
    });
    String imageFileName=DateTime.now().microsecondsSinceEpoch.toString();
    StorageReference storageReference=FirebaseStorage.instance.ref().child(imageFileName);
    StorageUploadTask storageUploadTask=storageReference.putFile(_imageFile);
    StorageTaskSnapshot taskSnapshot=await storageUploadTask.onComplete;
    await taskSnapshot.ref.getDownloadURL().then((urlImage){
      userImageUrl=urlImage;
      _registerUser();

    });
    }
    FirebaseAuth _auth=FirebaseAuth.instance;
    void _registerUser()async{
      FirebaseUser firebaseUser;
      await _auth.createUserWithEmailAndPassword(email: _emailTextEdditingController.text.trim(), password: _passwordTextEdditingController.text.trim()).then((auth){
        firebaseUser=auth.user;
      }).catchError((error){
        Navigator.pop(context);
        showDialog(context: context,builder: (c){
          return ErrorAlertDialog(message: error.message.toString(),);
        });
      });
      if(firebaseUser!=null){
        saveUserInfoToFireStore(firebaseUser).then((value){
          Navigator.pop(context);
          Route route =MaterialPageRoute(builder: (c)=>StoreHome());
          Navigator.pushReplacement(context, route);
        });
      }

    }
    Future saveUserInfoToFireStore( FirebaseUser fUser)async{
      Firestore.instance.collection("users").document(fUser.uid).setData({
        "uid":fUser.uid,
        "email":fUser.email,
        "name":_nameTextEdditingController.text.trim(),
        "url":userImageUrl,
        EcommerceApp.userCartList:["garbageValue"]
      });

      await EcommerceApp.sharedPreferences.setString("uid", fUser.uid);
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userEmail, fUser.email);
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userName, _nameTextEdditingController.text.trim());
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl, userImageUrl);
      await EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, ["garbageValue"]);

    }
}

