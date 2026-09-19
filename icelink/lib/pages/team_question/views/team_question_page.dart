import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/team_question_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/ice_link_app_bar.dart';

class TeamQuestionPage extends GetView<TeamQuestionController> {
  const TeamQuestionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const IceLinkAppBar(title: '질문'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppTheme.ink,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'TEAM QUESTION',
                          style: TextStyle(
                            color: AppTheme.iceAccent,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Obx(
                          () => Text(
                            controller.title.value,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 34,
                              fontWeight: FontWeight.w900,
                              height: 1.08,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Obx(
                    () => _TranscriptCard(
                      isListening: controller.isListening.value,
                      liveText: controller.liveText.value,
                      savedText: controller.savedText.value,
                      errorText: controller.speechError.value,
                    ),
                  ),
                  const Spacer(),
                  Obx(
                    () => FilledButton.icon(
                      onPressed: controller.isSubmittingAnswer.value
                          ? null
                          : controller.toggleRecording,
                      icon: Icon(
                        controller.isListening.value
                            ? Icons.stop_rounded
                            : Icons.mic_rounded,
                      ),
                      label: Text(
                        controller.isSubmittingAnswer.value
                            ? '답변 전송 중'
                            : controller.isListening.value
                            ? '녹음 완료'
                            : '녹음 시작',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TranscriptCard extends StatelessWidget {
  const _TranscriptCard({
    required this.isListening,
    required this.liveText,
    required this.savedText,
    required this.errorText,
  });

  final bool isListening;
  final String liveText;
  final String savedText;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final visibleText = liveText.trim().isNotEmpty
        ? liveText
        : savedText.trim().isNotEmpty
        ? savedText
        : '녹음을 시작하면 실시간 음성 인식 결과가 여기에 표시됩니다.';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFD0D5DD)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isListening ? Icons.graphic_eq_rounded : Icons.article_rounded,
                color: AppTheme.primaryBlue,
              ),
              const SizedBox(width: 8),
              Text(
                isListening ? '실시간 인식 중' : '저장된 음성 텍스트',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            visibleText,
            style: TextStyle(
              color: liveText.trim().isEmpty && savedText.trim().isEmpty
                  ? const Color(0xFF667085)
                  : AppTheme.ink,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          if (errorText != null) ...[
            const SizedBox(height: 12),
            Text(
              errorText!,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
