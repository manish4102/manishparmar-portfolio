import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Projects extends StatelessWidget {
  const Projects({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Container(
      color: const Color.fromARGB(255, 23, 118, 243), // page background
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 60,
        vertical: 80,
      ),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 60,
            vertical: isMobile ? 40 : 60,
          ),
          decoration: BoxDecoration(
            color: Colors.white, // blue background
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 35,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Projects',
                style: TextStyle(
                  fontSize: isMobile ? 36 : 90,
                  fontWeight: FontWeight.w900,
                  color: const Color.fromARGB(255, 23, 118, 243),
                  shadows: const [
                Shadow(color: Colors.black38, blurRadius: 16, offset: Offset(0, 6)),
              ],
                ),
              ),
              const SizedBox(height: 60),

              // ---- Horizontal scroll ----
              SingleChildScrollView(
                scrollDirection: isMobile ? Axis.vertical : Axis.horizontal,
                child: isMobile
                    ? Column(
                        children: const [
                          HoverImageCard(
                            image: 'assets/svb.jpg',
                            title: 'SVB Bank Analysis',
                            description:
                                '• Applied TensorFlow + SHAP to model financial risks, achieving 92% prediction accuracy.\n'
                                '• Designed Power BI dashboards for risk simulation, reducing analysis time by 40%.',
                            githubUrl: 'https://github.com/manish4102/SVB-Analysis',
                            ieeeUrl: 'https://ieeexplore.ieee.org/document/10511378',
                          ),
                          SizedBox(height: 30),
                          HoverImageCard(
                            image: 'assets/Ganak.jpg',
                            title: 'Ganak - Inventory Management System',
                            description:
                                '• Real-time inventory tracking with Flutter + Firebase.\n'
                                '• LSTM-based demand forecasting improved accuracy by 33%.',
                            githubUrl: 'https://github.com/manish4102/inventory_system',
                            ieeeUrl: 'https://ieeexplore.ieee.org/document/10775065',
                          ),
                          SizedBox(height: 30),
                          HoverImageCard(
                            image: 'assets/Card_5.jpg',
                            title: 'AI Risk Simulator',
                            description:
                                '• Monte Carlo–based AI risk simulator for finance.\n'
                                '• Integrated SHAP visualizations and Flutter Web dashboards.',
                            githubUrl: 'https://github.com/yourusername/ai-risk-simulator',
                            ieeeUrl: 'https://ieeexplore.ieee.org/document/56781234',
                          ),
                        ],
                      )
                    : Row(
                        children: const [
                          HoverImageCard(
                            image: 'assets/svb.jpg',
                            title: 'SVB Bank Analysis',
                            description:
                                '• Applied TensorFlow + SHAP to model financial risks, achieving 92% prediction accuracy.\n'
                                '• Designed Power BI dashboards for risk simulation, reducing analysis time by 40%.',
                            githubUrl: 'https://github.com/yourusername/svb-bank-analysis',
                            ieeeUrl: 'https://ieeexplore.ieee.org/document/10511378',
                          ),
                          SizedBox(width: 40),
                          HoverImageCard(
                            image: 'assets/ganak.jpg',
                            title: 'Ganak - Inventory Management System',
                            description:
                                '• Real-time inventory tracking with Flutter + Firebase.\n'
                                '• LSTM-based demand forecasting improved accuracy by 33%.',
                            githubUrl: 'https://github.com/manish4102/inventory_system',
                            ieeeUrl: 'https://ieeexplore.ieee.org/document/10775065',
                          ),
                          SizedBox(width: 40),
                          HoverImageCard(
                            image: 'assets/Card_5.jpg',
                            title: 'Candidate Recommendation Engine',
                            description:
    '• AI-powered Streamlit tool for intelligent resume–job matching.\n'
    '• Combines SBERT similarity, ML scoring, and Gemini AI for candidate analysis.',
                            githubUrl: 'https://github.com/manish4102/CRS_system',
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class HoverImageCard extends StatefulWidget {
  final String image;
  final String title;
  final String description;
  final String githubUrl;
  final String? ieeeUrl;

  const HoverImageCard({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.githubUrl,
    this.ieeeUrl,
  });

  @override
  State<HoverImageCard> createState() => _HoverImageCardState();
}

class _HoverImageCardState extends State<HoverImageCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    final double baseWidth = isMobile ? 280 : 360;
    final double baseHeight = isMobile ? 220 : 280;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        width: _hover ? baseWidth * 1.07 : baseWidth, // 🔹 full card grows
        height: _hover ? baseHeight * 1.07 : baseHeight,
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_hover ? 0.35 : 0.15),
              blurRadius: _hover ? 35 : 12,
              offset: const Offset(0, 12),
              spreadRadius: _hover ? 3 : -2,
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // === Image layer with zoom ===
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              transform: Matrix4.identity()
                ..scale(_hover ? 1.12 : 1.0), // image zooms too
              transformAlignment: Alignment.center,
              child: Image.asset(
                widget.image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),

            // === Hover overlay with text ===
            // === Hover overlay with text ===
AnimatedOpacity(
  opacity: _hover ? 1.0 : 0.0,
  duration: const Duration(milliseconds: 300),
  curve: Curves.easeOutCubic,
  child: Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [
          Colors.black.withOpacity(1),
          Colors.black.withOpacity(0.85),
          Colors.transparent,
        ],
      ),
    ),
    padding: const EdgeInsets.all(20),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          widget.description,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _linkButton(
              icon: Icons.code,
              label: 'GitHub',
              url: widget.githubUrl,
            ),
            if (widget.ieeeUrl != null && widget.ieeeUrl!.isNotEmpty) ...[
              const SizedBox(width: 16),
              _linkButton(
                icon: Icons.picture_as_pdf,
                label: 'IEEE',
                url: widget.ieeeUrl!,
              ),
            ],
          ],
        ),
      ],
    ),
  ),
),

          ],
        ),
      ),
    );
  }

  Widget _linkButton({
    required IconData icon,
    required String label,
    required String url,
  }) {
    return InkWell(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.blueAccent,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }
}
