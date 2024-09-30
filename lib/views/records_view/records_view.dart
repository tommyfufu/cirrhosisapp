import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:number_connection_test/globals/gobals.dart';
import 'package:number_connection_test/services/crud/models/users_and_records.dart';
import 'package:number_connection_test/services/crud/services/crud_service.dart';
import 'package:number_connection_test/views/records_view/records_list_view.dart';

class RecordsView extends StatefulWidget {
  const RecordsView({super.key});

  @override
  State<RecordsView> createState() => _RecordsViewState();
}

class _RecordsViewState extends State<RecordsView> {
  late final Services _services;
  int selectedGameId = 0; // default from 0

  @override
  void initState() {
    _services = Services();
    super.initState();
  }

  Map<int, List<DatabaseRecord>> groupRecordsByGameId(
      List<DatabaseRecord> records) {
    return records.fold<Map<int, List<DatabaseRecord>>>({}, (map, record) {
      if (!map.containsKey(record.gameId)) {
        map[record.gameId] = [];
      }
      map[record.gameId]!.add(record);
      return map;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('遊戲紀錄'),
        backgroundColor: globColor,
        toolbarHeight: 60.h,
        actions: <Widget>[
          PopupMenuButton<int>(
            onSelected: (int gameId) {
              setState(() {
                selectedGameId = gameId;
              });
            },
            itemBuilder: (BuildContext context) {
              return gameMap.entries.map((entry) {
                return PopupMenuItem<int>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList();
            },
            icon: Icon(
              Icons.menu,
              size: 20.sp,
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: false,
      body: FutureBuilder<Iterable<DatabaseRecord>>(
        future: _services.getAllRecords(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('沒有遊戲紀錄'));

            // return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final allRecords = snapshot.data as List<DatabaseRecord>;
            final filteredRecords = allRecords
                .reversed // Reverse the list of records so that the new record is at the front
                .where((record) => record.gameId == selectedGameId)
                .toList();
            final groupedRecords = groupRecordsByGameId(filteredRecords);
            return RecordsListView(groupedRecords: groupedRecords);
          } else {
            return const Center(child: Text('沒有遊戲紀錄'));
          }
        },
      ),
    );
  }
}
