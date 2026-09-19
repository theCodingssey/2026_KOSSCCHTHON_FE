import 'dart:async';

import 'package:get/get.dart';

import '../data/services/ice_link_api_service.dart';
import '../pages/ice_breaking/views/ice_breaking_page.dart';
import 'ice_breaking_controller.dart';

class PeopleChecklistController extends GetxController {
  PeopleChecklistController({required this.roomPin});

  final String roomPin;

  final participants = <String>['김민지', '이준호', '박서연', '최도윤', '정하은'].obs;
  final isStarting = false.obs;
  Timer? _participantPollingTimer;
  bool _isLoadingParticipants = false;

  IceLinkApiService get _api => Get.find<IceLinkApiService>();

  @override
  void onReady() {
    super.onReady();
    _loadParticipants();
    _startParticipantPolling();
  }

  @override
  void onClose() {
    _participantPollingTimer?.cancel();
    super.onClose();
  }

  Future<void> startIceBreaking() async {
    isStarting.value = true;
    try {
      if (_api.isConfigured && !Get.testMode) {
        await _api.startTeamBuilding(roomPin);
      }
      _participantPollingTimer?.cancel();
      _openIceBreaking();
    } catch (_) {
      Get.snackbar('팀 빌딩 실패', '참가자 설문 완료 상태를 확인해주세요.');
    } finally {
      isStarting.value = false;
    }
  }

  Future<void> _loadParticipants() async {
    if (!_api.isConfigured || Get.testMode || _isLoadingParticipants) {
      return;
    }

    _isLoadingParticipants = true;
    try {
      final remoteParticipants = await _api.fetchHostParticipants(roomPin);
      participants.assignAll(
        remoteParticipants
            .map((participant) => participant.stringValue('nickname'))
            .where((name) => name.isNotEmpty),
      );
    } catch (_) {
      // Mock list stays visible until backend is ready for this room.
    } finally {
      _isLoadingParticipants = false;
    }
  }

  void _startParticipantPolling() {
    if (!_api.isConfigured || Get.testMode) {
      return;
    }

    _participantPollingTimer?.cancel();
    _participantPollingTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _loadParticipants();
    });
  }

  void _openIceBreaking() {
    Get.to(
      () => const IceBreakingPage(),
      binding: BindingsBuilder(() {
        Get.put(IceBreakingController());
      }),
    );
  }
}
