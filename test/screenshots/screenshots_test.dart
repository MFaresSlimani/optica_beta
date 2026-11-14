@Tags(['screenshots'])
library;

import 'package:bng_optica/core/services/app_info_service.dart';
import 'package:bng_optica/core/services/preferences_service.dart';
import 'package:bng_optica/core/services/session_service.dart';
import 'package:bng_optica/data/models/app_user.dart';
import 'package:bng_optica/data/models/diopter.dart';
import 'package:bng_optica/presentation/modules/auth/controllers/login_controller.dart';
import 'package:bng_optica/presentation/modules/auth/views/login_view.dart';
import 'package:bng_optica/presentation/modules/home/controllers/home_controller.dart';
import 'package:bng_optica/presentation/modules/order/controllers/order_controller.dart';
import 'package:bng_optica/presentation/modules/order/views/order_view.dart';
import 'package:bng_optica/presentation/modules/printing/controllers/printing_controller.dart';
import 'package:bng_optica/presentation/modules/printing/views/printing_view.dart';
import 'package:bng_optica/presentation/modules/profile/controllers/profile_controller.dart';
import 'package:bng_optica/presentation/modules/request_details/controllers/handle_request_controller.dart';
import 'package:bng_optica/presentation/modules/request_details/controllers/request_details_controller.dart';
import 'package:bng_optica/presentation/modules/request_details/views/handle_request_view.dart';
import 'package:bng_optica/presentation/modules/request_details/views/request_details_view.dart';
import 'package:bng_optica/presentation/modules/requests/controllers/requests_controller.dart';
import 'package:bng_optica/presentation/modules/settings/controllers/settings_controller.dart';
import 'package:bng_optica/presentation/modules/shell/controllers/shell_controller.dart';
import 'package:bng_optica/presentation/modules/shell/views/shell_view.dart';
import 'package:bng_optica/presentation/modules/store_details/controllers/store_details_controller.dart';
import 'package:bng_optica/presentation/modules/store_details/views/store_details_view.dart';
import 'package:bng_optica/presentation/services/feedback_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:get/get.dart';

import '../helpers/fakes.dart';
import '../helpers/sample_data.dart';
import '../helpers/test_app.dart';

// Regenerate with:
//   flutter test --tags screenshots --update-goldens
// Output: docs/screenshots/*.png (referenced from README.md).

const _arabic = Locale('ar', 'AR');

Future<void> _capture(WidgetTester tester, String name) {
  return expectLater(
    find.byKey(screenshotKey),
    matchesGoldenFile('../../docs/screenshots/$name.png'),
  );
}

/// Registers the four tab controllers and the shell, on [tab].
void _registerShell(SessionService session, {ShellTab tab = ShellTab.stores}) {
  final users = FakeUsersProvider([Sample.owner, Sample.optician, Sample.karim]);
  final stores = FakeStoresProvider(Sample.stores);
  Get
    ..put(ShellController()..tab.value = tab)
    ..put(HomeController(stores: stores, session: session))
    ..put(
      RequestsController(
        requests: FakeRequestsProvider([
          Sample.karimRequest,
          Sample.pendingRequest,
          Sample.completedRequest,
        ]),
        users: users,
        stores: stores,
        session: session,
      ),
    )
    ..put(ProfileController(users: users, stores: stores, session: session))
    ..put(
      SettingsController(
        preferences: Get.find<PreferencesService>(),
        session: session,
        feedback: Get.find<FeedbackService>(),
        appInfo: Get.find<AppInfoService>(),
      ),
    );
}

Future<void> _shell(
  WidgetTester tester,
  String name, {
  ShellTab tab = ShellTab.stores,
  AppUser user = Sample.owner,
  ThemeMode themeMode = ThemeMode.light,
  Locale locale = const Locale('en', 'UK'),
  bool lightStatusBar = false,
}) async {
  usePhoneSurface(tester);
  final session = registerServices(user: user);
  _registerShell(session, tab: tab);
  await pumpApp(
    tester,
    const ShellView(),
    framed: true,
    themeMode: themeMode,
    locale: locale,
    lightStatusBar: lightStatusBar,
  );
  await _capture(tester, name);
}

