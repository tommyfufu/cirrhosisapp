import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:number_connection_test/games/soldiers_in_formation/soldiers_in_formation_game_ending_record_view.dart';
import 'package:number_connection_test/globals/gobals.dart';
import 'package:number_connection_test/services/crud/models/users_and_records.dart';
import 'package:number_connection_test/services/crud/services/crud_service.dart';

class SIFGameOverView extends StatefulWidget {
  const SIFGameOverView({
    super.key,
  });

  @override
  State<SIFGameOverView> createState() => _SIFGameOverViewState();
}

class _SIFGameOverViewState extends State<SIFGameOverView> {
  late final Services _services;

  @override
  void initState() {
    _services = Services();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('遊戲紀錄'),
        backgroundColor: globColor,
        toolbarHeight: 60.h,
      ),
      extendBodyBehindAppBar: false,
      body: StreamBuilder<List<DatabaseRecord>>(
        stream: _services.allRecords,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Handle error
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final latestRecord = snapshot.data!.last;
            return SIFEndingRecordView(record: latestRecord);
          } else {
            // Handle the case where there's no data
            return const Center(child: Text('No records found.'));
          }
        },
      ),
    );
  }
}
