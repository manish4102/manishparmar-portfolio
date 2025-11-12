// screens/resume.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html; // for web PDF opening
import 'package:flutter/foundation.dart' show kIsWeb;

class Resume extends StatelessWidget {
  const Resume({super.key});

  Future<void> _openResume() async {
    const pdfPath = 'assets/Manish_Parmar_Resume.pdf'; // 🔹 your PDF asset
    if (kIsWeb) {
      // ---- Web: open the asset in a new tab ----
      html.window.open(pdfPath, '_blank');
    } else {
      // ---- Mobile/Desktop: open with system viewer ----
      final uri = Uri.file(pdfPath);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        debugPrint('Could not open resume file');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    const kBlue = Color.fromARGB(255, 23, 118, 243);

    return Container(
      color: kBlue,
      width: double.infinity,
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 60,
            vertical: isMobile ? 40 : 60,
          ),
          // 🔹 Rounded ONLY at the top
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 30,
                offset: Offset(0, -10),
              ),
            ],
          ),

          // ---------- Two-column layout ----------
          child: Flex(
            direction: isMobile ? Axis.vertical : Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ---------- LEFT SIDE ----------
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.only(right: isMobile ? 0 : 40, bottom: isMobile ? 30 : 0),
                  child: Column(
                    crossAxisAlignment:
                        isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Resume',
                        style: TextStyle(
                          fontSize: isMobile ? 40 : 90,
                          fontWeight: FontWeight.w900,
                          color: kBlue,
                          shadows: const [
                            Shadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 4)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Here’s a glimpse of my professional background and skills. '
                        'You can view or download my resume below for a detailed overview of my experience and achievements.',
                        textAlign: isMobile ? TextAlign.center : TextAlign.start,
                        style: TextStyle(
                          fontSize: isMobile ? 16 : 20,
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // ---------- View Resume Button ----------
                      _HoverButton(onTap: _openResume),
                    ],
                  ),
                ),
              ),

              // ---------- RIGHT SIDE (Resume Preview) ----------
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    'assets/resume.jpg', // 🔹 preview image
                    fit: BoxFit.cover,
                    height: isMobile ? 250 : 400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------- Hover Button Widget ----------
class _HoverButton extends StatefulWidget {
  final VoidCallback onTap;
  const _HoverButton({required this.onTap});

  @override
  State<_HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<_HoverButton> {
  bool _hover = false;
  static const kBlue = Color.fromARGB(255, 23, 118, 243);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          transformAlignment: Alignment.center,
          transform: Matrix4.identity()
            ..translate(0.0, _hover ? -3.0 : 0.0)
            ..scale(_hover ? 1.02 : 1.0),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _hover
                  ? const [Color(0xFF3B82F6), Color(0xFF2563EB)]
                  : const [Color(0xFF2563EB), Color(0xFF1E40AF)],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_hover ? 0.3 : 0.15),
                blurRadius: _hover ? 18 : 10,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Text(
            'View My Resume',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
