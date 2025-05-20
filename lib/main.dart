import 'package:flutter/material.dart';
import 'package:projeto_quirino/text_input.dart';
import 'package:projeto_quirino/dao.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Comentar caso esteja usando o emulador Android/iOS

void main() {
  // Inicialização obrigatória do banco de dados para apps desktop (Windows/macOS/Linux).
  // Não é necessária em Android/iOS.
  // Inicializa o banco com sqflite_common_ffi
  // Comentar caso esteja usando o emulador Android/iOS
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ListaTodo(),
    );
  }
}

class ListaTodo extends StatefulWidget {
  const ListaTodo({super.key});

  @override
  State<StatefulWidget> createState() => _ListaTodo();
}

class _ListaTodo extends State<ListaTodo> {
  List<Map<String, dynamic>> _listaTarefas = [];

  void _atualizarLista() async {
    final dados = await DataAccessObject.getTarefas();
    setState(() {
      _listaTarefas = dados;
    });
  }

  @override
  void initState() {
    super.initState();
    _atualizarLista();
  }

  // Métodos CRUD
  Future<void> _excluirTarefa(int id) async {
    await DataAccessObject.deleteTarefa(id);
    _atualizarLista();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return Container(
                height: 500,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.only(top: 50, left: 30, right: 30),
                child: const AdicionarItem(),
              );
            },
          );
        },
        backgroundColor: Colors.blue,
        elevation: 12,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        title: const Text("To Do"),
        backgroundColor: Colors.blue,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      body: ListView.builder(
        itemCount: _listaTarefas.length,
        itemBuilder:
            (context, index) => ListTile(
              leading: Icon(
                Icons.task
              ),
              title: Text(_listaTarefas[index]["titulo"]),
              subtitle: Text("${_listaTarefas[index]["descricao"]}"),
              trailing: IconButton(
                onPressed: () {
                  _excluirTarefa(_listaTarefas[index]["id"]);
                },
                icon: Icon(Icons.delete),
              ),
              onTap: () {},
            ),
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
  DateTime? dataSelecionada; // Variável para armazenar a data selecionada

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextInput(
          updateFunction: (s) {
            setState(() {
              titulo = s;
            });
          },
          textLabel: "Titulo",
        ),
        TextInput(
          updateFunction: (s) {
            setState(() {
              descricao = s;
            });
          },
          textLabel: "Descrição",
        ),
        Container(
          padding: const EdgeInsets.only(top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dataSelecionada == null
                    ? "Nenhuma data selecionada"
                    : "Data: ${dataSelecionada!.day}/${dataSelecionada!.month}/${dataSelecionada!.year}",
                style: const TextStyle(fontSize: 16),
              ),
              TextButton(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      dataSelecionada = pickedDate;
                    });
                  }
                },
                child: const Text("Selecionar Data"),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 50),
          child: TextButton(
            onPressed: () {
              if (titulo.isEmpty || descricao.isEmpty || dataSelecionada == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Por favor, preencha todos os campos e selecione uma data."),
                  ),
                );
                return;
              }

              // print("Título: $titulo");
              // print("Descrição: $descricao");
              // print("Data: ${dataSelecionada!.day}/${dataSelecionada!.month}/${dataSelecionada!.year}");
              
              // Alguns valores estão fixos.
              // TODO: substituir valores fixos pelas variáveis
              DataAccessObject.createTarefa(
                'P',
                dataSelecionada!,
                dataSelecionada!,
                "F",
                descricao,
                titulo
              );

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Tarefa criada com sucesso!"),
                ),
              );

              Navigator.pop(context);
            },
            style: ButtonStyle(alignment: Alignment.center),
            child: const Text("Adicionar"),
          ),
        ),
      ],
    );
  }
}