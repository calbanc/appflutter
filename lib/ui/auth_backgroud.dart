import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

   AuthBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          _PurpleBox(),
          _HeaderIcon(),
          this.child
        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 40),
        child: Image(image: AssetImage('assets/segser.png'),height: 180,width: 100,) ,
      ),
    );
  }
}

class _PurpleBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * 0.4,
      decoration: _BuildBoxDecoration(),
      
      /* child: Stack(
        children: [
          Positioned(child: _Buble(), left: 30, top: 90),
          Positioned(child: _Buble(), left: -30, top: -40),
          Positioned(child: _Buble(), right: -20, top: -50),
          Positioned(child: _Buble(), left: 10, bottom: -50),
          Positioned(child: _Buble(), right: 30, bottom: 120),
        ],
      ), */
    );
  }

  BoxDecoration _BuildBoxDecoration() => const BoxDecoration(
          gradient: LinearGradient(colors: [
        Color.fromRGBO(250, 250, 250, 1),
        Color.fromRGBO(250, 250, 250, 1)
      ]));
}

class _Buble extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: _BuildBubleBoxDecoration(),
    );
  }

  BoxDecoration _BuildBubleBoxDecoration() => BoxDecoration(
      borderRadius: BorderRadius.circular(100),
      color: Color.fromRGBO(255, 255, 255, 0.05));
}
