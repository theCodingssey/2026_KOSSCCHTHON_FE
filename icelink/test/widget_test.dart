import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:icelink/app/app.dart';

void main() {
  setUp(() {
    Get.testMode = true;
  });

  tearDown(Get.reset);

  Future<void> login(WidgetTester tester) async {
    await tester.pumpWidget(const IceLinkApp());
    await tester.enterText(find.byType(TextField), '동언');
    await tester.pump();
    await tester.tap(find.text('시작하기'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 220));
    await tester.pumpAndSettle();
  }

  testWidgets('login page renders first', (WidgetTester tester) async {
    await tester.pumpWidget(const IceLinkApp());
    await tester.pumpAndSettle();

    expect(find.text('IceLink'), findsOneWidget);
    expect(find.text('이름을 입력하고 시작하세요!'), findsOneWidget);
    expect(find.text('시작하기'), findsOneWidget);
  });

  testWidgets('login moves to ICELINK home', (WidgetTester tester) async {
    await login(tester);

    expect(find.text('동언 님, 반가워요'), findsOneWidget);
    expect(find.text('방 참가하기'), findsOneWidget);
    expect(find.text('방 생성하기'), findsOneWidget);
  });

  testWidgets('join room survey creates mock team number', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(480, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await login(tester);
    await tester.tap(find.text('방 참가하기'));
    await tester.pumpAndSettle();

    expect(find.text('방 핀과 설문을 입력하세요'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'ICE-2026');
    await tester.pump();

    for (int i = 0; i < 6; i += 1) {
      await tester.tap(find.text('보통').at(i));
      await tester.pump();
    }
    await tester.tap(find.text('게임'));
    await tester.pump();
    await tester.tap(find.text('팀 번호 생성하기'));
    await tester.pumpAndSettle();

    expect(find.text('당신의 팀 번호'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
  });

  testWidgets('create room creates mock pin and opens question page', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(480, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await login(tester);
    await tester.tap(find.text('방 생성하기'));
    await tester.pumpAndSettle();

    expect(find.text('팀 구성 방식을 정하세요'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '해커톤에서 어떤 부분이 가장 자신있나요?');
    await tester.tap(find.text('방 핀 생성하기'));
    await tester.pumpAndSettle();

    expect(find.text('참가용 핀'), findsOneWidget);
    expect(find.text('ICE-2026'), findsOneWidget);

    await tester.tap(find.text('질문 페이지로 이동'));
    await tester.pumpAndSettle();

    expect(find.text('자기소개 및 팀 리더 정하기'), findsOneWidget);
    expect(find.byIcon(Icons.mic_rounded), findsOneWidget);
  });
}
