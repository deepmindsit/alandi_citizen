// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:alandi/config/exported_path.dart' as _i454;
import 'package:alandi/config/register_module.dart' as _i848;
import 'package:alandi/view/about_us/controller/about_controller.dart' as _i218;
import 'package:alandi/view/complaint/controller/complaint_controller.dart'
    as _i239;
import 'package:alandi/view/complaint/controller/get_summary.dart' as _i684;
import 'package:alandi/view/home_view/controller/add_complaint_controller.dart'
    as _i278;
import 'package:alandi/view/home_view/controller/delete_account_controller.dart'
    as _i532;
import 'package:alandi/view/home_view/controller/get_notification.dart'
    as _i712;
import 'package:alandi/view/home_view/controller/home_controller.dart' as _i541;
import 'package:alandi/view/links/controller/link_controller.dart' as _i467;
import 'package:alandi/view/navigator/controller/navigator_controller.dart'
    as _i212;
import 'package:alandi/view/onboarding/controller/onboarding_controller.dart'
    as _i1058;
import 'package:alandi/view/profile/controller/profile_controller.dart'
    as _i742;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i454.LanguageController>(
        () => registerModule.languageController);
    gh.lazySingleton<_i218.GetAbout>(() => _i218.GetAbout());
    gh.lazySingleton<_i239.ComplaintController>(
        () => _i239.ComplaintController());
    gh.lazySingleton<_i684.GetSummary>(() => _i684.GetSummary());
    gh.lazySingleton<_i278.AddComplaintsController>(
        () => _i278.AddComplaintsController());
    gh.lazySingleton<_i532.DeleteAccountController>(
        () => _i532.DeleteAccountController());
    gh.lazySingleton<_i712.GetNotification>(() => _i712.GetNotification());
    gh.lazySingleton<_i541.HomeController>(() => _i541.HomeController());
    gh.lazySingleton<_i467.GetLinks>(() => _i467.GetLinks());
    gh.lazySingleton<_i212.BottomNavigationPageController>(
        () => _i212.BottomNavigationPageController());
    gh.lazySingleton<_i1058.OnboardingController>(
        () => _i1058.OnboardingController());
    gh.lazySingleton<_i742.ProfileController>(() => _i742.ProfileController());
    return this;
  }
}

class _$RegisterModule extends _i848.RegisterModule {}
