import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;
  bool _isChatbotOpen = false;
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();
  final List<Map<String, String>> _chatMessages = [
    {
      'text': 'Hello! I\'m your CERV assistant. How can I help you today?',
      'sender': 'bot',
    },
  ];

  final List<Map<String, String>> _communityHighlights = [
    {
      'title': 'Streetlight Fixed',
      'description': 'Barangay Zone 2 successfully resolved a maintenance report.',
    },
    {
      'title': 'Tree Planting',
      'description': 'Weekend clean-up event and tree planting drive.',
    },
    {
      'title': 'Report Milestone',
      'description': 'Over 1,000 reports submitted this month.',
    },
  ];

  @override
  void dispose() {
    _chatController.dispose();
    _chatScrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_chatController.text.trim().isEmpty) return;

    setState(() {
      _chatMessages.add({
        'text': _chatController.text.trim(),
        'sender': 'user',
      });
      _chatController.clear();
    });

    // Auto-scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_chatScrollController.hasClients) {
        _chatScrollController.animateTo(
          _chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    // Simulate bot response
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _chatMessages.add({
          'text': 'Thank you for your message. I\'m here to help!',
          'sender': 'bot',
        });
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_chatScrollController.hasClients) {
          _chatScrollController.animateTo(
            _chatScrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildQuickActions(),
                  const SizedBox(height: 24),
                  _buildMapPreview(),
                  const SizedBox(height: 24),
                  _buildCommunityHighlights(),
                  const SizedBox(height: 80), // Space for bottom nav
                ],
              ),
            ),
            _buildChatbot(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          // Logo
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: AssetImage('lib/cerv_logo.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Welcome text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to CERV,',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFF888888),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'John Doe', // Replace with actual username
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: const Color(0xFF5C4DE8),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Profile picture
          GestureDetector(
            onTap: () {
              // Handle profile picture tap
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF5C4DE8),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF5C4DE8).withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: ClipOval(
                child: Container(
                  color: const Color(0xFFE0E0E0),
                  child: const Icon(
                    Icons.person,
                    color: Color(0xFF5C4DE8),
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          icon: Icons.add_location_alt,
          label: 'Report',
          onTap: () {
            Navigator.of(context).pushNamed('/report');
          },
        ),
        _buildActionButton(
          icon: Icons.phone_in_talk,
          label: 'Emergency',
          onTap: () {},
        ),
        _buildActionButton(
          icon: Icons.volunteer_activism,
          label: 'Guidelines',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(15),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF5C4DE8),
                    Color(0xFF8F7EFF),
                  ],
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF5C4DE8).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    color: Colors.white,
                    size: 28,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMapPreview() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F5FF),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Map Overview',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: const Color(0xFF5C4DE8),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Handle refresh
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.refresh,
                      color: Color(0xFF5C4DE8),
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: const Color(0xFFDCDCFF),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                'Map loading…',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: const Color(0xFF5C4DE8).withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityHighlights() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Community Highlights',
          style: GoogleFonts.poppins(
            fontSize: 18,
            color: const Color(0xFF5C4DE8),
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.underline,
            decorationColor: const Color(0xFF5C4DE8),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: _communityHighlights.length,
            itemBuilder: (context, index) {
              return _buildHighlightCard(_communityHighlights[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHighlightCard(Map<String, String> highlight) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            highlight['title']!,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: const Color(0xFF5C4DE8),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            highlight['description']!,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: const Color(0xFF555555),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF5C4DE8),
        unselectedItemColor: const Color(0xFF777777),
        selectedLabelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildChatbot() {
    return Stack(
      children: [
        // Floating button
        Positioned(
          bottom: 100,
          right: 20,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _isChatbotOpen = !_isChatbotOpen;
              });
            },
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF5C4DE8),
                    Color(0xFF8F7EFF),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF5C4DE8).withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.smart_toy,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ),
        // Chat window
        if (_isChatbotOpen)
          Positioned(
            bottom: 170,
            right: 20,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              constraints: const BoxConstraints(
                maxWidth: 320,
                minWidth: 280,
              ),
              height: 450,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xFF5C4DE8),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'AI Chatbot',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isChatbotOpen = false;
                            });
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Messages area
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: ListView.builder(
                        controller: _chatScrollController,
                        itemCount: _chatMessages.length,
                        itemBuilder: (context, index) {
                          final message = _chatMessages[index];
                          final isBot = message['sender'] == 'bot';
                          return Align(
                            alignment: isBot
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isBot
                                    ? const Color(0xFFF4F5FF)
                                    : const Color(0xFF5C4DE8),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.6,
                              ),
                              child: Text(
                                message['text']!,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: isBot
                                      ? const Color(0xFF5C4DE8)
                                      : Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // Input bar
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _chatController,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Type a message...',
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[400],
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                            ),
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Material(
                          color: const Color(0xFF5C4DE8),
                          borderRadius: BorderRadius.circular(20),
                          child: InkWell(
                            onTap: _sendMessage,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: const Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

