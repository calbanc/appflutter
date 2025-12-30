||||import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rondines/provider/asistencia_provider.dart';

class MainAsistencia extends StatelessWidget {
  const MainAsistencia({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_)=>AsistenciaProvider(),
      child: _mainasistencia(),
    );
  }
}

class _mainasistencia extends StatefulWidget {
  const _mainasistencia({super.key});

  @override
  State<_mainasistencia> createState() => _mainasistenciaState();
}

class _mainasistenciaState extends State<_mainasistencia> {
  var pages =  [ FirstPage(),SecondPage(), ThirdPage(),FourthPage(),];

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registra tu asistencia'),),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 30),
            child: LinearProgressIndicator(
              color: Colors.blue.shade700,
              value: (currentIndex+1) /4,
              borderRadius: BorderRadius.circular(10),
              minHeight: 20,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: PageView(
                children: pages,
                onPageChanged: (i){
                  setState(() {
                    currentIndex = i;
                  });
                },
                padEnds: true,
              ),
            ),
          ),
        ],
      ),
    );


  }
}

class FirstPage extends StatelessWidget {

  static var controller = TextEditingController();
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Scannea tu tarjeta nfc'),
        ),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
              label: Text('Name'),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(width: 1,color: Colors.blue)
              )
          ),
        ),
      ],
    );
  }
}
class SecondPage extends StatelessWidget {
  static var controller = TextEditingController();
  const SecondPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Second Page'),
        ),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
              label: Text('phone'),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(width: 1,color: Colors.blue)
              )
          ),
        ),
      ],
    );
  }
}
class ThirdPage extends StatelessWidget {
  static var controller = TextEditingController();
  const ThirdPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Second Page'),
        ),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
              label: Text('phone'),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(width: 1,color: Colors.blue)
              )
          ),
        ),
      ],
    );
  }
}
class FourthPage extends StatelessWidget {
  static var controller = TextEditingController();
  const FourthPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Fourth Page'),
        ),
        TextFormField(
          controller: controller,
          onFieldSubmitted: (s){
            Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context)=> FinalScreen(),
                    settings: RouteSettings(
                      arguments: {
                        'first' : FirstPage.controller.text,
                        'second' : SecondPage.controller.text,
                        'third' : ThirdPage.controller.text,
                        'fourth' : FourthPage.controller.text
                      },
                    )
                )
            );
          },
          decoration: InputDecoration(
              label: Text('Password'),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(width: 1,color: Colors.blue)
              )
          ),
        ),
      ],
    );
  }
}
class FinalScreen extends StatelessWidget {
  const FinalScreen({super.key});

  @override
  Widget build(BuildContext context) {

    var data = ModalRoute.of(context)?.settings.arguments as Map<String,String>;

    return Scaffold(
      appBar: AppBar(
        title: Text('Final Screen'),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('first page data: ${data['first']}'),
            Text('second page data: ${data['second']}'),
            Text('third page data: ${data['third']}'),
            Text('fourth page data: ${data['fourth']}'),
          ],
        ),
      ),
    );
  }
}