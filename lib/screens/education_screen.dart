import 'package:flutter/material.dart';

class Education extends StatelessWidget {
  const Education({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    const kBlue = Color.fromARGB(255, 23, 118, 243);

    return Container(
      color: kBlue, // Full blue section background
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 80,
        vertical: 60,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heading with shadow
          Text(
            'Education',
            style: TextStyle(
              fontSize: isMobile ? 36 : 90,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              shadows: const [
                Shadow(color: Colors.black38, blurRadius: 16, offset: Offset(0, 6)),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // Two education entries
          Column(
            children: [
              _EducationItem(
                kBlue: kBlue,
                isMobile: isMobile,
                title: 'MS in Data Science / Statistics',
                subtitle: 'California State University, East Bay (Aug 2024 – May 2026)',
                imagePath: 'assets/Card_1.jpg',
                imageWidthDesktop: 200,
                imageHeightDesktop: 120,
                imageWidthMobile: 100,
                imageHeightMobile: 100,
              ),
              const SizedBox(height: 32),
              _EducationItem(
                kBlue: kBlue,
                isMobile: isMobile,
                title: 'B.Tech in Computer Science (Data Science)',
                subtitle: 'DY Patil International University (June 2020 – May 2024)',
                imagePath: 'assets/Undergrad.jpg',
                imageWidthDesktop: 350,
                imageHeightDesktop: 120,
                imageWidthMobile: 100,
                imageHeightMobile: 100,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------- Reusable education card with hover/tap effects ----------
class _EducationItem extends StatefulWidget {
  const _EducationItem({
    required this.kBlue,
    required this.isMobile,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.imageWidthDesktop,
    required this.imageHeightDesktop,
    required this.imageWidthMobile,
    required this.imageHeightMobile,
  });

  final Color kBlue;
  final bool isMobile;
  final String title;
  final String subtitle;
  final String imagePath;
  final double imageWidthDesktop;
  final double imageHeightDesktop;
  final double imageWidthMobile;
  final double imageHeightMobile;

  @override
  State<_EducationItem> createState() => _EducationItemState();
}

class _EducationItemState extends State<_EducationItem> {
  bool _hover = false;

  void _setHover(bool v) => setState(() => _hover = v);

  @override
  Widget build(BuildContext context) {
    final imgW = widget.isMobile ? widget.imageWidthMobile : widget.imageWidthDesktop;
    final imgH = widget.isMobile ? widget.imageHeightMobile : widget.imageHeightDesktop;

    return MouseRegion(
      onEnter: (_) => _setHover(true),
      onExit: (_) => _setHover(false),
      child: GestureDetector(
        onTap: () => _setHover(!_hover), // mobile tap-toggle
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(24),
          transformAlignment: Alignment.center,
          transform: Matrix4.identity()
            ..translate(0.0, _hover ? -6.0 : 0.0)
            ..scale(_hover ? 1.02 : 1.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_hover ? 0.28 : 0.18),
                blurRadius: _hover ? 20 : 12,
                offset: const Offset(0, 8),
                spreadRadius: _hover ? 2 : 0,
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Text area
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: widget.isMobile ? 24 : 28,
                        fontWeight: FontWeight.w800,
                        color: widget.kBlue,
                        shadows: [
                          if (_hover)
                            const Shadow(
                              color: Color(0x33000000),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.subtitle,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFF0D47A1),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 20),

              // Image with its own animated shadow
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(_hover ? 0.30 : 0.18),
                      blurRadius: _hover ? 22 : 12,
                      offset: const Offset(0, 8),
                      spreadRadius: _hover ? 1 : 0,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    widget.imagePath,
                    width: imgW,
                    height: imgH,
                    fit: BoxFit.cover,
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
