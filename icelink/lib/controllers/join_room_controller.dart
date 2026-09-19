import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/services/ice_link_api_service.dart';
import '../pages/team_building_wait/views/team_building_wait_page.dart';
import '../pages/team_number/views/team_number_page.dart';
import '../pages/team_question/views/team_question_page.dart';
import 'team_question_controller.dart';

class JoinRoomController extends GetxController {
  final pinController = TextEditingController();
  final selectedAnswers = <int, String>{}.obs;
  final selectedHobby = RxnString();
  final teamNumber = RxnInt();
  final teamId = RxnInt();
  final isSubmitting = false.obs;
  final isWaitingForTeam = false.obs;
  Timer? _teamAssignmentPollingTimer;
  bool _isCheckingTeamAssignment = false;

  final questions = const [
    '나는 함께 있는 것을 좋아한다.',
    '나는 새로운 사람들과 만나는 것이 편하다.',
    '나는 파티나 모임에서\n주도적으로 대화를 이끈다.',
    '나는 사람들과 함께 있을 때\n에너지를 얻는다.',
    '나는 많은 사람들과 친구로\n지내는 것을 선호한다.',
    '나는 생각하기 전에 먼저 말하는 편이다.',
  ];

  final answerOptions = const ['매우 맞음', '맞음', '보통', '아님', '매우 아님'];
  final hobbies = const ['게임', '여행', '음식', '스포츠', '영화'];

  IceLinkApiService get _api => Get.find<IceLinkApiService>();

  bool get isSurveyComplete {
    return pinController.text.trim().isNotEmpty &&
        selectedAnswers.length == questions.length &&
        selectedHobby.value != null;
  }

  @override
  void onInit() {
    super.onInit();
    pinController.addListener(update);
  }

  @override
  void onClose() {
    _teamAssignmentPollingTimer?.cancel();
    pinController.dispose();
    super.onClose();
  }

  void selectAnswer(int questionIndex, String answer) {
    selectedAnswers[questionIndex] = answer;
  }

  void selectHobby(String hobby) {
    selectedHobby.value = hobby;
  }

  Future<void> generateTeamNumber() async {
    if (!isSurveyComplete) {
      Get.snackbar('아직 덜 골랐어요', '핀, 6개 설문, 취미를 모두 선택해주세요.');
      return;
    }

    isSubmitting.value = true;
    try {
      final pin = pinController.text.trim().toUpperCase();
      if (_api.isConfigured && !Get.testMode) {
        await _api.joinRoom(code: pin);
        await _api.submitSurvey(
          code: pin,
          personality: _personalityPayload(),
          interestCategory: _interestCategoryCode(selectedHobby.value!),
        );

        final team = await _api.fetchMyTeam(pin);
        if (team != null) {
          _openTeamNumber(team);
          return;
        }

        _openTeamBuildingWait(pin);
      } else {
        const mockTeamNumber = 5;
        teamNumber.value = mockTeamNumber;
        Get.to(() => const TeamNumberPage(teamNumber: mockTeamNumber));
      }
    } catch (_) {
      Get.snackbar('방 참가 실패', '방 코드와 서버 상태를 확인해주세요.');
    } finally {
      isSubmitting.value = false;
    }
  }

  void _openTeamBuildingWait(String roomCode) {
    isWaitingForTeam.value = true;
    Get.to(() => const TeamBuildingWaitPage());
    _startTeamAssignmentPolling(roomCode);
  }

  void _startTeamAssignmentPolling(String roomCode) {
    _teamAssignmentPollingTimer?.cancel();
    _teamAssignmentPollingTimer = Timer.periodic(const Duration(seconds: 3), (
      _,
    ) {
      _checkTeamAssignment(roomCode);
    });
    _checkTeamAssignment(roomCode);
  }

  Future<void> _checkTeamAssignment(String roomCode) async {
    if (_isCheckingTeamAssignment) {
      return;
    }

    _isCheckingTeamAssignment = true;
    try {
      final team = await _api.fetchMyTeam(roomCode);
      if (team == null) {
        return;
      }

      _openTeamNumber(team);
    } catch (_) {
      // Keep waiting. Polling will retry while host has not finished team building.
    } finally {
      _isCheckingTeamAssignment = false;
    }
  }

  void _openTeamNumber(Map<String, dynamic> team) {
    _teamAssignmentPollingTimer?.cancel();
    isWaitingForTeam.value = false;

    final remoteTeamNumber = team.intValue('teamNo') ?? 5;
    final remoteTeamId = team.intValue('teamId');
    teamNumber.value = remoteTeamNumber;
    teamId.value = remoteTeamId;

    Get.off(
      () => TeamNumberPage(teamNumber: remoteTeamNumber, teamId: remoteTeamId),
    );
  }

  void goToQuestionPage() {
    Get.to(
      () => const TeamQuestionPage(),
      binding: BindingsBuilder(() {
        Get.put(TeamQuestionController(teamId: teamId.value));
      }),
    );
  }

  List<Map<String, int>> _personalityPayload() {
    return [
      for (int index = 0; index < questions.length; index += 1)
        {'no': index + 1, 'score': _scoreForAnswer(selectedAnswers[index]!)},
    ];
  }

  int _scoreForAnswer(String answer) {
    final index = answerOptions.indexOf(answer);
    if (index == -1) {
      return 3;
    }
    return 5 - index;
  }

  String _interestCategoryCode(String hobby) {
    return switch (hobby) {
      '영화' => 'MOVIE',
      '게임' => 'GAME',
      '음식' => 'FOOD',
      '여행' => 'TRAVEL',
      '스포츠' => 'SPORTS',
      _ => 'GAME',
    };
  }
}
