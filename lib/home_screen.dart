import 'package:crud_flutter/db_helper.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _allData = [];
  bool _isLoading = true;

  void _refreshData() async {
    final allData = await SQLHelper.getAllData();
    setState(() {
      _allData = allData;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _addData() async {
    await SQLHelper.createData(titleController.text, descController.text);
    _refreshData();
  }

  Future<void> _updateData(int id) async {
    await SQLHelper.updateData(id, titleController.text, descController.text);
    _refreshData();
  }

  Future<void> _deleteData(int id) async {
    await SQLHelper.deleteData(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Élement supprimé avec sucess !!"),
      backgroundColor: Colors.green,
    ));
    _refreshData();
  }

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  void showBottomSheet(int? id) async {
    if (id != null) {
      final existingData =
          _allData.firstWhere((element) => element['id'] == id);
      titleController.text = existingData['title'];
      descController.text = existingData['desc'];
    }

    showModalBottomSheet(
        elevation: 5,
        isScrollControlled: true,
        context: context,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                top: 30,
                left: 15,
                right: 15,
                bottom: MediaQuery.of(context).viewInsets.bottom + 50,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), hintText: "titre"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: descController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), hintText: "description"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (id == null) {
                          await _addData();
                        } else {
                          await _updateData(id);
                        }
                        titleController.text = "";
                        descController.text = "";
                        Navigator.of(context).pop();
                        print("Données Enregistrées");
                      },
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                        child: Text(
                          id == null ? "Ajouter" : "Enregistrer",
                          style: const TextStyle(
                              fontSize: 18,
                              color: Color.fromRGBO(25, 25, 78, 0.9),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(255, 252, 252, 1),
        appBar: AppBar(
          title: const Text("Opérations CRUD avec flutter"),
          backgroundColor: const Color.fromARGB(242, 19, 243, 213),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color.fromRGBO(250, 65, 127, 1),
                ),
              )
            : ListView.builder(
                itemCount: _allData.length,
                itemBuilder: (context, index) => Card(
                  margin: const EdgeInsets.all(15),
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        _allData[index]['title'],
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    subtitle: Text(_allData[index]['desc']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () =>
                              {showBottomSheet(_allData[index]['id'])},
                          icon: Icon(Icons.edit),
                          color: Color.fromARGB(242, 19, 243, 213),
                        ),
                        IconButton(
                          onPressed: () => {_deleteData(_allData[index]['id'])},
                          icon: Icon(Icons.delete),
                          color: Color.fromARGB(241, 255, 66, 160),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showBottomSheet(null),
          child: Icon(Icons.add),
        ));
  }
}
