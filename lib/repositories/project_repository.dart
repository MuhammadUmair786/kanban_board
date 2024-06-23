import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../constants/extras.dart';
import '../models/board_model.dart';

class ProjectRepository {
  // final String baseUrl = "/projects";

  static Future<List<BoardModel>> fetchProjectList() async {
    String url = "$BASEURL/projects";

    log(url);

    final response = await http.get(Uri.parse(url), headers: apiHeader);
    log("fetchProjectList() -> Status code ${response.statusCode}");
    if (response.statusCode == 200) {
      List<dynamic> responseList = jsonDecode(response.body);
      log("Project List Length :: ${responseList.length}");
      return responseList.map((json) => BoardModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load items');
    }
  }
}