Future<void> _order(
  WidgetTester tester,
  String name, {
  ThemeMode themeMode = ThemeMode.light,
}) async {
  usePhoneSurface(tester);
  final session = registerServices(user: Sample.optician);
  final drafts = FakeOrderDraftProvider()..drafts[Sample.visionPlus.id] = Sample.orderLines;
  final controller = Get.put(
    OrderController(
      store: Sample.visionPlus,
      requests: FakeRequestsProvider(),
      drafts: drafts,
      session: session,
      feedback: Get.find<FeedbackService>(),
    ),
  );
  await pumpApp(tester, const OrderView(), framed: true, themeMode: themeMode);
  controller
    ..selectLensType('HMC 1.56')
    ..incrementQuantity();
  controller.sphere.setValue(Diopter.fromValue(-3.25));
  controller.cylinder.setValue(Diopter.fromValue(-0.75));
  await settle(tester);
  await _capture(tester, name);
}

Future<void> _requestDetails(
  WidgetTester tester,
  String name, {
  ThemeMode themeMode = ThemeMode.light,
}) async {
  usePhoneSurface(tester);
  final session = registerServices(user: Sample.owner);
  Get.put(RequestDetailsController(entry: Sample.entry(Sample.completedRequest), session: session));
  await pumpApp(tester, const RequestDetailsView(), framed: true, themeMode: themeMode);
  await _capture(tester, name);
}

void main() {
  setUpAll(loadAppFonts);
  tearDown(Get.reset);

  testWidgets('01 login', (tester) async {
    usePhoneSurface(tester);
    final session = registerServices();
    Get.put(
      LoginController(
        auth: FakeAuthProvider(),
        session: session,
        feedback: Get.find<FeedbackService>(),
      ),
    );
    await pumpApp(tester, const LoginView(), framed: true, lightStatusBar: true);
    await _capture(tester, '01_login');
  });

  testWidgets('02 store directory', (tester) => _shell(tester, '02_stores'));

  testWidgets('03 store details', (tester) async {
    usePhoneSurface(tester);
    final session = registerServices(user: Sample.optician);
    Get.put(
      StoreDetailsController(
        store: Sample.visionPlus,
        stores: FakeStoresProvider(Sample.stores),
        users: FakeUsersProvider([Sample.owner]),
        session: session,
        feedback: Get.find<FeedbackService>(),
      ),
    );
    await pumpApp(tester, const StoreDetailsView(), framed: true, lightStatusBar: true);
    await _capture(tester, '03_store_details');
  });

  testWidgets('04 order builder', (tester) => _order(tester, '04_order'));

  testWidgets(
    '05 requests inbox',
    (tester) => _shell(tester, '05_requests', tab: ShellTab.requests),
  );

  testWidgets('06 request details', (tester) => _requestDetails(tester, '06_request_details'));

  testWidgets('07 process request', (tester) async {
    usePhoneSurface(tester);
    registerServices(user: Sample.owner);
    final controller = Get.put(
      HandleRequestController(
        entry: Sample.entry(Sample.pendingRequest),
        requests: FakeRequestsProvider(),
        feedback: Get.find<FeedbackService>(),
      ),
    );
    controller
      ..toggle(0)
      ..toggle(1)
      ..notesController.text = 'Photochromic grey ships Monday.';
    await pumpApp(tester, const HandleRequestView(), framed: true);
    await _capture(tester, '07_process_request');
  });

  testWidgets('08 print ticket', (tester) async {
    usePhoneSurface(tester);
    registerServices(user: Sample.owner);
    final printers = FakePrinterProvider();
    final controller = Get.put(
      PrintingController(
        entry: Sample.entry(Sample.completedRequest),
        printers: printers,
        feedback: Get.find<FeedbackService>(),
      ),
    );
    await pumpApp(tester, const PrintingView(), framed: true);
    printers.emit([
      Printer(name: 'Epson TM-T20III', address: 'usb-1', isConnected: true),
      Printer(name: 'Xprinter XP-80C', address: 'ble-2', isConnected: false),
    ]);
    await controller.stopScan();
    await settle(tester);
    await _capture(tester, '08_print_ticket');
  });

  testWidgets(
    '09 profile',
    (tester) => _shell(tester, '09_profile', tab: ShellTab.profile, lightStatusBar: true),
  );

  testWidgets('10 settings', (tester) => _shell(tester, '10_settings', tab: ShellTab.settings));

  testWidgets(
    '11 store directory, dark',
    (tester) => _shell(tester, '11_stores_dark', themeMode: ThemeMode.dark),
  );

  testWidgets(
    '12 order builder, dark',
    (tester) => _order(tester, '12_order_dark', themeMode: ThemeMode.dark),
  );

  testWidgets(
    '13 request details, dark',
    (tester) => _requestDetails(tester, '13_request_details_dark', themeMode: ThemeMode.dark),
  );

  testWidgets('14 requests in Arabic (RTL)', (tester) {
    return _shell(tester, '14_requests_arabic', tab: ShellTab.requests, locale: _arabic);
  });
}
