import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>
    with TickerProviderStateMixin {
  // Separate form keys for each page to maintain form state
  final _formKeyPage0 = GlobalKey<FormState>();
  final _formKeyPage1 = GlobalKey<FormState>();
  final _formKeyPage2 = GlobalKey<FormState>();
  final _formKeyPage3 = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final _pageController = PageController();
  
  // Current page index
  int _currentPage = 0;
  static const int _totalPages = 5; // 4 form sections + 1 final page
  
  // Animation controllers
  late AnimationController _fadeController;
  late List<AnimationController> _sectionControllers;
  late List<Animation<Offset>> _slideAnimations;
  late List<Animation<double>> _fadeAnimations;

  // Form controllers
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthdateController = TextEditingController();
  final _houseNoController = TextEditingController();
  final _regionController = TextEditingController();
  final _cityController = TextEditingController();
  final _streetController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _securityQuestionController = TextEditingController();
  final _securityAnswerController = TextEditingController();
  final _emergencyNameController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();

  // State variables
  String? _selectedGender;
  String? _selectedIdType;
  String? _selectedUserRole;
  String? _selectedCommunicationMethod;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _termsAccepted = false;
  bool _privacyAccepted = false;
  bool _dataConsentAccepted = false;
  XFile? _validIdFile;
  XFile? _selfieFile;
  double _passwordStrength = 0.0;

  @override
  void initState() {
    super.initState();
    
    // Main fade controller
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Section animation controllers (4 sections)
    _sectionControllers = List.generate(
      4,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      ),
    );

    // Slide and fade animations for each section
    _slideAnimations = _sectionControllers.map((controller) {
      return Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutCubic,
      ));
    }).toList();

    _fadeAnimations = _sectionControllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ));
    }).toList();

    // Start animations
    _fadeController.forward();
    // Start animation for first section
    if (_sectionControllers.isNotEmpty) {
      _sectionControllers[0].forward();
    }

    // Listen to password changes for strength indicator
    _passwordController.addListener(_updatePasswordStrength);
  }

  void _updatePasswordStrength() {
    final password = _passwordController.text;
    double strength = 0.0;
    
    if (password.length >= 8) strength += 0.25;
    if (password.contains(RegExp(r'[a-z]'))) strength += 0.25;
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.25;
    if (password.contains(RegExp(r'[0-9]')) && password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.25;
    
    setState(() {
      _passwordStrength = strength;
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    for (var controller in _sectionControllers) {
      controller.dispose();
    }
    _scrollController.dispose();
    _pageController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _birthdateController.dispose();
    _houseNoController.dispose();
    _regionController.dispose();
    _cityController.dispose();
    _streetController.dispose();
    _zipCodeController.dispose();
    _idNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _securityQuestionController.dispose();
    _securityAnswerController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source, bool isSelfie) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        if (isSelfie) {
          _selfieFile = image;
        } else {
          _validIdFile = image;
        }
      });
    }
  }

  void _showImagePicker(BuildContext context, bool isSelfie) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery, isSelfie);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera, isSelfie);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: FadeTransition(
        opacity: _fadeController,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                    // Trigger animation for current section if it's a form page
                    if (index < 4 && _sectionControllers[index].status != AnimationStatus.completed) {
                      _sectionControllers[index].forward();
                    }
                  },
                  children: [
                    _buildPage0(), // Personal Information
                    _buildPage1(), // Address Details
                    _buildPage2(), // Account Verification
                    _buildPage3(), // Security Setup
                    _buildPage4(), // Final page with buttons
                  ],
                ),
              ),
              _buildNavigationButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage0() {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Form(
        key: _formKeyPage0,
        child: _buildSection(
          index: 0,
          title: 'Personal Information',
          children: [
            _buildTextField(
              controller: _fullNameController,
              label: 'Full Name',
              icon: Icons.person_outline,
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 18),
            _buildTextField(
              controller: _phoneController,
              label: 'Phone Number',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 18),
            _buildTextField(
              controller: _birthdateController,
              label: 'Birthdate',
              icon: Icons.calendar_today_outlined,
              readOnly: true,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
                  firstDate: DateTime(1950),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  _birthdateController.text = '${date.day}/${date.month}/${date.year}';
                }
              },
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 18),
            _buildDropdown(
              label: 'Gender',
              icon: Icons.person,
              value: _selectedGender,
              items: const ['Male', 'Female', 'Other', 'Prefer not to say'],
              onChanged: (value) => setState(() => _selectedGender = value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage1() {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Form(
        key: _formKeyPage1,
        child: _buildSection(
          index: 1,
          title: 'Address Details',
          children: [
            _buildTextField(
              controller: _houseNoController,
              label: 'House No./Street/Purok/Zone',
              icon: Icons.home_outlined,
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 18),
            _buildTextField(
              controller: _regionController,
              label: 'Region / Province',
              icon: Icons.location_on_outlined,
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 18),
            _buildTextField(
              controller: _cityController,
              label: 'City / Municipality',
              icon: Icons.location_city_outlined,
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 18),
            _buildTextField(
              controller: _streetController,
              label: 'Street / Barangay',
              icon: Icons.place_outlined,
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 18),
            _buildTextField(
              controller: _zipCodeController,
              label: 'ZIP Code',
              icon: Icons.markunread_mailbox_outlined,
              keyboardType: TextInputType.number,
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage2() {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Form(
        key: _formKeyPage2,
        child: _buildSection(
          index: 2,
          title: 'Account Verification',
          children: [
            _buildDropdown(
              label: 'ID Type',
              icon: Icons.badge_outlined,
              value: _selectedIdType,
              items: const [
                'Student ID',
                'Philippine ID',
                'Driver\'s License',
                'Passport',
                'SSS',
                'UMID',
                'Voter\'s ID',
                'Other Government ID',
              ],
              onChanged: (value) => setState(() => _selectedIdType = value),
            ),
            const SizedBox(height: 18),
            _buildTextField(
              controller: _idNumberController,
              label: 'ID Number',
              icon: Icons.numbers_outlined,
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 18),
            _buildFileUpload(
              label: 'Upload Valid ID',
              icon: Icons.upload_file,
              file: _validIdFile,
              onTap: () => _showImagePicker(context, false),
            ),
            const SizedBox(height: 18),
            _buildFileUpload(
              label: 'Upload Selfie with ID',
              icon: Icons.camera_alt_outlined,
              file: _selfieFile,
              onTap: () => _showImagePicker(context, true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage3() {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Form(
        key: _formKeyPage3,
        child: _buildSection(
          index: 3,
          title: 'Security Setup',
          children: [
            _buildPasswordField(
              controller: _passwordController,
              label: 'Password',
              obscureText: _obscurePassword,
              onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Required';
                if (value!.length < 8) return 'Minimum 8 characters';
                return null;
              },
            ),
            if (_passwordController.text.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildPasswordStrengthIndicator(),
            ],
            const SizedBox(height: 18),
            _buildPasswordField(
              controller: _confirmPasswordController,
              label: 'Confirm Password',
              obscureText: _obscureConfirmPassword,
              onToggle: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
              validator: (value) {
                if (value != _passwordController.text) return 'Passwords do not match';
                return null;
              },
            ),
            const SizedBox(height: 18),
            _buildDropdown(
              label: 'Security Question (Optional)',
              icon: Icons.help_outline,
              value: _securityQuestionController.text.isEmpty ? null : _securityQuestionController.text,
              items: const [
                'What was your childhood nickname?',
                'What city were you born in?',
                'What was the name of your first pet?',
                'What is your mother\'s maiden name?',
              ],
              onChanged: (value) => _securityQuestionController.text = value ?? '',
            ),
            const SizedBox(height: 18),
            _buildTextField(
              controller: _securityAnswerController,
              label: 'Security Answer',
              icon: Icons.key_outlined,
              validator: (value) {
                final hasQuestion = _securityQuestionController.text.isNotEmpty;
                if (hasQuestion && (value?.isEmpty ?? true)) {
                  return 'Required when a security question is selected';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),
            _buildDropdown(
              label: 'User Role / Type',
              icon: Icons.people_outline,
              value: _selectedUserRole,
              items: const [
                'Resident',
                'Volunteer',
                'Barangay Official',
                'CERV Member',
              ],
              onChanged: (value) => setState(() => _selectedUserRole = value),
            ),
            const SizedBox(height: 18),
            _buildTextField(
              controller: _emergencyNameController,
              label: 'Emergency Contact Name',
              icon: Icons.contact_emergency_outlined,
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 18),
            _buildTextField(
              controller: _emergencyPhoneController,
              label: 'Emergency Contact Number',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 18),
            _buildDropdown(
              label: 'Preferred Communication Method',
              icon: Icons.notifications_outlined,
              value: _selectedCommunicationMethod,
              items: const ['SMS', 'Email', 'App Notifications'],
              onChanged: (value) => setState(() => _selectedCommunicationMethod = value),
            ),
            const SizedBox(height: 24),
            _buildCheckbox(
              value: _termsAccepted,
              label: 'I agree to the Terms & Conditions',
              onChanged: (value) => setState(() => _termsAccepted = value ?? false),
            ),
            const SizedBox(height: 12),
            _buildCheckbox(
              value: _privacyAccepted,
              label: 'I have read the Privacy Policy',
              onChanged: (value) => setState(() => _privacyAccepted = value ?? false),
            ),
            const SizedBox(height: 12),
            _buildCheckbox(
              value: _dataConsentAccepted,
              label: 'I consent to the use of my personal data for verification purposes',
              onChanged: (value) => setState(() => _dataConsentAccepted = value ?? false),
            ),
            const SizedBox(height: 32),
            _buildDivider(),
            const SizedBox(height: 24),
            _buildGoogleButton(),
            const SizedBox(height: 24),
            _buildLoginLink(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildPage4() {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 32),
          _buildCreateAccountButton(),
          const SizedBox(height: 24),
          _buildDivider(),
          const SizedBox(height: 24),
          _buildGoogleButton(),
          const SizedBox(height: 24),
          _buildLoginLink(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    // On Security page (page 3), show Previous and Create Account buttons
    if (_currentPage == 3) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'Previous',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Validate all forms and check terms
                  final page0Valid = _formKeyPage0.currentState?.validate() ?? false;
                  final page1Valid = _formKeyPage1.currentState?.validate() ?? false;
                  final page2Valid = _formKeyPage2.currentState?.validate() ?? false;
                  final page3Valid = _formKeyPage3.currentState?.validate() ?? false;
                  
                  if (page0Valid &&
                      page1Valid &&
                      page2Valid &&
                      page3Valid &&
                      _termsAccepted &&
                      _privacyAccepted &&
                      _dataConsentAccepted) {
                    // Handle signup
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Account created successfully!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all required fields and accept terms')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: const Color(0xFF5C4DE8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'Create Account',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    
    // For other pages, show Previous and Next buttons
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentPage > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'Previous',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ),
          if (_currentPage > 0) const SizedBox(width: 12),
          if (_currentPage < _totalPages - 1)
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Validate the current page's form before proceeding
                  bool isValid = true;
                  switch (_currentPage) {
                    case 0:
                      isValid = _formKeyPage0.currentState?.validate() ?? false;
                      break;
                    case 1:
                      isValid = _formKeyPage1.currentState?.validate() ?? false;
                      break;
                    case 2:
                      isValid = _formKeyPage2.currentState?.validate() ?? false;
                      break;
                  }
                  
                  if (isValid) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: const Color(0xFF5C4DE8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'Next',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Column(
        children: [
          Text(
            'Create Account',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF5C4DE8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Join CERV and help build safer communities',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          _buildProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final steps = [
      {'number': 1, 'label': 'Personal', 'icon': Icons.person_outline},
      {'number': 2, 'label': 'Address', 'icon': Icons.home_outlined},
      {'number': 3, 'label': 'Verification', 'icon': Icons.verified_outlined},
      {'number': 4, 'label': 'Security', 'icon': Icons.lock_outline},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        final isActive = _currentPage == index;
        final isCompleted = _currentPage > index || _currentPage == 4; // All completed on final page
        
        return Expanded(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isActive || isCompleted
                          ? const Color(0xFF5C4DE8)
                          : Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: isCompleted && !isActive
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 18,
                            )
                          : Text(
                              '${step['number']}',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isActive || isCompleted
                                    ? Colors.white
                                    : Colors.grey[600],
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                step['label'] as String,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: isActive || isCompleted
                      ? FontWeight.w600
                      : FontWeight.w400,
                  color: isActive || isCompleted
                      ? Colors.grey[900]
                      : Colors.grey[400],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSection({
    required int index,
    required String title,
    required List<Widget> children,
  }) {
    return SlideTransition(
      position: _slideAnimations[index],
      child: FadeTransition(
        opacity: _fadeAnimations[index],
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF5C4DE8),
                ),
              ),
              const SizedBox(height: 20),
              ...children,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
    TextInputType? keyboardType,
    VoidCallback? onTap,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      onTap: onTap,
      validator: validator,
      style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w400),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: Colors.grey[600]),
        prefixIcon: Icon(icon, color: const Color(0xFF5C4DE8), size: 22),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF5C4DE8), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w400),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: Colors.grey[600]),
        prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF5C4DE8), size: 22),
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined),
          color: Colors.grey[600],
          onPressed: onToggle,
        ),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF5C4DE8), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    Color strengthColor;
    String strengthText;
    
    if (_passwordStrength < 0.5) {
      strengthColor = Colors.red;
      strengthText = 'Weak';
    } else if (_passwordStrength < 0.75) {
      strengthColor = Colors.orange;
      strengthText = 'Medium';
    } else {
      strengthColor = Colors.green;
      strengthText = 'Strong';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _passwordStrength,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(strengthColor),
                  minHeight: 6,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              strengthText,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: strengthColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required IconData icon,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: Colors.grey[600]),
        prefixIcon: Icon(icon, color: const Color(0xFF5C4DE8), size: 22),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF5C4DE8), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item, style: GoogleFonts.poppins(fontSize: 15)),
        );
      }).toList(),
      onChanged: onChanged,
      style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w400),
    );
  }

  Widget _buildFileUpload({
    required String label,
    required IconData icon,
    required XFile? file,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF5C4DE8), size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[700],
                    ),
                  ),
                  if (file != null)
                    Text(
                      file.name,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: const Color(0xFF5C4DE8),
                      ),
                    ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckbox({
    required bool value,
    required String label,
    required Function(bool?) onChanged,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF5C4DE8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => onChanged(!value),
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[700],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCreateAccountButton() {
    return _AnimatedButton(
      onPressed: () {
        // Validate all forms
        final page0Valid = _formKeyPage0.currentState?.validate() ?? false;
        final page1Valid = _formKeyPage1.currentState?.validate() ?? false;
        final page2Valid = _formKeyPage2.currentState?.validate() ?? false;
        final page3Valid = _formKeyPage3.currentState?.validate() ?? false;
        
        if (page0Valid &&
            page1Valid &&
            page2Valid &&
            page3Valid &&
            _termsAccepted &&
            _privacyAccepted &&
            _dataConsentAccepted) {
          // Handle signup
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account created successfully!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please fill all required fields and accept terms')),
          );
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF5C4DE8), Color(0xFF7C6EE8)],
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          'Create Account',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[300])),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey[300])),
      ],
    );
  }

  Widget _buildGoogleButton() {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
            width: 20,
            height: 20,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.g_mobiledata, size: 24),
          ),
          const SizedBox(width: 12),
          Text(
            'Continue with Google',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        GestureDetector(
          onTap: () {
            // Navigate to login
            Navigator.pop(context);
          },
          child: Text(
            'Log In',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF5C4DE8),
            ),
          ),
        ),
      ],
    );
  }
}

class _AnimatedButton extends StatefulWidget {
  const _AnimatedButton({
    required this.onPressed,
    required this.child,
  });

  final VoidCallback onPressed;
  final Widget child;

  @override
  State<_AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 100),
        scale: _pressed ? 0.96 : 1.0,
        child: widget.child,
      ),
    );
  }
}

