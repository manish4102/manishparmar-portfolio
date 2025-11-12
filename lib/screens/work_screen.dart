import 'package:flutter/material.dart';

class Work extends StatelessWidget {
  const Work({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;
    const kBlue = Color.fromARGB(255, 23, 118, 243);

    return Container(
      color: kBlue, // 🔹 Full blue section background
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 60, vertical: 60),
      child: Container(
        // 🔹 White container inside with rounded corners + shadow
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 40, vertical: isMobile ? 24 : 40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Heading (inside the container now)
            Text(
              'Work Experience',
              style: TextStyle(
                fontSize: isMobile ? 32 : 90,
                fontWeight: FontWeight.bold,
                color: kBlue,
                shadows: const [
                  Shadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 4)),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // ==== TIMELINE STRUCTURE ====
            Stack(
              children: [
                // Vertical timeline line
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 2,
                      color: Colors.black,
                    ),
                  ),
                ),

                // Timeline entries (alternating)
                Column(
                  children: // Timeline entries (paste inside the Column(children: [ ... ]) you already have)
const [
  TimelineEntry(
    company: 'Career Empowerment Center, CSUEB (Oct 2025 – Present)',
    position: 'Intern',
    logo: 'assets/cec.jpg',
    responsibilities: [
      'Managed the student lifecycle for a grant-funded program: verified eligibility in CalJOBS, guided onboarding, and tracked milestones in Monday.com and Excel.',
      'Automated student intake reporting and case management processes, achieving 50% reduction in manual data entry time while improving accuracy.',
      'Built analytical dashboards and trend analyses on engagement metrics; identified patterns in career tool usage and workshop participation to drive improvements.',
      'Performed quantitative evaluation of career readiness programs by tracking KPIs and creating visualizations to support data-driven decisions.',
    ],
    alignLeft: true,
  ),
  TimelineEntry(
    company: 'Young Gates, Fremont, CA, USA (June 2025 – Aug 2025)',
    position: 'Data Analyst Intern',
    logo: 'assets/yg.jpg', // update to your logo if you have one
    responsibilities: [
      'Built and deployed ETL pipelines in Databricks to transform data from 11 centers, improving consistency and reducing manual effort by 60%.',
      'Created dynamic dashboards in Looker Studio and Tableau to visualize participation trends and center KPIs, leading to a 35% boost in student admissions.',
      'Standardized metrics and automated weekly reports in Google Sheets; collaborated cross-functionally to ensure accuracy and operational alignment.',
    ],
    alignLeft: false,
  ),
  TimelineEntry(
    company: 'Business Analytics Club, CSUEB, Hayward, CA, USA (Aug 2024 – May 2025)',
    position: 'Analytics Officer',
    logo: 'assets/baclub.jpg',
    responsibilities: [
      'Designed an automated scoring/reporting engine using Python + scikit-learn, reducing evaluation time by 65%.',
      'Delivered workshops to 75+ students on dashboarding, reporting, and data visualization best practices (Matplotlib/Seaborn).',
      'Coordinated analytics efforts with marketing and academic departments to ensure alignment in reporting standards.',
    ],
    alignLeft: true,
  ),
  TimelineEntry(
    company: 'IBM / Edunet Foundation (June 2023 – July 2023)',
    position: 'Data Analytics Intern',
    logo: 'assets/edunet.jpg',
    responsibilities: [
      'Analyzed and visualized student trends via Power BI dashboards for national educational review boards.',
      'Automated monthly reports across 15 regions, reducing manual effort from 8 hours to under 1 hour.',
      'Utilized Google Sheets + Python to streamline reporting logic and validate data integrity.',
    ],
    alignLeft: false,
  ),
]

                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 🔹 Timeline Entry (unchanged layout + hover effects + blue card)
class TimelineEntry extends StatefulWidget {
  final String company;
  final String position;
  final String logo;
  final List<String> responsibilities;
  final bool alignLeft;

  const TimelineEntry({
    super.key,
    required this.company,
    required this.position,
    required this.logo,
    required this.responsibilities,
    required this.alignLeft,
  });

  @override
  State<TimelineEntry> createState() => _TimelineEntryState();
}

class _TimelineEntryState extends State<TimelineEntry> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;
    const kBlue = Color.fromARGB(255, 23, 118, 243);

    // === Blue Card with Hover Animation ===
    final card = MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: () => setState(() => _hover = !_hover), // mobile tap
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          width: isMobile ? double.infinity : screenWidth * 0.4,
          margin: const EdgeInsets.symmetric(vertical: 24),
          padding: const EdgeInsets.all(24),
          transformAlignment: Alignment.center,
          transform: Matrix4.identity()
            ..translate(0.0, _hover ? -6.0 : 0.0)
            ..scale(_hover ? 1.03 : 1.0),
          decoration: BoxDecoration(
            color: kBlue,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_hover ? 0.30 : 0.18),
                blurRadius: _hover ? 25 : 14,
                offset: const Offset(0, 8),
                spreadRadius: _hover ? 2 : 0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.position,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  )),
              const SizedBox(height: 4),
              Text(widget.company,
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white.withOpacity(0.9),
                  )),
              const SizedBox(height: 16),
              ...widget.responsibilities.map(
                (r) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(color: Colors.white)),
                      Expanded(
                        child: Text(
                          r,
                          style: const TextStyle(color: Colors.white, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // === Logo Dot with shadow ===
    final logoDot = AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(_hover ? 0.30 : 0.20),
            blurRadius: _hover ? 18 : 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          widget.logo,
          width: 56,
          height: 56,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.business, size: 30),
        ),
      ),
    );

    if (isMobile) {
      // Mobile view — stacked vertically
      return Column(
        children: [
          logoDot,
          const SizedBox(height: 16),
          card,
        ],
      );
    }

    // Desktop view — alternating layout preserved
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: widget.alignLeft
          ? [
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 40),
                    child: card,
                  ),
                ),
              ),
              logoDot,
              const Expanded(child: SizedBox()),
            ]
          : [
              const Expanded(child: SizedBox()),
              logoDot,
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: card,
                  ),
                ),
              ),
            ],
    );
  }
}
