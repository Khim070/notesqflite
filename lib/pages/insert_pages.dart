import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:notesqflite/helpers/notehelper.dart';
import 'package:notesqflite/models/notemodel.dart';

class InsertPages extends StatefulWidget {
  const InsertPages({super.key});

  @override
  State<InsertPages> createState() => _InsertPagesState();
}

class _InsertPagesState extends State<InsertPages> {
  final Notehelper _noterepo = Notehelper();

  bool _isloading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _noterepo.openDB().then((value) {
      setState(() {
        _isloading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar,
      body: _buildBody,
    );
  }

  final TextEditingController _inserthead = TextEditingController();
  final TextEditingController _insertbody = TextEditingController();

  AppBar get _buildAppBar {
    return AppBar(
      title: Text('Insert Notes'),
      actions: [
        TextButton(
            onPressed: () {
              NoteModel noteModel = NoteModel(
                id: DateTime.now().microsecond,
                headtitle: _inserthead.text.trim(),
                bodytitle: _insertbody.text.trim(),
              );

              _noterepo.insert(noteModel).then((value) {
                print("${value.id} inserted");
              });
            },
            child: const Text(
              'Done',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ))
      ],
    );
  }

  Widget get _buildBody {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(20),
      child: _isloading ? CircularProgressIndicator() : _buildPanel(),
    );
  }

  Widget _buildPanel() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            controller: _inserthead,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Note Titles',
            ),
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: TextField(
              controller: _insertbody,
              decoration: const InputDecoration(border: InputBorder.none),
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
          ),
        ],
      ),
    );
  }
}
