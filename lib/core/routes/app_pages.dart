import 'package:get/get.dart';

import '../../presentation/modules/about/controllers/about_controller.dart';
import '../../presentation/modules/about/views/about_view.dart';
import '../../presentation/modules/auth/bindings/auth_bindings.dart';
import '../../presentation/modules/auth/views/login_view.dart';
import '../../presentation/modules/auth/views/sign_up_view.dart';
import '../../presentation/modules/order/bindings/order_binding.dart';
import '../../presentation/modules/order/views/order_view.dart';
import '../../presentation/modules/printing/views/printing_view.dart';
import '../../presentation/modules/profile/bindings/profile_bindings.dart';
import '../../presentation/modules/profile/views/create_store_view.dart';
import '../../presentation/modules/profile/views/edit_profile_view.dart';
import '../../presentation/modules/profile/views/user_profile_view.dart';
import '../../presentation/modules/request_details/bindings/request_bindings.dart';
import '../../presentation/modules/request_details/views/handle_request_view.dart';
import '../../presentation/modules/request_details/views/request_details_view.dart';
import '../../presentation/modules/shell/bindings/shell_binding.dart';
import '../../presentation/modules/shell/views/shell_view.dart';
import '../../presentation/modules/store_details/bindings/store_details_binding.dart';
import '../../presentation/modules/store_details/views/store_details_view.dart';
import '../../presentation/modules/store_details/views/store_gallery_view.dart';
import 'app_routes.dart';
import 'route_guards.dart';

abstract final class AppPages {
  static final List<GetMiddleware> _authed = [AuthGuard()];
  static final List<GetMiddleware> _guest = [GuestGuard()];

  static final List<GetPage<dynamic>> pages = [
    GetPage<void>(
      name: AppRoutes.login,
      page: LoginView.new,
      binding: LoginBinding(),
      middlewares: _guest,
    ),
    GetPage<void>(
      name: AppRoutes.signUp,
      page: SignUpView.new,
      binding: SignUpBinding(),
      middlewares: _guest,
    ),
    GetPage<void>(
      name: AppRoutes.shell,
      page: ShellView.new,
      binding: ShellBinding(),
      middlewares: _authed,
    ),
    GetPage<bool>(
      name: AppRoutes.storeDetails,
      page: StoreDetailsView.new,
      binding: StoreDetailsBinding(),
      middlewares: _authed,
    ),
    GetPage<void>(
      name: AppRoutes.storeGallery,
      page: StoreGalleryView.new,
      transition: Transition.fadeIn,
      middlewares: _authed,
    ),
    GetPage<void>(
      name: AppRoutes.order,
      page: OrderView.new,
      binding: OrderBinding(),
      middlewares: _authed,
    ),
    GetPage<bool>(
      name: AppRoutes.requestDetails,
      page: RequestDetailsView.new,
      binding: RequestDetailsBinding(),
      middlewares: _authed,
    ),
    GetPage<dynamic>(
      name: AppRoutes.handleRequest,
      page: HandleRequestView.new,
      binding: HandleRequestBinding(),
      middlewares: _authed,
    ),
    GetPage<void>(
      name: AppRoutes.printing,
      page: PrintingView.new,
      binding: PrintingBinding(),
      middlewares: _authed,
    ),
    GetPage<void>(
      name: AppRoutes.userProfile,
      page: UserProfileView.new,
      binding: UserProfileBinding(),
      middlewares: _authed,
    ),
    GetPage<void>(
      name: AppRoutes.editProfile,
      page: EditProfileView.new,
      binding: EditProfileBinding(),
      middlewares: _authed,
    ),
    GetPage<void>(
      name: AppRoutes.createStore,
      page: CreateStoreView.new,
      binding: CreateStoreBinding(),
      middlewares: _authed,
    ),
    GetPage<void>(
      name: AppRoutes.about,
      page: AboutView.new,
      binding: BindingsBuilder<void>(() => Get.lazyPut(AboutController.new)),
    ),
  ];
}
