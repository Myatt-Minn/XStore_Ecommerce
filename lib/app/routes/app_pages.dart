import 'package:get/get.dart';

import '../modules/Cart/bindings/cart_binding.dart';
import '../modules/Cart/views/cart_view.dart';
import '../modules/FullScreenImage/bindings/full_screen_image_binding.dart';
import '../modules/FullScreenImage/views/full_screen_image_view.dart';
import '../modules/SendNotification/bindings/send_notification_binding.dart';
import '../modules/SendNotification/views/send_notification_view.dart';
import '../modules/account/bindings/account_binding.dart';
import '../modules/account/views/account_view.dart';
import '../modules/add_delivery_fee/bindings/add_delivery_fee_binding.dart';
import '../modules/add_delivery_fee/views/add_delivery_fee_view.dart';
import '../modules/add_privacy/bindings/add_privacy_binding.dart';
import '../modules/add_privacy/views/add_privacy_view.dart';
import '../modules/add_terms/bindings/add_terms_binding.dart';
import '../modules/add_terms/views/add_terms_view.dart';
import '../modules/admin_dashboard/bindings/admin_dashboard_binding.dart';
import '../modules/admin_dashboard/views/admin_dashboard_view.dart';
import '../modules/admin_panel/bindings/admin_panel_binding.dart';
import '../modules/admin_panel/views/admin_panel_view.dart';
import '../modules/all_category_products/bindings/all_category_products_binding.dart';
import '../modules/all_category_products/views/all_category_products_view.dart';
import '../modules/all_products/bindings/all_products_binding.dart';
import '../modules/all_products/views/all_products_view.dart';
import '../modules/auth_gate/bindings/auth_gate_binding.dart';
import '../modules/auth_gate/views/auth_gate_view.dart';
import '../modules/auth_gate/views/no_internet.dart';
import '../modules/banner_list/bindings/banner_list_binding.dart';
import '../modules/banner_list/views/add_banner.dart';
import '../modules/banner_list/views/banner_list_view.dart';
import '../modules/brand_list/bindings/brand_list_binding.dart';
import '../modules/brand_list/views/add_brand.dart';
import '../modules/brand_list/views/brand_list_view.dart';
import '../modules/category/bindings/category_binding.dart';
import '../modules/category/views/category_view.dart';
import '../modules/category_list/bindings/category_list_binding.dart';
import '../modules/category_list/views/add_category.dart';
import '../modules/category_list/views/category_list_view.dart';
import '../modules/check_out/bindings/check_out_binding.dart';
import '../modules/check_out/views/check_out_view.dart';
import '../modules/customer_list/bindings/customer_list_binding.dart';
import '../modules/customer_list/views/customer_list_view.dart';
import '../modules/deliveryFees_list/bindings/delivery_fees_list_binding.dart';
import '../modules/deliveryFees_list/views/delivery_fees_list_view.dart';
import '../modules/edit_products/bindings/edit_products_binding.dart';
import '../modules/edit_products/views/edit_products_view.dart';
import '../modules/edit_profile/bindings/edit_profile_binding.dart';
import '../modules/edit_profile/views/edit_profile_view.dart';
import '../modules/forgot_password/bindings/forgot_password_binding.dart';
import '../modules/forgot_password/views/forgot_password_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/navigation_screen/bindings/navigation_screen_binding.dart';
import '../modules/navigation_screen/views/navigation_screen_view.dart';
import '../modules/notification/bindings/notification_binding.dart';
import '../modules/notification/views/notification_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/order_history/bindings/order_history_binding.dart';
import '../modules/order_history/views/order_details.dart';
import '../modules/order_history/views/order_history_view.dart';
import '../modules/order_list/bindings/order_list_binding.dart';
import '../modules/order_list/views/order_list_view.dart';
import '../modules/order_success/bindings/order_success_binding.dart';
import '../modules/order_success/views/order_success_view.dart';
import '../modules/payment/bindings/payment_binding.dart';
import '../modules/payment/views/payment_view.dart';
import '../modules/payment_list/bindings/payment_list_binding.dart';
import '../modules/payment_list/views/add_payment.dart';
import '../modules/payment_list/views/payment_list_view.dart';
import '../modules/popular_products/bindings/popular_products_binding.dart';
import '../modules/popular_products/views/popular_products_view.dart';
import '../modules/privacy_policy/bindings/privacy_policy_binding.dart';
import '../modules/privacy_policy/views/privacy_policy_view.dart';
import '../modules/product_details/bindings/product_details_binding.dart';
import '../modules/product_details/views/product_details_view.dart';
import '../modules/product_list/bindings/product_list_binding.dart';
import '../modules/product_list/views/add_product.dart';
import '../modules/product_list/views/product_list_view.dart';
import '../modules/send_specific_notification/bindings/send_specific_notification_binding.dart';
import '../modules/send_specific_notification/views/send_specific_notification_view.dart';
import '../modules/signup/bindings/signup_binding.dart';
import '../modules/signup/views/signup_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/terms_and_condition/bindings/terms_and_condition_binding.dart';
import '../modules/terms_and_condition/views/terms_and_condition_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;
  static const ON_BOARDING = Routes.ONBOARDING;
  static const MY_HOME = Routes.HOME; // change back to HOME

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.AUTH_GATE,
      page: () => const AuthGateView(),
      binding: AuthGateBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.CART,
      page: () => const CartView(),
      binding: CartBinding(),
    ),
    GetPage(
      name: _Paths.ACCOUNT,
      page: () => const AccountView(),
      binding: AcountBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT_DETAILS,
      page: () => const ProductDetailsView(),
      binding: ProductDetailsBinding(),
    ),
    GetPage(
      name: _Paths.NAVIGATION_SCREEN,
      page: () => NavigationScreenView(),
      binding: NavigationScreenBinding(),
    ),
    GetPage(
      name: _Paths.CHECK_OUT,
      page: () => const CheckOutView(),
      binding: CheckOutBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT,
      page: () => const PaymentView(),
      binding: PaymentBinding(),
    ),
    GetPage(
      name: _Paths.SignUp,
      page: () => const SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.CATEGORY,
      page: () => const CategoryView(),
      binding: CategoryBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_HISTORY,
      page: () => const OrderHistoryView(),
      binding: OrderHistoryBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_SUCCESS,
      page: () => const OrderSuccessView(),
      binding: OrderSuccessBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_DETAILS,
      page: () => const OrderDetails(),
      binding: OrderHistoryBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE,
      page: () => const EditProfileView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: _Paths.NO_CONNECTION,
      page: () => const NoInternetScreen(),
      binding: AuthGateBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_PANEL,
      page: () => const AdminPanelView(),
      binding: AdminPanelBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_DASHBOARD,
      page: () => const AdminDashboardView(),
      binding: AdminDashboardBinding(),
    ),
    GetPage(
      name: _Paths.CUSTOMER_LIST,
      page: () => const CustomerListView(),
      binding: CustomerListBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_LIST,
      page: () => const OrderListView(),
      binding: OrderListBinding(),
    ),
    GetPage(
      name: _Paths.CATEGORY_LIST,
      page: () => const CategoryListView(),
      binding: CategoryListBinding(),
    ),
    GetPage(
      name: _Paths.BRAND_LIST,
      page: () => const BrandListView(),
      binding: BrandListBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT_LIST,
      page: () => const ProductListView(),
      binding: ProductListBinding(),
    ),
    GetPage(
      name: _Paths.BANNER_LIST,
      page: () => const BannerListView(),
      binding: BannerListBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT_LIST,
      page: () => const PaymentListView(),
      binding: PaymentListBinding(),
    ),
    GetPage(
      name: _Paths.ADD_PRODUCT,
      page: () => const AddProductView(),
      binding: ProductListBinding(),
    ),
    GetPage(
      name: _Paths.CHECK_OUT,
      page: () => const CheckOutView(),
      binding: CheckOutBinding(),
    ),
    GetPage(
      name: _Paths.ADD_CATEGORY,
      page: () => const AddCategoryView(),
      binding: CategoryListBinding(),
    ),
    GetPage(
      name: _Paths.ADD_BRAND,
      page: () => const AddbrandView(),
      binding: BrandListBinding(),
    ),
    GetPage(
      name: _Paths.ADD_PAYMENT,
      page: () => const AddpaymentView(),
      binding: PaymentListBinding(),
    ),
    GetPage(
      name: _Paths.ADD_BANNER,
      page: () => const AddbannerView(),
      binding: BannerListBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PRODUCTS,
      page: () => EditProductsView(),
      binding: EditProductsBinding(),
    ),
    GetPage(
      name: _Paths.ALL_PRODUCTS,
      page: () => const AllProductsView(),
      binding: AllProductsBinding(),
    ),
    GetPage(
      name: _Paths.POPULAR_PRODUCTS,
      page: () => const PopularProductsView(),
      binding: PopularProductsBinding(),
    ),
    GetPage(
      name: _Paths.SEND_NOTIFICATION,
      page: () => const SendNotificationView(),
      binding: SendNotificationBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: _Paths.SEND_SPECIFIC_NOTIFICATION,
      page: () => const SendSpecificNotificationView(),
      binding: SendSpecificNotificationBinding(),
    ),
    GetPage(
      name: _Paths.ALL_CATEGORY_PRODUCTS,
      page: () => const AllCategoryProductsView(),
      binding: AllCategoryProductsBinding(),
    ),
    GetPage(
      name: _Paths.ADD_PRIVACY,
      page: () => const AddPrivacyView(),
      binding: AddPrivacyBinding(),
    ),
    GetPage(
      name: _Paths.ADD_TERMS,
      page: () => const AddTermsView(),
      binding: AddTermsBinding(),
    ),
    GetPage(
      name: _Paths.PRIVACY_POLICY,
      page: () => const PrivacyPolicyView(),
      binding: PrivacyPolicyBinding(),
    ),
    GetPage(
      name: _Paths.TERMS_AND_CONDITION,
      page: () => const TermsAndConditionView(),
      binding: TermsAndConditionBinding(),
    ),
    GetPage(
      name: _Paths.FULL_SCREEN_IMAGE,
      page: () => const FullScreenImageView(),
      binding: FullScreenImageBinding(),
    ),
    GetPage(
      name: _Paths.DELIVERY_FEES_LIST,
      page: () => const DeliveryFeesListView(),
      binding: DeliveryFeesListBinding(),
    ),
    GetPage(
      name: _Paths.ADD_DELIVERY_FEE,
      page: () => const AddDeliveryFeeView(),
      binding: AddDeliveryFeeBinding(),
    ),
  ];
}
