import 'package:flutter/material.dart';
import 'package:projeto_quirino/entidades/itemTodo.dart';
import 'package:projeto_quirino/textInput.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: ListaTodo());
  }
}

class ListaTodo extends StatefulWidget {
  const ListaTodo({super.key});

  @override
  State<ListaTodo> createState() => _ListaTodoState();
}

class _ListaTodoState extends State<ListaTodo> {
  List<Itemtodo> itens = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (b) {
                return Container(
                  height: 500,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(12)),
                  padding: EdgeInsets.only(top: 50, left: 30, right: 30),
                  child: AdicionarItem(),
                );
              });
        },
        backgroundColor: Colors.blue,
        elevation: 12,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        title: Text("Projeto Quirino todo"),
        backgroundColor: Colors.blue,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}

class AdicionarItem extends StatefulWidget {
  const AdicionarItem({super.key});

  @override
  State<StatefulWidget> createState() => _AdicionarItem();
}

class _AdicionarItem extends State<AdicionarItem> {
  String titulo = "";
  String descricao = "";

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      textInput(
          updateFunction: (s) {
            setState(() {
              titulo = s;
            });
          },
          textLabel: "Titulo"),
      textInput(
          updateFunction: (s) {
            setState(() {
              descricao = s;
            });
          },
          textLabel: "Descrição"),
      Container(
          padding: EdgeInsets.only(top: 50),
          child: TextButton(
            onPressed: () {},
            style: ButtonStyle(alignment: Alignment.center),
            child: Text("Adicionar"),
          ))
    ]);
  }
}

