import 'package:get/get.dart';

class TeamQuestionController extends GetxController {
  final title = '자기소개 및 팀 리더 정하기';
  final subtitle = '각자 이름을 말하고, 오늘 팀을 이끌 리더를 정해보세요.';

  void startMic() {
    Get.snackbar('마이크', '음성 기능은 다음 단계에서 연결합니다.');
  }
}
