
import 'package:flutter/material.dart';
import '../Widgets/myDrawer.dart';
import '../Models/item.dart';

double width;

class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  String ja;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors:[Colors.pink,Colors.lightGreenAccent],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops:[0.0,1.0],
                tileMode:TileMode.clamp,
              ),
            ),
          ),
          title: Text("E-shop",
            style: TextStyle(fontSize: 55.0,color: Colors.white,fontFamily: "ignatra"),),
          centerTitle: true,
          actions: [
            Stack(

              children: [
                IconButton(icon: Icon(Icons.shopping_cart,color: Colors.pink,),
                    onPressed: (){
                    }),
                Positioned(
                  child: Stack(
                    children: [
                      Icon(Icons.brightness_1,size: 20.0,
                      color: Colors.green,),
                      Positioned(top:3.0,
                      bottom: 4.0,),

                    ],
                  ),
                )
              ],
            )
          ],

        ),
        drawer: MyDrawer(),
        body: Center(

        ),
      ),
    );
  }
}



Widget sourceInfo(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  return InkWell();
}



Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
  return Container();
}



void checkItemInCart(String productID, BuildContext context)
{
}
