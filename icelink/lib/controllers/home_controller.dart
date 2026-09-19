import 'package:get/get.dart';

import '../data/models/login_session.dart';
import '../data/services/ice_link_api_service.dart';
import '../pages/create_room/views/create_room_page.dart';
import '../pages/join_room/views/join_room_page.dart';
import 'create_room_controller.dart';
import 'join_room_controller.dart';

class HomeController extends GetxController {
  HomeController({this.session});

  final LoginSession? session;
  final isClearingActiveRoom = false.obs;

  IceLinkApiService get _api => Get.find<IceLinkApiService>();

  bool get canUseDebugRoomClear => _api.isConfigured;

  void openJoinRoom() {
    Get.to(
      () => const JoinRoomPage(),
      binding: BindingsBuilder(() {
        Get.put(JoinRoomController());
      }),
    );
  }

  void openCreateRoom() {
    Get.to(
      () => const CreateRoomPage(),
      binding: BindingsBuilder(() {
        Get.put(CreateRoomController());
      }),
    );
  }

  Future<void> clearActiveRoomForDebug() async {
    if (!_api.isConfigured) {
      Get.snackbar('디버그 종료 불가', 'Base URL이 설정되어 있지 않습니다.');
      return;
    }

    isClearingActiveRoom.value = true;
    try {
      final me = await _api.fetchMe();
      final activeRoom = me.mapValue('activeRoom');
      if (activeRoom == null) {
        Get.snackbar('진행 중인 방 없음', '종료할 방이 없습니다.');
        return;
      }

      final code = activeRoom.stringValue('code');
      final role = activeRoom.stringValue('role');
      if (code.isEmpty) {
        Get.snackbar('방 코드 없음', '서버 응답에서 방 코드를 찾지 못했습니다.');
        return;
      }

      if (role == 'HOST') {
        await _api.finishRoom(code);
        Get.snackbar('방 종료 완료', '$code 방을 종료했습니다.');
        return;
      }

      if (role == 'PARTICIPANT') {
        await _api.leaveRoom(code);
        Get.snackbar('방 나가기 완료', '$code 방에서 나갔습니다.');
        return;
      }

      Get.snackbar('역할 확인 필요', '지원하지 않는 역할입니다: $role');
    } catch (_) {
      Get.snackbar('디버그 요청 실패', '진행 중인 방을 종료하지 못했습니다.');
    } finally {
      isClearingActiveRoom.value = false;
    }
  }
}
