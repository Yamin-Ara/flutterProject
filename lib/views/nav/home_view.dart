import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/routes.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/services/cloud/cloud_notes.dart';
import 'package:flutter_application_1/services/cloud/cloud_store.dart';
import 'package:flutter_application_1/views/nav/notes_list_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final FirebaseCloudStorage _userInfoService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _userInfoService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamed(createUpdateUserInfoRoute);
          },
          child: const Icon(Icons.add),
        ),
        StreamBuilder(
          stream: _userInfoService.allNotes(ownerUserId: userId),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final allNotes = snapshot.data as Iterable<CloudNote>;
                  return NotesListView(
                    notes: allNotes,
                    onDeleteNote: (note) async {
                      await _userInfoService.deleteNote(
                          documentId: note.documentId);
                    },
                    onTap: (note) {
                      Navigator.of(context).pushNamed(
                        createUpdateUserInfoRoute,
                        arguments: note,
                      );
                    },
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              default:
                return const CircularProgressIndicator();
            }
          },
        ),
      ],
    );
  }
}
