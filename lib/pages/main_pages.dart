import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:notesqflite/helpers/notehelper.dart';
import 'package:notesqflite/models/notemodel.dart';
import 'package:notesqflite/pages/insert_pages.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Notehelper _noterepo = Notehelper();

  bool _isLoading = true;

  late Future<List<NoteModel>> _noteModelList;

  void _initWork() async {
    _noterepo.openDB().then((value) {
      setState(() {
        _isLoading = false;
      });
      _noteModelList = _noterepo.selectAll();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initWork();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar,
      body: _buildBody,
    );
  }

  AppBar get _buildAppBar {
    return AppBar(
      title: const Text('Note Sqflite'),
      backgroundColor: Colors.deepPurple[200],
      actions: [
        IconButton(
            onPressed: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InsertPages(),
                  ));
            },
            icon: const Icon(Icons.add))
      ],
    );
  }

  Widget get _buildBody {
    return Container(
      alignment: Alignment.center,
      color: Colors.deepPurple[100],
      child: _isLoading ? CircularProgressIndicator() : _buildFuture(),
    );
  }

  Widget _buildFuture() {
    return FutureBuilder<List<NoteModel>>(
      future: _noteModelList,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("Error: ${snapshot.error}");
          return Text("Error: ${snapshot.error}");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return _buildListView(snapshot.data ?? []);
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget _buildListView(List<NoteModel> items) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _noteModelList = _noterepo.selectAll();
        });
      },
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return _buildItem(items[index]);
        },
      ),
    );
  }

  Widget _buildItem(NoteModel item) {
    return Card(
      child: ListTile(
        title: Text('${item.headtitle}'),
        subtitle: Text('${item.bodytitle}'),
        trailing: IconButton(
          onPressed: () async {
            await _noterepo.delete(item.id);
            setState(() {
              _noteModelList = _noterepo.selectAll();
            });
          },
          icon: Icon(Icons.delete_forever),
        ),
      ),
    );
  }
}
