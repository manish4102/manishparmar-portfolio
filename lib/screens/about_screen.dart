import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Container(
      color: const Color.fromARGB(255, 23, 118, 243), // blue background
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 80,
        vertical: 60,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About Me',
            style: TextStyle(
              fontSize: isMobile ? 32 : 90,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              shadows: const [
                Shadow(color: Colors.black38, blurRadius: 16, offset: Offset(0, 6)),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // === Content row ===
          Flex(
            direction: isMobile ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // === Image with shadow ===
              Container(
                decoration: BoxDecoration(
                  // invisible container, only for the shadow
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 45,
                      offset: const Offset(0, 18),
                      spreadRadius: -10,
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/me_1.png', // transparent PNG image
                  width: isMobile ? 220 : 400,
                  height: isMobile ? 220 : 400,
                  fit: BoxFit.contain,
                ),
              ),

              SizedBox(width: isMobile ? 0 : 40, height: isMobile ? 24 : 0),

              // === Text column ===
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hi, I'm Manish — developer, designer, and problem-solver. I enjoy building intuitive and impactful digital products. Originally from India, my journey in tech began with curiosity and evolved into a passion for crafting delightful user experiences.",
                      style: TextStyle(
                        fontSize: isMobile ? 16 : 18,
                        color: Colors.white.withOpacity(0.9),
                        height: 1.7,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "With a background in engineering and creativity, I bridge the gap between technical feasibility and visual design. I'm always exploring how systems work, why users behave the way they do, and how data can drive better outcomes.",
                      style: TextStyle(
                        fontSize: isMobile ? 16 : 18,
                        color: Colors.white.withOpacity(0.9),
                        height: 1.7,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Today, I'm building experiences that simplify complexity — combining my love for design, logic, and user empathy in everything I create.",
                      style: TextStyle(
                        fontSize: isMobile ? 16 : 18,
                        color: Colors.white.withOpacity(0.9),
                        height: 1.7,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
