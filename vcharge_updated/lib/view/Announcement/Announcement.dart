// ignore_for_file: use_key_in_widget_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vcharge/models/announcementModel.dart';
import 'package:vcharge/view/Announcement/underMaintenancePage.dart';

import '../../services/urls.dart';

class AnnouncementBox extends StatefulWidget {
  final String positionName;

  AnnouncementBox({required this.positionName});

  @override
  _AnnouncementBoxState createState() => _AnnouncementBoxState();
}

class _AnnouncementBoxState extends State<AnnouncementBox> {
  late Future<AnnouncementModel?> _announcement;

  @override
  void initState() {
    super.initState();
    _announcement = fetchAnnouncement(widget.positionName);
  }

  Future<AnnouncementModel?> fetchAnnouncement(String positionName) async {
    final response = await http.get(Uri.parse(
        '${Urls().masterUrl}/manageAnnouncement/getAnnouncementByPositionName?positionName=$positionName'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return AnnouncementModel.fromJson(data);
    } else {
      throw Exception('Failed to load announcement');
    }
  }

  Icon getIconFromName(String iconName) {
    switch (iconName) {
      case 'alert':
        return const Icon(Icons.info, color: Colors.black);

      case 'caution':
        return const Icon(Icons.warning, color: Colors.orange);

      default:
        return const Icon(Icons.info, color: Colors.black);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AnnouncementModel?>(
        future: _announcement,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            if (snapshot.data!.message != null &&
                snapshot.data!.message!.isNotEmpty) {
              if (snapshot.data!.message!
                  .toLowerCase()
                  .contains('maintenance')) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UnderMaintenance()));
              } else {
                return Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      width: 1,
                      color: Colors.black,
                    ),
                  ),
                  child: Row(
                    children: [
                      getIconFromName(snapshot.data!.icon!),
                      const SizedBox(width: 8.0),
                      Text(snapshot.data!.message!),
                    ],
                  ),
                );
              }
            } else {
              return Container();
            }
          }
          return Container();
        });
  }
}
