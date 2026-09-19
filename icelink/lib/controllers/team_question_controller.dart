import 'package:get/get.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../data/services/ice_link_api_service.dart';

class TeamQuestionController extends GetxController {
  TeamQuestionController({this.teamId});

  final SpeechToText _speech = SpeechToText();

  final int? teamId;

  final title = '자기소개 및 팀 리더 정하기'.obs;
  final questionId = RxnInt();
  final questionType = ''.obs;
  final questionStatus = ''.obs;
  final isListening = false.obs;
  final isSubmittingAnswer = false.obs;
  final liveText = ''.obs;
  final savedText = ''.obs;
  final speechError = RxnString();
  DateTime? _recordingStartedAt;

  IceLinkApiService get _api => Get.find<IceLinkApiService>();

  @override
  void onReady() {
    super.onReady();
    _prepareRemoteQuestion();
  }

  @override
  void onClose() {
    _speech.stop();
    super.onClose();
  }

  Future<void> toggleRecording() async {
    if (isListening.value) {
      await stopRecording();
      return;
    }

    await startRecording();
  }

  Future<void> startRecording() async {
    if (Get.testMode) {
      liveText.value = '테스트 음성 인식 결과';
      savedText.value = liveText.value;
      return;
    }

    speechError.value = null;
    _recordingStartedAt = DateTime.now();
    final isAvailable = await _speech.initialize(
      onStatus: _handleSpeechStatus,
      onError: _handleSpeechError,
    );

    if (!isAvailable) {
      speechError.value = '음성 인식을 사용할 수 없습니다.';
      Get.snackbar('마이크 오류', speechError.value!);
      return;
    }

    isListening.value = true;
    await _speech.listen(
      onResult: _handleSpeechResult,
      listenOptions: SpeechListenOptions(
        localeId: 'ko_KR',
        listenMode: ListenMode.dictation,
        partialResults: true,
      ),
    );
  }

  Future<void> stopRecording() async {
    await _speech.stop();
    _saveCurrentText();
    isListening.value = false;
    await _submitCurrentAnswer();
  }

  void _handleSpeechResult(SpeechRecognitionResult result) {
    liveText.value = result.recognizedWords;
    if (result.finalResult) {
      _saveCurrentText();
    }
  }

  void _handleSpeechStatus(String status) {
    if (status == 'done' || status == 'notListening') {
      _saveCurrentText();
      isListening.value = false;
    }
  }

  void _handleSpeechError(SpeechRecognitionError error) {
    speechError.value = error.errorMsg;
    isListening.value = false;
  }

  void _saveCurrentText() {
    final trimmedText = liveText.value.trim();
    if (trimmedText.isNotEmpty) {
      savedText.value = trimmedText;
    }
  }

  Future<void> _prepareRemoteQuestion() async {
    if (!_api.isConfigured || Get.testMode || teamId == null) {
      return;
    }

    try {
      final result = await _api.startTeam(teamId!);
      final question =
          result.mapValue('currentQuestion') ??
          (await _api.fetchTeam(teamId!)).mapValue('currentQuestion');
      _setCurrentQuestion(question);
    } catch (_) {
      try {
        final team = await _api.fetchTeam(teamId!);
        _setCurrentQuestion(team.mapValue('currentQuestion'));
      } catch (_) {
        // Keep fixed local question until backend team session is ready.
      }
    }
  }

  Future<void> _submitCurrentAnswer() async {
    final answerText = savedText.value.trim();
    final currentTeamId = teamId;
    final currentQuestionId = questionId.value;
    if (!_api.isConfigured ||
        Get.testMode ||
        currentTeamId == null ||
        currentQuestionId == null ||
        answerText.isEmpty) {
      return;
    }

    isSubmittingAnswer.value = true;
    try {
      await _api.submitAnswer(
        teamId: currentTeamId,
        questionId: currentQuestionId,
        answerText: answerText,
        speechDurationSec: _speechDurationSec(),
      );
      questionStatus.value = 'PROCESSING';
      title.value = '질문 생성 중...';
      liveText.value = '';
      savedText.value = answerText;
      await _refreshCurrentQuestionAfterDelay();
    } catch (_) {
      Get.snackbar('답변 전송 실패', '녹음된 텍스트를 서버로 보내지 못했습니다.');
    } finally {
      isSubmittingAnswer.value = false;
      _recordingStartedAt = null;
    }
  }

  Future<void> _refreshCurrentQuestionAfterDelay() async {
    final currentTeamId = teamId;
    if (currentTeamId == null) {
      return;
    }

    await Future<void>.delayed(const Duration(seconds: 2));
    try {
      final question = await _api.fetchCurrentQuestion(currentTeamId);
      _setCurrentQuestion(question);
    } catch (_) {
      // AI can still be processing. SSE/polling layer can refresh later.
    }
  }

  void _setCurrentQuestion(Map<String, dynamic>? question) {
    if (question == null || question.isEmpty) {
      return;
    }

    final content = question.stringValue('content');
    if (content.isNotEmpty) {
      title.value = content;
    }
    questionId.value = question.intValue('questionId');
    questionType.value = question.stringValue('type');
    questionStatus.value = question.stringValue('status');
  }

  int? _speechDurationSec() {
    final startedAt = _recordingStartedAt;
    if (startedAt == null) {
      return null;
    }

    return DateTime.now().difference(startedAt).inSeconds.clamp(0, 600).toInt();
  }
}
