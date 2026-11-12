import 'package:bng_optica/core/constants/app_strings.dart';
import 'package:bng_optica/data/models/data_exception.dart';
import 'package:bng_optica/presentation/modules/auth/controllers/login_controller.dart';
import 'package:bng_optica/presentation/modules/auth/views/login_view.dart';
import 'package:bng_optica/presentation/modules/order/controllers/order_controller.dart';
import 'package:bng_optica/presentation/modules/order/views/order_view.dart';
import 'package:bng_optica/presentation/modules/requests/views/widgets/request_card.dart';
import 'package:bng_optica/presentation/services/feedback_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import '../helpers/fakes.dart';
import '../helpers/sample_data.dart';
import '../helpers/test_app.dart';

void main() {
  setUpAll(loadAppFonts);
  tearDown(Get.reset);

  group('LoginView', () {
    late FakeAuthProvider auth;

    Future<void> pumpLogin(WidgetTester tester) async {
      usePhoneSurface(tester);
      final session = registerServices();
      auth = FakeAuthProvider();
      Get.put(LoginController(auth: auth, session: session, feedback: Get.find<FeedbackService>()));
      await pumpApp(tester, const LoginView());
    }

    testWidgets('shows translated validation errors and does not call the backend', (tester) async {
      await pumpLogin(tester);
      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(find.text('Please enter an email'), findsOneWidget);
      expect(find.text('Please enter a password'), findsOneWidget);
      expect(auth.currentUserId, isNull);
    });

    testWidgets('rejects a malformed email and a short password', (tester) async {
      await pumpLogin(tester);
      await tester.enterText(find.byType(TextFormField).at(0), 'not-an-email');
      await tester.enterText(find.byType(TextFormField).at(1), '123');
      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(find.text('Please enter a valid email address'), findsOneWidget);
      expect(find.text('Password must be at least 6 characters'), findsOneWidget);
    });

    testWidgets('a failed sign-in reports an error and stops loading', (tester) async {
      await pumpLogin(tester);
      auth.signInError = const DataException('Invalid login credentials');
      await tester.enterText(find.byType(TextFormField).at(0), 'amina@vision-plus.dz');
      await tester.enterText(find.byType(TextFormField).at(1), 'secret123');
      await tester.tap(find.text('Login'));
      await tester.pump();

      final feedback = Get.find<FeedbackService>() as RecordingFeedback;
      expect(feedback.errors, [AppStrings.failedToSignIn.tr]);
      expect(Get.find<LoginController>().isLoading.value, isFalse);
    });

    testWidgets('the eye button reveals the password', (tester) async {
      await pumpLogin(tester);
      EditableText password() => tester.widget<EditableText>(find.byType(EditableText).at(1));
      expect(password().obscureText, isTrue);
      await tester.tap(find.byIcon(Icons.visibility_off_outlined));
      await tester.pump();
      expect(password().obscureText, isFalse);
    });
  });

  group('OrderView', () {
    testWidgets('adding a lens moves it into the order and enables sending', (tester) async {
      usePhoneSurface(tester, height: 1400);
      final session = registerServices(user: Sample.optician);
      final drafts = FakeOrderDraftProvider();
      Get.put(
        OrderController(
          store: Sample.visionPlus,
          requests: FakeRequestsProvider(),
          drafts: drafts,
          session: session,
          feedback: Get.find<FeedbackService>(),
        ),
      );
      await pumpApp(tester, const OrderView());
      final emptyState = find.text('No lenses added to order yet');
      expect(emptyState, findsOneWidget);
      FilledButton send() =>
          tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Send order'));
      expect(send().onPressed, isNull);

      await tester.tap(find.text('Add to Order'));
      await settle(tester);

      expect(emptyState, findsNothing);
      expect(find.text('1 lenses · 1 lines'), findsOneWidget);
      expect(send().onPressed, isNotNull);
      expect(drafts.drafts[Sample.visionPlus.id], hasLength(1));
    });
  });

  testWidgets('RequestCard shows counterpart, size and status', (tester) async {
    registerServices();
    await pumpApp(
      tester,
      Scaffold(
        body: Column(
          children: [
            RequestCard(entry: Sample.entry(Sample.pendingRequest), incoming: true, onTap: () {}),
            RequestCard(
              entry: Sample.entry(Sample.completedRequest),
              incoming: false,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
    expect(find.text('From Yacine Haddad'), findsOneWidget);
    expect(find.text('To Vision Plus Optique'), findsOneWidget);
    expect(find.text('Pending'), findsOneWidget);
    expect(find.text('Completed'), findsOneWidget);
    expect(find.textContaining('7 lenses'), findsNWidgets(2));
  });
}
