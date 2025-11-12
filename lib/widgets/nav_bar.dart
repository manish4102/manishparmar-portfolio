// navbar.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import '/screens/home_screen.dart';
import '/screens/about_screen.dart';
import '/screens/projects_screen.dart';
import '/screens/education_screen.dart';
import '/screens/contact_screen.dart';
import '/screens/resume_screen.dart';
import '/screens/work_screen.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  bool isMobile = false;
  bool showNav = false;

  final aboutKey = GlobalKey();
  final projectsKey = GlobalKey();
  final educationKey = GlobalKey();
  final workKey = GlobalKey();
  final contactKey = GlobalKey();
  final resumeKey = GlobalKey();
  final homeKey = GlobalKey();

  final ScrollController _scrollController = ScrollController();

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(context,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      drawer: isMobile
          ? Drawer(
              backgroundColor: const Color.fromARGB(221, 18, 117, 237),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration:
                        BoxDecoration(color: Color.fromARGB(221, 18, 117, 237)),
                    child: Text('Manish',
                        style: TextStyle(color: Colors.white, fontSize: 35)),
                  ),
                  _drawerItem('About', aboutKey),
                  _drawerItem('Projects', projectsKey),
                  _drawerItem('Education', educationKey),
                  _drawerItem('Work', workKey),
                  _drawerItem('Contact', contactKey),
                  _drawerItem('Resume', resumeKey),
                ],
              ),
            )
          : null,
      body: Stack(
        children: [
          // ---------- Page content ----------
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                Container(key: homeKey, child: const Home()),
                Container(key: aboutKey, child: const About()),
                Container(key: projectsKey, child: const Projects()),
                Container(key: educationKey, child: const Education()),
                Container(key: workKey, child: const Work()),
                Container(key: contactKey, child: const Contact()),
                Container(key: resumeKey, child: const Resume()),
              ],
            ),
          ),

          // ---------- Navbar ----------
          Positioned(
            top: 20,
            left: MediaQuery.of(context).size.width * 0.1,
            right: MediaQuery.of(context).size.width * 0.1,
            child: MouseRegion(
              onEnter: (_) => setState(() => showNav = true),
              onExit: (_) => setState(() => showNav = false),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    height: 60,
                    decoration: BoxDecoration(
                      // 🔹 Navbar color on hover
                      color: showNav
                          ? const Color.fromARGB(221, 18, 117, 237)
                          : const Color.fromARGB(171, 33, 133, 221)
                              .withOpacity(0.5),
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.1), width: 1),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: isMobile
                          ? MainAxisAlignment.spaceBetween
                          : MainAxisAlignment.center,
                      children: isMobile
                          ? [
                              const Text('Manish',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold)),
                              Builder(
                                builder: (context) => IconButton(
                                  icon: const Icon(Icons.menu,
                                      color: Colors.white),
                                  onPressed: () =>
                                      Scaffold.of(context).openDrawer(),
                                ),
                              ),
                            ]
                          : [
                              // Left buttons
                              AnimatedOpacity(
                                duration: const Duration(milliseconds: 300),
                                opacity: showNav ? 1.0 : 0.0,
                                child: Row(
                                  children: [
                                    _navButton('About', aboutKey),
                                    _navButton('Projects', projectsKey),
                                    _navButton('Education', educationKey),
                                  ],
                                ),
                              ),

                              // Center logo/name
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: GestureDetector(
                                  onTap: () => _scrollToSection(homeKey),
                                  child: const Text(
                                    'Manish',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),

                              // Right buttons
                              AnimatedOpacity(
                                duration: const Duration(milliseconds: 300),
                                opacity: showNav ? 1.0 : 0.0,
                                child: Row(
                                  children: [
                                    _navButton('Work', workKey),
                                    _navButton('Contact', contactKey),
                                    _navButton('Resume', resumeKey),
                                  ],
                                ),
                              ),
                            ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Hoverable Nav Button ----------
  Widget _navButton(String label, GlobalKey key) {
    bool _hover = false;
    return StatefulBuilder(
      builder: (context, setHover) {
        return MouseRegion(
          onEnter: (_) => setHover(() => _hover = true),
          onExit: (_) => setHover(() => _hover = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              color: _hover ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextButton(
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: () => _scrollToSection(key),
              child: Text(
                label,
                style: TextStyle(
                  color: _hover
                      ? const Color.fromARGB(221, 18, 117, 237)
                      : Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ---------- Drawer item for mobile ----------
  Widget _drawerItem(String label, GlobalKey key) {
    return ListTile(
      title: Text(label, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.pop(context);
        Future.delayed(
          const Duration(milliseconds: 300),
          () => _scrollToSection(key),
        );
      },
    );
  }
}
