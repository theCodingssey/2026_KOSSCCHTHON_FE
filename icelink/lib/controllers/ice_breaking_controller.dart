import 'package:get/get.dart';

import '../pages/ice_breaking_complete/views/ice_breaking_complete_page.dart';

class IceBreakingController extends GetxController {
  void finishIceBreaking() {
    Get.to(() => const IceBreakingCompletePage());
  }
}
