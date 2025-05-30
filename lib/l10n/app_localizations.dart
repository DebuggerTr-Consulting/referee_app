import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_lv.dart';
import 'app_localizations_tr.dart';

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
    Locale('lv'),
    Locale('tr')
  ];

  /// The main text displayed on the home screen.
  ///
  /// In en, this message translates to:
  /// **'Home Content'**
  String get homeContent;

  /// Text for the calendar section or tab.
  ///
  /// In en, this message translates to:
  /// **'Calendar View'**
  String get calendarContent;

  /// Text for the search screen or functionality.
  ///
  /// In en, this message translates to:
  /// **'Search View'**
  String get searchContent;

  /// Main title or content text for the profile page.
  ///
  /// In en, this message translates to:
  /// **'Profile Page'**
  String get profileContent;

  /// Label for the settings screen.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Button or screen title to edit user profile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// Label for signing the user out.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get logout;

  /// Confirmation or log text indicating edit profile button was clicked.
  ///
  /// In en, this message translates to:
  /// **'Edit profile clicked'**
  String get profileEditClicked;

  /// Greeting text for the user.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcome;

  /// Placeholder or label text for the app’s main content section.
  ///
  /// In en, this message translates to:
  /// **'Main Content Goes Here'**
  String get mainContent;

  /// Label for the login button or screen.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Label for the sign-up screen or button.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// Label for the email input field.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Label for the password input field.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Prompt for users to sign up if they don’t have an account.
  ///
  /// In en, this message translates to:
  /// **'Need an account? Sign Up'**
  String get needAccount;

  /// Prompt for users to sign in if they already have an account.
  ///
  /// In en, this message translates to:
  /// **'Have an account? Sign In'**
  String get haveAccount;

  /// Button text for signing in with Google.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// Button text for signing in with Apple.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Apple'**
  String get signInWithApple;

  /// Navigation tab or label for the home screen.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Navigation tab or label for the calendar screen.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// Navigation tab or label for the search screen.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Navigation tab or label for the profile screen.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Label for the user's birth date field.
  ///
  /// In en, this message translates to:
  /// **'Birth Date'**
  String get birthDate;

  /// Label for the date the user started refereeing.
  ///
  /// In en, this message translates to:
  /// **'Start Date of Refereeing'**
  String get refereeStartDate;

  /// Label for displaying user's city and country.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// Section title for leagues the user participated in.
  ///
  /// In en, this message translates to:
  /// **'Leagues Participated'**
  String get leaguesParticipated;

  /// Label indicating number of matches participated.
  ///
  /// In en, this message translates to:
  /// **'matches'**
  String get matches;

  /// Button text to save form or changes.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Validation error text for empty fields.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get requiredField;

  /// Label for the full name input field.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get name;

  /// Label for city input field.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// Label for country input field.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// Confirmation message shown before logging out.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get logoutConfirm;

  /// Button text to cancel an action.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Button text to confirm an action.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get confirm;

  /// Label for gender selection field.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// Gender option: Male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// Gender option: Female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// Gender option: Other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// Localized gender label for male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// Localized gender label for female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// Localized gender label for other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get genderOthers;

  /// Title text for verifying phone number.
  ///
  /// In en, this message translates to:
  /// **'Verify Phone Number'**
  String get verifyPhone;

  /// Instruction to enter the SMS verification code.
  ///
  /// In en, this message translates to:
  /// **'Please enter the SMS code received'**
  String get enterSmsCode;

  /// Button label to verify phone number.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// Success message for phone number verification.
  ///
  /// In en, this message translates to:
  /// **'Phone number verified successfully'**
  String get verificationSuccess;

  /// Error message for failed phone verification.
  ///
  /// In en, this message translates to:
  /// **'Phone verification failed. Please try again.'**
  String get verificationFailed;

  /// Label for the phone number input field.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// Error message when location permission is not granted.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied. Phone code could not be set automatically.'**
  String get locationPermissionDenied;

  /// Fallback message when location data is unavailable.
  ///
  /// In en, this message translates to:
  /// **'Could not retrieve location. Default phone code was set.'**
  String get locationErrorFallback;

  /// Displayed when no phone number is available.
  ///
  /// In en, this message translates to:
  /// **'No phone number'**
  String get noPhone;

  /// Prompt for the user to enter a verification code.
  ///
  /// In en, this message translates to:
  /// **'Enter the verification code'**
  String get enterCode;

  /// Label for the SMS verification code input field.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get smsCode;

  /// Button label for editing content.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Dialog title warning the user.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// Prompt shown when user navigates away with unsaved changes.
  ///
  /// In en, this message translates to:
  /// **'Do you want to leave without saving changes?'**
  String get unsavedChanges;

  /// Button text to discard unsaved changes.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'lv', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'lv': return AppLocalizationsLv();
    case 'tr': return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
