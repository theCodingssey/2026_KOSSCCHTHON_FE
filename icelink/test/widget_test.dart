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

    expect(find.text('이름을 입력하고\n시작하세요!'), findsOneWidget);
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

    expect(find.text('방 핀과 설문을 입력하세요!'), findsOneWidget);
    expect(find.text('나는 함께 있는 것을 좋아한다.'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'ICE-2026');
    await tester.pump();

    for (int i = 0; i < 6; i += 1) {
      await tester.tap(find.bySemanticsLabel('보통').at(i));
      await tester.pump();
    }
    await tester.ensureVisible(find.byKey(const ValueKey('hobby-게임')));
    await tester.tap(find.byKey(const ValueKey('hobby-게임')));
    await tester.pump();
    await tester.tap(find.text('팀 번호 생성하기'));
    await tester.pumpAndSettle();

    expect(find.text('팀 번호 확인하기'), findsOneWidget);
    expect(find.text('당신의 팀 번호'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
  });

  testWidgets('create room creates mock pin and opens participant checklist', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(480, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await login(tester);
    await tester.tap(find.text('방 생성하기'));
    await tester.pumpAndSettle();

    expect(find.text('팀 구성 및 질문 추가'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(0), '6');
    await tester.enterText(
      find.byType(TextField).at(1),
      '해커톤에서 어떤 부분이 가장 자신있나요?',
    );
    await tester.tap(find.text('질문 추가하기'));
    await tester.pumpAndSettle();

    expect(find.text('추가된 질문'), findsOneWidget);
    expect(find.text('해커톤에서 어떤 부분이 가장 자신있나요?'), findsOneWidget);

    await tester.tap(find.text('방 핀 생성하기'));
    await tester.pumpAndSettle();

    expect(find.text('참가용 핀'), findsOneWidget);
    expect(find.text('ICE-2026'), findsOneWidget);

    await tester.tap(find.text('참가자 명단 확인하기'));
    await tester.pumpAndSettle();

    expect(find.text('참가자 명단 확인하기'), findsOneWidget);
    expect(find.text('참가자 명단'), findsOneWidget);
    expect(find.text('ICE-2026'), findsOneWidget);

    await tester.tap(find.text('시작하기!'));
    await tester.pumpAndSettle();

    expect(find.text('아이스 브레이킹 중...'), findsOneWidget);

    await tester.tap(find.text('추가 질문 제시 후 아이스 브레이킹 마치기!'));
    await tester.pumpAndSettle();

    expect(find.text('수고하셨습니다!'), findsOneWidget);

    await tester.tap(find.text('메인으로 가기'));
    await tester.pumpAndSettle();

    expect(find.text('방 참가하기'), findsOneWidget);
    expect(find.text('방 생성하기'), findsOneWidget);
  });
}
