import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _controller = TextEditingController();
  TextEditingController _updatecontroller = TextEditingController();

  Box? notepad;
  @override
  void initState() {
    notepad = Hive.box("notepad");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'আমার নোটপ্যাড',
          style: TextStyle(fontSize: 22, fontFamily: "banglaFont"),
        ),
        backgroundColor: Colors.redAccent,
        elevation: 0,
        toolbarHeight: 70,
        centerTitle: true,
        leading: Container(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                  hintText: "লেখুন.........",
                  border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () async {
                    final mydata = _controller.text;
                    _controller.clear();
                    await notepad!.add(mydata);
                  },
                  child: const Text("জমা করুন")),
            ),
            const SizedBox(height: 15),
            Expanded(
                child: ValueListenableBuilder(
                    valueListenable: Hive.box("notepad").listenable(),
                    builder: (context, box, widget) {
                      return ListView.builder(
                          itemCount: notepad?.keys.toList().length,
                          itemBuilder: (_, index) {
                            return Card(
                              elevation: 8,
                              child: ListTile(
                                title: Text(notepad!.getAt(index).toString()),
                                trailing: SizedBox(
                                  width: 100,
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (_) {
                                                return Dialog(
                                                  child: Container(
                                                    padding: EdgeInsets.all(15),
                                                    height: 150,
                                                    child: Column(
                                                      children: [
                                                        TextField(
                                                          decoration: InputDecoration(
                                                              border: OutlineInputBorder(
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                      10),
                                                                  borderSide:
                                                                  const BorderSide(
                                                                      color:
                                                                      Colors.black)),
                                                              hintText: 'পূনরায় সংশোধন করুন..'

                                                          ),
                                                          controller: _updatecontroller,
                                                        ),
                                                        OutlinedButton(onPressed: ()async{
                                                          final updatedata=_updatecontroller.text;
                                                          notepad!.putAt(index, updatedata).toString();
                                                          _updatecontroller.clear();
                                                          Navigator.pop(context);
                                                        }, child: Text('জমা করুন'))
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });
                                        },
                                        icon: Icon(Icons.edit),
                                        color: Colors.green,
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          await notepad!.deleteAt(index);
                                        },
                                        icon: Icon(Icons.delete),
                                        color: Colors.red,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    }))
          ],
        ),
      ),
    );
  }
}
