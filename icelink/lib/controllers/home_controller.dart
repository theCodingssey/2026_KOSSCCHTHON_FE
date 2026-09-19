import 'package:get/get.dart';

import '../data/models/login_session.dart';
import '../modules/create_room/views/create_room_page.dart';
import '../modules/join_room/views/join_room_page.dart';
import 'create_room_controller.dart';
import 'join_room_controller.dart';

class HomeController extends GetxController {
  HomeController({this.session});

  final LoginSession? session;

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
}
