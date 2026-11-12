/// Translation keys. Every user-facing string goes through one of these and
/// `.tr` / `.trParams`. `test/core/translations_test.dart` checks that each
/// key below exists in every language.
abstract final class AppStrings {
  // App
  static const String appName = 'app_name';
  static const String appTagline = 'app_tagline';

  // Common
  static const String ok = 'OK';
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';
  static const String save = 'Save';
  static const String saving = 'Saving';
  static const String remove = 'Remove';
  static const String delete = 'Delete';
  static const String close = 'Close';
  static const String retry = 'Retry';
  static const String edit = 'Edit';
  static const String view = 'View';
  static const String error = 'Error';
  static const String success = 'Success';
  static const String loading = 'Loading';
  static const String somethingWentWrong = 'Something_went_wrong';
  static const String checkConnection = 'Check_connection';
  static const String optional = 'Optional';

  // Navigation
  static const String stores = 'Stores';
  static const String requests = 'Requests';
  static const String profile = 'Profile';
  static const String settings = 'Settings';

  // Auth
  static const String login = 'Login';
  static const String signUp = 'Sign_Up';
  static const String welcomeBack = 'Welcome_Back';
  static const String signInToContinue = 'Sign_in_to_continue';
  static const String createAccount = 'Create_Account';
  static const String signUpToGetStarted = 'Sign_up_to_get_started';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm_Password';
  static const String username = 'Username';
  static const String phoneNumber = 'Phone_number';
  static const String forgotPassword = 'Forgot_Password';
  static const String resetPassword = 'Reset_Password';
  static const String resetPasswordInstruction = 'Reset_Password_Instruction';
  static const String sendResetLink = 'Send_Reset_Link';
  static const String resetEmailSent = 'Reset_Email_Sent';
  static const String dontHaveAccount = 'Dont_have_account';
  static const String alreadyHaveAccount = 'Already_have_account';
  static const String pleaseEnterEmail = 'Please_enter_email';
  static const String pleaseEnterValidEmail = 'Please_enter_valid_email';
  static const String pleaseEnterPassword = 'Please_enter_password';
  static const String passwordTooShort = 'Password_too_short';
  static const String passwordsDontMatch = 'Passwords_dont_match';
  static const String pleaseEnterUsername = 'Please_enter_username';
  static const String failedToSignIn = 'Failed_to_sign_in';
  static const String failedToSignUp = 'Failed_to_sign_up';
  static const String logout = 'Logout';
  static const String logoutConfirmTitle = 'Logout_confirm_title';
  static const String logoutConfirmMessage = 'Logout_confirm_message';

  // Store directory
  static const String homeEyebrow = 'Home_eyebrow';
  static const String helloName = 'Hello_name';
  static const String findAStore = 'Find_a_store';
  static const String searchStores = 'Search_stores';
  static const String storesCount = 'Stores_count';
  static const String noStoresTitle = 'No_stores_title';
  static const String noStoresMessage = 'No_stores_message';
  static const String noSearchResults = 'No_search_results';
  static const String yourStore = 'Your_store';

  // Store details
  static const String store = 'Store';
  static const String aboutStore = 'About_store';
  static const String noDescription = 'No_description';
  static const String owner = 'Owner';
  static const String call = 'Call';
  static const String contactStore = 'Contact_Store';
  static const String makeOrder = 'Make_order';
  static const String deleteStore = 'Delete_store';
  static const String deleteStoreMessage = 'Delete_store_message';
  static const String storeDeleted = 'Store_deleted';

  // Order builder
  static const String newOrder = 'New_order';
  static const String typeOfGlasses = 'Type_of_glasses';
  static const String prescription = 'Prescription';
  static const String sphere = 'Sphere';
  static const String cylinder = 'Cylinder';
  static const String sph = 'SPH';
  static const String cyl = 'CYL';
  static const String quantity = 'Quantity';
  static const String addGlassesToList = 'Add_glasses_to_list';
  static const String orderItems = 'Order_items';
  static const String noGlassesAddedYet = 'No_glasses_added_yet';
  static const String emptyOrderHint = 'Empty_order_hint';
  static const String submitOrder = 'Submit_selection';
  static const String orderSummary = 'Order_summary';
  static const String requestSentSuccessfully = 'Request_sent_successfully';
  static const String quantityCannotBeLessThan1 = 'Quantity_cannot_be_less_than_1';

  // Requests
  static const String tabSent = 'Tab_sent';
  static const String tabReceived = 'Tab_received';
  static const String filterAll = 'Filter_all';
  static const String status = 'Status';
  static const String pending = 'Pending';
  static const String done = 'Done';
  static const String noRequestsTitle = 'No_requests_title';
  static const String noSentRequestsMessage = 'No_sent_requests_message';
  static const String noReceivedRequestsMessage = 'No_received_requests_message';
  static const String toName = 'To_name';
  static const String fromName = 'From_name';
  static const String lensesCount = 'Lenses_count';

