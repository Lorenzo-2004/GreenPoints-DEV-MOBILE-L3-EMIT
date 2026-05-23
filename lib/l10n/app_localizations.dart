import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'GreenPoints'**
  String get appTitle;

  /// No description provided for @login_title.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get login_title;

  /// No description provided for @login_subtitle.
  ///
  /// In en, this message translates to:
  /// **'to'**
  String get login_subtitle;

  /// No description provided for @login_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get login_email;

  /// No description provided for @login_password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get login_password;

  /// No description provided for @login_forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get login_forgot_password;

  /// No description provided for @login_login_button.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get login_login_button;

  /// No description provided for @login_no_account.
  ///
  /// In en, this message translates to:
  /// **'New here?'**
  String get login_no_account;

  /// No description provided for @login_signup.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get login_signup;

  /// No description provided for @login_email_hint.
  ///
  /// In en, this message translates to:
  /// **'example@gmail.com'**
  String get login_email_hint;

  /// No description provided for @login_password_hint.
  ///
  /// In en, this message translates to:
  /// **'Your password'**
  String get login_password_hint;

  /// No description provided for @register_title.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get register_title;

  /// No description provided for @register_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Join the eco-responsible community'**
  String get register_subtitle;

  /// No description provided for @register_full_name.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get register_full_name;

  /// No description provided for @register_full_name_hint.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get register_full_name_hint;

  /// No description provided for @register_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get register_email;

  /// No description provided for @register_email_hint.
  ///
  /// In en, this message translates to:
  /// **'example@gmail.com'**
  String get register_email_hint;

  /// No description provided for @register_password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get register_password;

  /// No description provided for @register_password_hint.
  ///
  /// In en, this message translates to:
  /// **'Min. 6 characters'**
  String get register_password_hint;

  /// No description provided for @register_confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get register_confirm_password;

  /// No description provided for @register_confirm_password_hint.
  ///
  /// In en, this message translates to:
  /// **'Repeat password'**
  String get register_confirm_password_hint;

  /// No description provided for @register_register_button.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get register_register_button;

  /// No description provided for @register_have_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get register_have_account;

  /// No description provided for @register_login.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get register_login;

  /// No description provided for @register_or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get register_or;

  /// No description provided for @register_google.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get register_google;

  /// No description provided for @register_facebook.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get register_facebook;

  /// No description provided for @onboarding_title1.
  ///
  /// In en, this message translates to:
  /// **'Eco Actions'**
  String get onboarding_title1;

  /// No description provided for @onboarding_description1.
  ///
  /// In en, this message translates to:
  /// **'Discover and validate eco-friendly actions daily'**
  String get onboarding_description1;

  /// No description provided for @onboarding_title2.
  ///
  /// In en, this message translates to:
  /// **'Earn Points'**
  String get onboarding_title2;

  /// No description provided for @onboarding_description2.
  ///
  /// In en, this message translates to:
  /// **'Each validated action gives you points to accumulate'**
  String get onboarding_description2;

  /// No description provided for @onboarding_title3.
  ///
  /// In en, this message translates to:
  /// **'Challenges & Rewards'**
  String get onboarding_title3;

  /// No description provided for @onboarding_description3.
  ///
  /// In en, this message translates to:
  /// **'Take on challenges and unlock exclusive rewards'**
  String get onboarding_description3;

  /// No description provided for @onboarding_skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboarding_skip;

  /// No description provided for @onboarding_next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboarding_next;

  /// No description provided for @onboarding_start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get onboarding_start;

  /// No description provided for @home_greeting_morning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get home_greeting_morning;

  /// No description provided for @home_greeting_afternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get home_greeting_afternoon;

  /// No description provided for @home_greeting_evening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get home_greeting_evening;

  /// No description provided for @home_points.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get home_points;

  /// No description provided for @home_streak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get home_streak;

  /// No description provided for @home_weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get home_weekly;

  /// No description provided for @home_gestures_of_day.
  ///
  /// In en, this message translates to:
  /// **'Actions of the day'**
  String get home_gestures_of_day;

  /// No description provided for @home_completed.
  ///
  /// In en, this message translates to:
  /// **'completed'**
  String get home_completed;

  /// No description provided for @home_see_all.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get home_see_all;

  /// No description provided for @home_daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get home_daily;

  /// No description provided for @home_done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get home_done;

  /// No description provided for @home_level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get home_level;

  /// No description provided for @home_next_level.
  ///
  /// In en, this message translates to:
  /// **'next level'**
  String get home_next_level;

  /// No description provided for @home_max_level.
  ///
  /// In en, this message translates to:
  /// **'Maximum level reached'**
  String get home_max_level;

  /// No description provided for @home_quick_actions.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get home_quick_actions;

  /// No description provided for @home_share_progress.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get home_share_progress;

  /// No description provided for @home_gestures.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get home_gestures;

  /// No description provided for @home_challenges.
  ///
  /// In en, this message translates to:
  /// **'Challenges'**
  String get home_challenges;

  /// No description provided for @home_shop.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get home_shop;

  /// No description provided for @home_my_points.
  ///
  /// In en, this message translates to:
  /// **'My points'**
  String get home_my_points;

  /// No description provided for @home_total_points.
  ///
  /// In en, this message translates to:
  /// **'Total points'**
  String get home_total_points;

  /// No description provided for @gestures_title.
  ///
  /// In en, this message translates to:
  /// **'My Actions'**
  String get gestures_title;

  /// No description provided for @gestures_discover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get gestures_discover;

  /// No description provided for @gestures_search.
  ///
  /// In en, this message translates to:
  /// **'Search action'**
  String get gestures_search;

  /// No description provided for @gestures_search_hint.
  ///
  /// In en, this message translates to:
  /// **'Title, description...'**
  String get gestures_search_hint;

  /// No description provided for @gestures_clear_filter.
  ///
  /// In en, this message translates to:
  /// **'Clear filter'**
  String get gestures_clear_filter;

  /// No description provided for @gestures_no_gesture.
  ///
  /// In en, this message translates to:
  /// **'No action found'**
  String get gestures_no_gesture;

  /// No description provided for @gestures_try_other_filter.
  ///
  /// In en, this message translates to:
  /// **'Try another filter'**
  String get gestures_try_other_filter;

  /// No description provided for @gestures_points.
  ///
  /// In en, this message translates to:
  /// **'points'**
  String get gestures_points;

  /// No description provided for @gestures_categories_transport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get gestures_categories_transport;

  /// No description provided for @gestures_categories_alimentation.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get gestures_categories_alimentation;

  /// No description provided for @gestures_categories_energie.
  ///
  /// In en, this message translates to:
  /// **'Energy'**
  String get gestures_categories_energie;

  /// No description provided for @gestures_categories_dechets.
  ///
  /// In en, this message translates to:
  /// **'Waste'**
  String get gestures_categories_dechets;

  /// No description provided for @gestures_categories_eau.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get gestures_categories_eau;

  /// No description provided for @gestures_categories_nature.
  ///
  /// In en, this message translates to:
  /// **'Nature'**
  String get gestures_categories_nature;

  /// No description provided for @challenges_title.
  ///
  /// In en, this message translates to:
  /// **'My Challenges'**
  String get challenges_title;

  /// No description provided for @challenges_discover.
  ///
  /// In en, this message translates to:
  /// **'Challenges'**
  String get challenges_discover;

  /// No description provided for @challenges_search.
  ///
  /// In en, this message translates to:
  /// **'Search challenge'**
  String get challenges_search;

  /// No description provided for @challenges_search_hint.
  ///
  /// In en, this message translates to:
  /// **'Title, description...'**
  String get challenges_search_hint;

  /// No description provided for @challenges_clear_filter.
  ///
  /// In en, this message translates to:
  /// **'Clear filter'**
  String get challenges_clear_filter;

  /// No description provided for @challenges_active_only.
  ///
  /// In en, this message translates to:
  /// **'Active challenges'**
  String get challenges_active_only;

  /// No description provided for @challenges_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get challenges_all;

  /// No description provided for @challenges_daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get challenges_daily;

  /// No description provided for @challenges_weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get challenges_weekly;

  /// No description provided for @challenges_transport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get challenges_transport;

  /// No description provided for @challenges_food.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get challenges_food;

  /// No description provided for @challenges_days_left.
  ///
  /// In en, this message translates to:
  /// **'days left'**
  String get challenges_days_left;

  /// No description provided for @challenges_continue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get challenges_continue;

  /// No description provided for @challenges_completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get challenges_completed;

  /// No description provided for @challenges_no_challenge.
  ///
  /// In en, this message translates to:
  /// **'No challenge found'**
  String get challenges_no_challenge;

  /// No description provided for @challenges_try_other_filter.
  ///
  /// In en, this message translates to:
  /// **'Try another filter'**
  String get challenges_try_other_filter;

  /// No description provided for @challenges_details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get challenges_details;

  /// No description provided for @challenges_points_reward.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get challenges_points_reward;

  /// No description provided for @challenges_progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get challenges_progress;

  /// No description provided for @validation_title.
  ///
  /// In en, this message translates to:
  /// **'Validate'**
  String get validation_title;

  /// No description provided for @validation_subtitle.
  ///
  /// In en, this message translates to:
  /// **'An action'**
  String get validation_subtitle;

  /// No description provided for @validation_manual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get validation_manual;

  /// No description provided for @validation_qr_code.
  ///
  /// In en, this message translates to:
  /// **'QR Code'**
  String get validation_qr_code;

  /// No description provided for @validation_photo.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get validation_photo;

  /// No description provided for @validation_choose_gesture.
  ///
  /// In en, this message translates to:
  /// **'Choose an action'**
  String get validation_choose_gesture;

  /// No description provided for @validation_validate.
  ///
  /// In en, this message translates to:
  /// **'Validate action'**
  String get validation_validate;

  /// No description provided for @validation_validate_with_photo.
  ///
  /// In en, this message translates to:
  /// **'Validate with photo'**
  String get validation_validate_with_photo;

  /// No description provided for @validation_scan_qr.
  ///
  /// In en, this message translates to:
  /// **'Scan QR code'**
  String get validation_scan_qr;

  /// No description provided for @validation_scan_qr_hint.
  ///
  /// In en, this message translates to:
  /// **'Point at the action QR code'**
  String get validation_scan_qr_hint;

  /// No description provided for @validation_take_photo.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get validation_take_photo;

  /// No description provided for @validation_take_photo_hint.
  ///
  /// In en, this message translates to:
  /// **'Take a photo of your eco-friendly action'**
  String get validation_take_photo_hint;

  /// No description provided for @validation_camera_required.
  ///
  /// In en, this message translates to:
  /// **'Camera required'**
  String get validation_camera_required;

  /// No description provided for @validation_photo_taken.
  ///
  /// In en, this message translates to:
  /// **'Photo taken!'**
  String get validation_photo_taken;

  /// No description provided for @validation_retake.
  ///
  /// In en, this message translates to:
  /// **'Retake photo'**
  String get validation_retake;

  /// No description provided for @validation_gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get validation_gallery;

  /// No description provided for @validation_camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get validation_camera;

  /// No description provided for @validation_success.
  ///
  /// In en, this message translates to:
  /// **'Action validated!'**
  String get validation_success;

  /// No description provided for @validation_points_gained.
  ///
  /// In en, this message translates to:
  /// **'points earned!'**
  String get validation_points_gained;

  /// No description provided for @validation_continue.
  ///
  /// In en, this message translates to:
  /// **'Great, continue!'**
  String get validation_continue;

  /// No description provided for @profile_title.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get profile_title;

  /// No description provided for @profile_points.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get profile_points;

  /// No description provided for @profile_streak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get profile_streak;

  /// No description provided for @profile_week.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get profile_week;

  /// No description provided for @profile_my_stats.
  ///
  /// In en, this message translates to:
  /// **'My statistics'**
  String get profile_my_stats;

  /// No description provided for @profile_my_badges.
  ///
  /// In en, this message translates to:
  /// **'My badges'**
  String get profile_my_badges;

  /// No description provided for @profile_notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get profile_notifications;

  /// No description provided for @profile_points_history.
  ///
  /// In en, this message translates to:
  /// **'Points history'**
  String get profile_points_history;

  /// No description provided for @profile_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get profile_settings;

  /// No description provided for @profile_social.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get profile_social;

  /// No description provided for @profile_marketplace.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get profile_marketplace;

  /// No description provided for @profile_shop_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Exchange your points for rewards'**
  String get profile_shop_subtitle;

  /// No description provided for @profile_badges_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Discover your rewards'**
  String get profile_badges_subtitle;

  /// No description provided for @profile_notifications_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Alert history'**
  String get profile_notifications_subtitle;

  /// No description provided for @profile_history_subtitle.
  ///
  /// In en, this message translates to:
  /// **'View all your transactions'**
  String get profile_history_subtitle;

  /// No description provided for @profile_settings_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Customize the app'**
  String get profile_settings_subtitle;

  /// No description provided for @profile_social_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Ranking and friends'**
  String get profile_social_subtitle;

  /// No description provided for @profile_phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get profile_phone;

  /// No description provided for @profile_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profile_email;

  /// No description provided for @settings_title.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings_title;

  /// No description provided for @settings_preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get settings_preferences;

  /// No description provided for @settings_notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settings_notifications;

  /// No description provided for @settings_notifications_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Receive alerts and reminders'**
  String get settings_notifications_subtitle;

  /// No description provided for @settings_dark_mode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get settings_dark_mode;

  /// No description provided for @settings_dark_mode_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Dark theme for the app'**
  String get settings_dark_mode_subtitle;

  /// No description provided for @settings_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settings_language;

  /// No description provided for @settings_account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settings_account;

  /// No description provided for @settings_edit_profile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get settings_edit_profile;

  /// No description provided for @settings_edit_profile_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Personal information'**
  String get settings_edit_profile_subtitle;

  /// No description provided for @settings_my_badges.
  ///
  /// In en, this message translates to:
  /// **'My badges'**
  String get settings_my_badges;

  /// No description provided for @settings_my_badges_subtitle.
  ///
  /// In en, this message translates to:
  /// **'View unlocked badges'**
  String get settings_my_badges_subtitle;

  /// No description provided for @settings_points_history.
  ///
  /// In en, this message translates to:
  /// **'Points history'**
  String get settings_points_history;

  /// No description provided for @settings_points_history_subtitle.
  ///
  /// In en, this message translates to:
  /// **'View all your transactions'**
  String get settings_points_history_subtitle;

  /// No description provided for @settings_support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get settings_support;

  /// No description provided for @settings_help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get settings_help;

  /// No description provided for @settings_help_subtitle.
  ///
  /// In en, this message translates to:
  /// **'FAQ and assistance'**
  String get settings_help_subtitle;

  /// No description provided for @settings_share_app.
  ///
  /// In en, this message translates to:
  /// **'Share app'**
  String get settings_share_app;

  /// No description provided for @settings_share_app_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Invite your friends'**
  String get settings_share_app_subtitle;

  /// No description provided for @settings_rate_app.
  ///
  /// In en, this message translates to:
  /// **'Rate app'**
  String get settings_rate_app;

  /// No description provided for @settings_rate_app_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Leave a review'**
  String get settings_rate_app_subtitle;

  /// No description provided for @settings_logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get settings_logout;

  /// No description provided for @settings_logout_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out of account'**
  String get settings_logout_subtitle;

  /// No description provided for @settings_version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settings_version;

  /// No description provided for @settings_choose_language.
  ///
  /// In en, this message translates to:
  /// **'Choose language'**
  String get settings_choose_language;

  /// No description provided for @settings_french.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get settings_french;

  /// No description provided for @settings_english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settings_english;

  /// No description provided for @settings_spanish.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get settings_spanish;

  /// No description provided for @settings_logout_confirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get settings_logout_confirm;

  /// No description provided for @settings_yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get settings_yes;

  /// No description provided for @settings_no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get settings_no;

  /// No description provided for @badges_title.
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get badges_title;

  /// No description provided for @badges_unlocked.
  ///
  /// In en, this message translates to:
  /// **'Badges unlocked'**
  String get badges_unlocked;

  /// No description provided for @badges_unlocked_count.
  ///
  /// In en, this message translates to:
  /// **'Badges unlocked'**
  String get badges_unlocked_count;

  /// No description provided for @badges_locked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get badges_locked;

  /// No description provided for @badges_points_required.
  ///
  /// In en, this message translates to:
  /// **'pts required'**
  String get badges_points_required;

  /// No description provided for @badges_share_badge.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get badges_share_badge;

  /// No description provided for @notifications_title.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications_title;

  /// No description provided for @notifications_empty.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get notifications_empty;

  /// No description provided for @notifications_empty_hint.
  ///
  /// In en, this message translates to:
  /// **'Notifications will appear here'**
  String get notifications_empty_hint;

  /// No description provided for @notifications_mark_all_read.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get notifications_mark_all_read;

  /// No description provided for @notifications_now.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get notifications_now;

  /// No description provided for @notifications_minutes_ago.
  ///
  /// In en, this message translates to:
  /// **'%d min ago'**
  String get notifications_minutes_ago;

  /// No description provided for @notifications_hours_ago.
  ///
  /// In en, this message translates to:
  /// **'%d h ago'**
  String get notifications_hours_ago;

  /// No description provided for @notifications_yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get notifications_yesterday;

  /// No description provided for @notifications_days_ago.
  ///
  /// In en, this message translates to:
  /// **'%d days ago'**
  String get notifications_days_ago;

  /// No description provided for @notifications_gesture_validated.
  ///
  /// In en, this message translates to:
  /// **'Action validated!'**
  String get notifications_gesture_validated;

  /// No description provided for @notifications_points_gained_message.
  ///
  /// In en, this message translates to:
  /// **'You earned %d points for'**
  String get notifications_points_gained_message;

  /// No description provided for @notifications_new_badge.
  ///
  /// In en, this message translates to:
  /// **'New badge unlocked!'**
  String get notifications_new_badge;

  /// No description provided for @notifications_challenge_completed.
  ///
  /// In en, this message translates to:
  /// **'Challenge completed!'**
  String get notifications_challenge_completed;

  /// No description provided for @points_title.
  ///
  /// In en, this message translates to:
  /// **'Points history'**
  String get points_title;

  /// No description provided for @points_total.
  ///
  /// In en, this message translates to:
  /// **'Total points'**
  String get points_total;

  /// No description provided for @points_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get points_all;

  /// No description provided for @points_earned.
  ///
  /// In en, this message translates to:
  /// **'Earned'**
  String get points_earned;

  /// No description provided for @points_spent.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get points_spent;

  /// No description provided for @points_no_transaction.
  ///
  /// In en, this message translates to:
  /// **'No transactions'**
  String get points_no_transaction;

  /// No description provided for @points_no_transaction_hint.
  ///
  /// In en, this message translates to:
  /// **'Validate actions to earn points'**
  String get points_no_transaction_hint;

  /// No description provided for @points_today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get points_today;

  /// No description provided for @points_yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get points_yesterday;

  /// No description provided for @points_days_ago.
  ///
  /// In en, this message translates to:
  /// **'%d days ago'**
  String get points_days_ago;

  /// No description provided for @marketplace_title.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get marketplace_title;

  /// No description provided for @marketplace_my_points.
  ///
  /// In en, this message translates to:
  /// **'My points'**
  String get marketplace_my_points;

  /// No description provided for @marketplace_category_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get marketplace_category_all;

  /// No description provided for @marketplace_category_eco_products.
  ///
  /// In en, this message translates to:
  /// **'Eco products'**
  String get marketplace_category_eco_products;

  /// No description provided for @marketplace_category_plants.
  ///
  /// In en, this message translates to:
  /// **'Plants'**
  String get marketplace_category_plants;

  /// No description provided for @marketplace_category_accessories.
  ///
  /// In en, this message translates to:
  /// **'Accessories'**
  String get marketplace_category_accessories;

  /// No description provided for @marketplace_category_exclusive.
  ///
  /// In en, this message translates to:
  /// **'Exclusive'**
  String get marketplace_category_exclusive;

  /// No description provided for @marketplace_stock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get marketplace_stock;

  /// No description provided for @marketplace_out_of_stock.
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get marketplace_out_of_stock;

  /// No description provided for @marketplace_exchange.
  ///
  /// In en, this message translates to:
  /// **'Exchange'**
  String get marketplace_exchange;

  /// No description provided for @marketplace_insufficient_points.
  ///
  /// In en, this message translates to:
  /// **'Insufficient points'**
  String get marketplace_insufficient_points;

  /// No description provided for @marketplace_purchase_confirm.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get marketplace_purchase_confirm;

  /// No description provided for @marketplace_purchase_success.
  ///
  /// In en, this message translates to:
  /// **'has been purchased!'**
  String get marketplace_purchase_success;

  /// No description provided for @marketplace_empty.
  ///
  /// In en, this message translates to:
  /// **'No rewards'**
  String get marketplace_empty;

  /// No description provided for @marketplace_points.
  ///
  /// In en, this message translates to:
  /// **'pts'**
  String get marketplace_points;

  /// No description provided for @social_title.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get social_title;

  /// No description provided for @social_leaderboard.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get social_leaderboard;

  /// No description provided for @social_friends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get social_friends;

  /// No description provided for @social_your_rank.
  ///
  /// In en, this message translates to:
  /// **'Your rank'**
  String get social_your_rank;

  /// No description provided for @social_top.
  ///
  /// In en, this message translates to:
  /// **'Top'**
  String get social_top;

  /// No description provided for @social_no_friends.
  ///
  /// In en, this message translates to:
  /// **'No friends'**
  String get social_no_friends;

  /// No description provided for @social_no_friends_hint.
  ///
  /// In en, this message translates to:
  /// **'Add friends to follow them'**
  String get social_no_friends_hint;

  /// No description provided for @social_add_friend.
  ///
  /// In en, this message translates to:
  /// **'Add friend'**
  String get social_add_friend;

  /// No description provided for @social_friend_email.
  ///
  /// In en, this message translates to:
  /// **'Friend\'s email'**
  String get social_friend_email;

  /// No description provided for @social_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get social_cancel;

  /// No description provided for @social_add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get social_add;

  /// No description provided for @splash_version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get splash_version;

  /// No description provided for @common_close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get common_close;

  /// No description provided for @common_back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get common_back;

  /// No description provided for @common_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get common_save;

  /// No description provided for @common_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get common_edit;

  /// No description provided for @common_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get common_delete;

  /// No description provided for @common_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get common_confirm;

  /// No description provided for @common_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get common_loading;

  /// No description provided for @common_error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get common_error;

  /// No description provided for @common_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get common_retry;

  /// No description provided for @common_search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get common_search;

  /// No description provided for @common_filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get common_filter;

  /// No description provided for @common_share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get common_share;

  /// No description provided for @common_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get common_cancel;

  /// No description provided for @common_ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get common_ok;

  /// No description provided for @errors_connection.
  ///
  /// In en, this message translates to:
  /// **'Connection error'**
  String get errors_connection;

  /// No description provided for @errors_try_again.
  ///
  /// In en, this message translates to:
  /// **'Please try again'**
  String get errors_try_again;

  /// No description provided for @errors_unauthorized.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized'**
  String get errors_unauthorized;

  /// No description provided for @errors_not_found.
  ///
  /// In en, this message translates to:
  /// **'Not found'**
  String get errors_not_found;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fr': return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
