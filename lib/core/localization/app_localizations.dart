import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en'));
  }

  bool get isHindi => locale.languageCode == 'hi';

  static const List<Locale> supportedLocales = [Locale('en'), Locale('hi')];

  // App & Header
  String get appTitle => isHindi ? 'जॉब्ज़शाला' : 'Jobzshala';
  String get appSubtitle =>
      isHindi ? 'जीसीसी सत्यापित नौकरियां' : 'GCC Verified Jobs';
  String get jobMatchesTitle => isHindi ? 'नौकरी के मैच' : 'Job Matches';
  String get jobMatchesSubtitle => isHindi
      ? 'आपके अनुभव और कौशल पर आधारित गल्फ नौकरियां'
      : 'Gulf opportunities matched to your skills & profile';
  String get jobDetailsTitle => isHindi ? 'नौकरी का विवरण' : 'Job Details';
  String get applicationConfirmationTitle =>
      isHindi ? 'आवेदन सफल हुआ' : 'Application Submitted';

  // Offline banner & actions
  String get offlineBanner => isHindi
      ? 'आप ऑफ़लाइन हैं — सहेजी गई नौकरियां दिख रही हैं'
      : "You're offline — showing saved jobs";
  String get offlineApplyDisabled => isHindi
      ? 'ऑफ़लाइन होने पर आवेदन अक्षम हैं। सबमिट करने के लिए इंटरनेट से जुड़ें।'
      : 'Applications are disabled while offline. Reconnect to submit.';
  String get offlineNoSavedJobsTitle =>
      isHindi ? 'कोई सहेजी गई नौकरी उपलब्ध नहीं है' : 'No saved jobs available';
  String get offlineNoSavedJobsMessage => isHindi
      ? 'कृपया नौकरियों को लोड करने और देखने के लिए इंटरनेट से पुनः कनेक्ट करें।'
      : 'Please reconnect to the internet to discover and save verified jobs.';

  // Filter labels
  String get filterAll => isHindi ? 'सभी' : 'All';
  String get filterUae => isHindi ? 'यूएई' : 'UAE';
  String get filterSaudi => isHindi ? 'सऊदी अरब' : 'Saudi Arabia';
  String get filterQatar => isHindi ? 'कतर' : 'Qatar';

  // Empty state
  String get emptyStateTitle =>
      isHindi ? 'अभी कोई मेल नहीं है' : 'No matches yet';
  String get emptyStateMessage => isHindi
      ? 'चुने गए फ़िल्टर के लिए कोई नौकरी नहीं मिली। फ़िल्टर बदलें या बाद में देखें।'
      : 'No jobs found matching your current filter. Try selecting a different country or clear filters.';
  String get clearFilter => isHindi ? 'फ़िल्टर हटाएं' : 'Reset filter';
  String get showAllJobs =>
      isHindi ? 'सभी जीसीसी नौकरियां देखें' : 'Show All GCC Jobs';

  // States & Actions
  String get loadingJobs =>
      isHindi ? 'नौकरियां लोड हो रही हैं...' : 'Loading verified jobs...';
  String get loadingMore =>
      isHindi ? 'और नौकरियां लोड हो रही हैं...' : 'Loading more jobs...';
  String get errorLoadingJobs => isHindi
      ? 'नौकरियां लोड करने में त्रुटि हुई'
      : 'Unable to load jobs right now';
  String get serverError500 => isHindi
      ? 'सर्वर से संपर्क करने में समस्या हुई। कृपया पुनः प्रयास करें।'
      : 'Temporary interruption contacting GCC employer servers.';
  String get serverInterruptionTitle =>
      isHindi ? 'सर्वर में अस्थायी रुकावट' : 'Temporary Server Interruption';
  String get serverInterruptionMessage => isHindi
      ? 'खाड़ी देशों के नियोक्ता सिस्टम इस समय अपडेट हो रहे हैं। आपका प्रोफाइल और सहेजी गई नौकरियां पूरी तरह सुरक्षित हैं।'
      : 'Gulf employer networks are currently updating job listings. Your candidate profile and data are completely safe.';
  String get applicationRollbackTitle =>
      isHindi ? 'आवेदन भेजा नहीं जा सका' : 'Application Could Not Be Sent';
  String get applicationRollbackMessage => isHindi
      ? 'नियोक्ता सर्वर व्यस्त था। आपका आवेदन सुरक्षित रूप से रीसेट कर दिया गया है ताकि आप पुनः प्रयास कर सकें।'
      : 'Employer server had a momentary timeout. Your application status was safely reset so you can reapply.';
  String get retryApplication =>
      isHindi ? 'पुनः आवेदन करें' : 'Retry Application';
  String get showingCachedFallbackBanner => isHindi
      ? 'सर्वर व्यस्त है — सहेजी गई नौकरियां दिखाई जा रही हैं'
      : 'Server temporarily busy — showing saved verified jobs';
  String get retry => isHindi ? 'पुनः प्रयास करें' : 'Retry';
  String get refresh => isHindi ? 'रीफ्रेश करें' : 'Refresh';
  String get serverBusyBadge =>
      isHindi ? 'एचटीटीपी 500 • सर्वर व्यस्त' : 'HTTP 500 • SYSTEM BUSY';
  String get connectionErrorBadge =>
      isHindi ? 'नेटवर्क त्रुटि' : 'NETWORK ERROR';
  String get loadMoreError => isHindi
      ? 'और नौकरियां लोड करने में विफल। पुनः प्रयास करें।'
      : 'Failed to load more jobs. Tap to retry.';

  // Job Card Details
  String get salaryPerMonth => isHindi ? 'एईडी / माह' : 'AED / month';
  String get perMonth => isHindi ? '/माह' : '/mo';
  String get matchScore => isHindi ? 'मैच स्कोर' : 'Match';
  String get matchScoreLabel => isHindi ? 'मैच' : 'Match';
  String get matchPercentLabel => isHindi ? 'मैच' : 'Match';
  String get skillsLabel => isHindi ? 'कौशल' : 'Skills';
  String get viewDetails => isHindi ? 'विवरण देखें' : 'View details';
  String get jobsCountLabel => isHindi ? 'नौकरियां' : 'Jobs';
  String get verifiedEmployer => isHindi ? 'जीसीसी सत्यापित' : 'GCC Verified';

  // Applied Status
  String get appliedStatus => isHindi ? 'आवेदित' : 'Applied';
  String get applyNow => isHindi ? 'आवेदन करें' : 'Apply Now';
  String get applying => isHindi ? 'आवेदन भेजा जा रहा है...' : 'Applying...';
  String get alreadyApplied => isHindi
      ? 'आवेदन पहले ही किया जा चुका है'
      : 'Application already submitted';
  String get applicationFailed => isHindi
      ? 'आवेदन विफल रहा — स्थिति पुरानी स्थिति में वापस आ गई'
      : 'Application failed — state was rolled back';

  // Job Details Screen Sections
  String get whyYouMatch =>
      isHindi ? 'आप इस पद से क्यों मेल खाते हैं' : 'Why you match this role';
  String get description => isHindi ? 'कार्य का विवरण' : 'Job Description';
  String get requirements =>
      isHindi ? 'आवश्यक योग्यताएं व शर्तें' : 'Job Requirements';
  String get benefits => isHindi ? 'सुविधाएं व भत्ते' : 'Benefits & Perks';
  String get employerInfo => isHindi ? 'नियोक्ता' : 'Employer';
  String get location => isHindi ? 'स्थान' : 'Location';
  String get postedDate => isHindi ? 'प्रकाशित' : 'Posted';

  // Benefits
  String get benefitAccommodation => isHindi ? 'आवास' : 'Accommodation';
  String get benefitFood => isHindi ? 'भोजन' : 'Food';
  String get benefitVisa => isHindi ? 'वर्क वीजा' : 'Work Visa';
  String get benefitIncluded =>
      isHindi ? 'कंपनी द्वारा प्रदान' : 'Provided by employer';
  String get benefitNotIncluded => isHindi ? 'शामिल नहीं है' : 'Not included';

  // Confirmation Dialog
  String get confirmationHeading => isHindi
      ? 'आपका आवेदन सफलतापूर्वक जमा हो गया!'
      : 'Application Submitted Successfully!';
  String get confirmationSubtitle => isHindi
      ? 'आपका प्रोफाइल नियोक्ता को भेज दिया गया है। 48 घंटों में आपको संपर्क किया जाएगा।'
      : 'Your profile has been forwarded to the verified employer. You will receive an update within 48 hours.';
  String get applicationIdLabel =>
      isHindi ? 'आवेदन क्रमांक:' : 'Application Reference:';
  String get backToMatches =>
      isHindi ? 'अन्य नौकरियां देखें' : 'Explore more matches';
  String get done => isHindi ? 'पूर्ण' : 'Done';
  String get refCodeCopied =>
      isHindi ? 'संदर्भ कोड कॉपी किया गया:' : 'Reference code copied:';
  String get copyLabel => isHindi ? 'कॉपी' : 'Copy';
  String get whatHappensNext =>
      isHindi ? 'आगे क्या होगा?' : 'What happens next?';
  String get step1Title => isHindi ? 'आवेदन भेजा गया' : 'Application Sent';
  String get step1Subtitle => isHindi
      ? 'नियोक्ता को तुरंत सूचित किया गया'
      : 'Employer notified immediately';
  String get step2Title =>
      isHindi ? 'प्रोफाइल समीक्षा (24-48 घंटे)' : 'Profile Review (24-48 hrs)';
  String get step2Subtitle => isHindi
      ? 'नियोक्ता आपके अनुभव की जांच करेगा'
      : 'Employer verifies your experience';
  String get step3Title => isHindi ? 'सीधा संपर्क' : 'Direct Contact';
  String get step3Subtitle => isHindi
      ? 'साक्षात्कार या वीज़ा सहायता हेतु संपर्क'
      : 'Interview call & visa paperwork assistance';

  // Simulation controls (for reviewer convenience)
  String get networkSimulation => isHindi ? 'नेटवर्क स्थिति' : 'Network Mode';
  String get simulationOnline => isHindi ? 'ऑनलाइन' : 'Online';
  String get simulationOffline =>
      isHindi ? 'ऑफ़लाइन सिम्युलेट' : 'Offline Mode';
  String get toggleNetworkTooltip => isHindi
      ? 'परीक्षक के लिए: ऑनलाइन/ऑफ़लाइन मोड बदलें'
      : 'Demo control: Toggle online / offline simulation';
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'hi'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