  // Request details
  static const String requestDetails = 'Request_details';
  static const String requestedOn = 'Requested_on';
  static const String completedOn = 'Completed_on';
  static const String orderedBy = 'Ordered_by';
  static const String orderedLenses = 'Ordered_lenses';
  static const String supplied = 'Supplied';
  static const String notSupplied = 'Not_supplied';
  static const String storeNote = 'Store_note';
  static const String processRequest = 'Process_request';
  static const String printTicket = 'Print_ticket';

  // Handle request
  static const String handleRequest = 'Handle_request';
  static const String handleRequestHint = 'Handle_request_hint';
  static const String selectAll = 'Select_all';
  static const String notes = 'Notes';
  static const String enterNotesHere = 'Enter_notes_here';
  static const String completeRequest = 'Complete_request';
  static const String readyCount = 'Ready_count';
  static const String requestCompleted = 'Request_completed';

  // Printing
  static const String printers = 'Printers';
  static const String scan = 'Scan';
  static const String scanning = 'Scanning';
  static const String noPrintersTitle = 'No_printers_title';
  static const String noPrintersMessage = 'No_printers_message';
  static const String ticketPreview = 'Ticket_preview';
  static const String printedSuccessfully = 'Printed_successfully';
  static const String connected = 'Connected';
  static const String tapToPrint = 'Tap_to_print';
  static const String receiptClient = 'Receipt_client';
  static const String receiptStoreOwner = 'Receipt_store_owner';
  static const String receiptCreated = 'Receipt_created';
  static const String receiptCompleted = 'Receipt_completed';
  static const String receiptLenses = 'Receipt_lenses';
  static const String receiptThanks = 'Receipt_thanks';

  // Profile
  static const String personalInfo = 'Personal_info';
  static const String storeInfo = 'Store_info';
  static const String viewStore = 'View_store';
  static const String noStoreYet = 'No_store_yet';
  static const String createStoreHint = 'Create_store_hint';
  static const String storeOwnerBadge = 'Store_owner_badge';
  static const String opticianBadge = 'Optician_badge';
  static const String accountRestricted = 'Account_restricted';
  static const String accountRestrictedMessage = 'Account_restricted_message';
  static const String userNotFound = 'User_not_found';

  // Edit profile
  static const String editProfile = 'Edit_profile_info';
  static const String name = 'Name';
  static const String pleaseEnterName = 'Please_enter_your_name';
  static const String pleaseEnterPhoneNumber = 'Please_enter_your_phone_number';
  static const String updateProfileSuccess = 'Profile_information_updated_successfully';
  static const String updateProfileError = 'Update_profile_error';
  static const String discardChanges = 'Discard_changes';
  static const String discardChangesMessage = 'Discard_changes_message';
  static const String takePhoto = 'Take_photo';
  static const String chooseFromGallery = 'Choose_from_gallery';

  // Create store
  static const String createStore = 'Create_store';
  static const String createNewStore = 'Create_anew_store';
  static const String storeName = 'Store_name';
  static const String storeAddress = 'Store_address';
  static const String storeDescription = 'Store_description';
  static const String images = 'Images';
  static const String addImages = 'Add_images';
  static const String storePhotosHint = 'Store_photos_hint';
  static const String creatingStore = 'Creating_store';
  static const String storeCreatedSuccessfully = 'Your_store_has_been_created_successfully';
  static const String pleaseEnterStoreName = 'Please_enter_astore_name';
  static const String pleaseEnterStoreAddress = 'Please_enter_astore_address';
  static const String pleaseEnterStoreDescription = 'Please_enter_astore_description';

  // Settings
  static const String appearance = 'Appearance';
  static const String theme = 'Theme';
  static const String themeSystem = 'Theme_system';
  static const String themeLight = 'Theme_light';
  static const String themeDark = 'Theme_dark';
  static const String language = 'Language';
  static const String changeLanguage = 'Change_language';
  static const String general = 'General';
  static const String support = 'Support';
  static const String help = 'Help';
  static const String about = 'About';
  static const String version = 'Version';
  static const String signedInAs = 'Signed_in_as';

  // About
  static const String info = 'Infos';
  static const String needAssistance = 'Need_assistance';
  static const String helpDescription = 'Help_description';
  static const String contactOnFacebook = 'Contact_on_facebook';
  static const String aboutCompanyDescription = 'About_company_description';
  static const String ourValues = 'Our_values';
  static const String ourValuesDescription = 'Our_values_description';
  static const String ourStrength = 'Our_strength';
  static const String ourStrengthDescription = 'Our_strength_description';
  static const String ourStrengthItems = 'Our_strength_items';
  static const String ourVision = 'Our_vision';
  static const String ourVisionDescription = 'Our_vision_description';
  static const String onlineStore = 'Online_store';
  static const String contactUs = 'Contact_us';

  // Realtime alerts
  static const String newOrderTitle = 'New_order_title';
  static const String newOrderMessage = 'New_order_message';
  static const String requestDoneTitle = 'Request_done_title';
  static const String requestDoneMessage = 'Request_done_message';
}
