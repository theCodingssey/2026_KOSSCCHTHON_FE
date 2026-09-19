import 'package:dio/dio.dart';

import '../models/login_session.dart';
import 'api_endpoints.dart';
import 'api_service.dart';

class IceLinkApiService {
  IceLinkApiService(this._api);

  final ApiService _api;

  bool get isConfigured => _api.isConfigured;

  void setUserKey(String userKey) => _api.setUserKey(userKey);

  void clearUserKey() => _api.clearUserKey();

  Future<LoginSession> registerUser(String name) async {
    final response = await _api.post<dynamic>(
      ApiEndpoints.users,
      data: {'name': name},
    );
    final data = _asMap(response);

    return LoginSession(
      name: data.stringValue('name', fallback: name),
      userKey: data.stringValue('userKey'),
    );
  }

  Future<Map<String, dynamic>> fetchMe() async {
    final response = await _api.get<dynamic>(ApiEndpoints.usersMe);
    return _asMap(response);
  }

  Future<Map<String, dynamic>> createRoom({
    required String title,
    required String situation,
    required int teamSize,
    required List<String> finalQuestions,
  }) async {
    final response = await _api.post<dynamic>(
      ApiEndpoints.rooms,
      data: {
        'title': title,
        'situation': situation,
        'teamSize': teamSize,
        'finalQuestions': finalQuestions,
      },
    );

    return _asMap(response);
  }

  Future<Map<String, dynamic>> fetchHostRoom(String code) async {
    final response = await _api.get<dynamic>(ApiEndpoints.hostRoom(code));
    return _asMap(response);
  }

  Future<List<Map<String, dynamic>>> fetchHostParticipants(String code) async {
    final response = await _api.get<dynamic>(
      ApiEndpoints.hostRoomParticipants(code),
    );
    return _asList(response);
  }

  Future<Map<String, dynamic>> startTeamBuilding(String code) async {
    final response = await _api.post<dynamic>(
      ApiEndpoints.hostRoomTeamBuilding(code),
      data: {'includeIncompleteSurvey': false},
    );
    return _asMap(response);
  }

  Future<Map<String, dynamic>> updateFinalQuestions({
    required String code,
    required List<String> finalQuestions,
  }) async {
    final response = await _api.put<dynamic>(
      ApiEndpoints.hostRoomFinalQuestions(code),
      data: {'finalQuestions': finalQuestions},
    );
    return _asMap(response);
  }

  Future<Map<String, dynamic>> finishRoom(String code) async {
    final response = await _api.post<dynamic>(
      ApiEndpoints.hostRoomFinish(code),
    );
    return _asMap(response);
  }

  Future<void> leaveRoom(String code) async {
    await _api.delete<dynamic>(ApiEndpoints.roomMe(code));
  }

  Future<Map<String, dynamic>> joinRoom({
    required String code,
    String? nickname,
  }) async {
    final body = <String, dynamic>{};
    final trimmedNickname = nickname?.trim();
    if (trimmedNickname != null && trimmedNickname.isNotEmpty) {
      body['nickname'] = trimmedNickname;
    }

    final response = await _api.post<dynamic>(
      ApiEndpoints.roomParticipants(code),
      data: body,
    );
    return _asMap(response);
  }

  Future<Map<String, dynamic>> fetchRoomMe(String code) async {
    final response = await _api.get<dynamic>(ApiEndpoints.roomMe(code));
    return _asMap(response);
  }

  Future<Map<String, dynamic>> submitSurvey({
    required String code,
    required List<Map<String, int>> personality,
    required String interestCategory,
  }) async {
    final response = await _api.put<dynamic>(
      ApiEndpoints.roomMeSurvey(code),
      data: {'personality': personality, 'interestCategory': interestCategory},
    );
    return _asMap(response);
  }

  Future<Map<String, dynamic>?> fetchMyTeam(String code) async {
    try {
      final response = await _api.get<dynamic>(ApiEndpoints.roomMeTeam(code));
      return _asMap(response);
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        return null;
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchTeam(int teamId) async {
    final response = await _api.get<dynamic>(ApiEndpoints.team(teamId));
    return _asMap(response);
  }

  Future<Map<String, dynamic>> startTeam(int teamId) async {
    final response = await _api.post<dynamic>(ApiEndpoints.teamStart(teamId));
    return _asMap(response);
  }

  Future<Map<String, dynamic>> updateTeamName({
    required int teamId,
    required String name,
  }) async {
    final response = await _api.put<dynamic>(
      ApiEndpoints.teamName(teamId),
      data: {'name': name},
    );
    return _asMap(response);
  }

  Future<Map<String, dynamic>> fetchCurrentQuestion(int teamId) async {
    final response = await _api.get<dynamic>(
      ApiEndpoints.teamCurrentQuestion(teamId),
    );
    return _asMap(response);
  }

  Future<Map<String, dynamic>> requestNextQuestion(int teamId) async {
    final response = await _api.post<dynamic>(
      ApiEndpoints.teamNextQuestion(teamId),
    );
    return _asMap(response);
  }

  Future<Map<String, dynamic>> submitAnswer({
    required int teamId,
    required int questionId,
    required String answerText,
    int? speechDurationSec,
  }) async {
    final data = <String, dynamic>{'answerText': answerText};
    if (speechDurationSec != null) {
      data['speechDurationSec'] = speechDurationSec;
    }

    final response = await _api.post<dynamic>(
      ApiEndpoints.teamQuestionAnswer(teamId, questionId),
      data: data,
    );
    return _asMap(response);
  }

  Map<String, dynamic> _asMap(Response<dynamic> response) {
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return data;
    }
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return <String, dynamic>{};
  }

  List<Map<String, dynamic>> _asList(Response<dynamic> response) {
    final data = response.data;
    if (data is List) {
      return data
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }
    return <Map<String, dynamic>>[];
  }
}

extension JsonMapReader on Map<String, dynamic> {
  String stringValue(String key, {String fallback = ''}) {
    final value = this[key];
    if (value is String) {
      return value;
    }
    return fallback;
  }

  int? intValue(String key) {
    final value = this[key];
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse('$value');
  }

  Map<String, dynamic>? mapValue(String key) {
    final value = this[key];
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return null;
  }
}
