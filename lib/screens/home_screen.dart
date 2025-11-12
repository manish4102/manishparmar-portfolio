import 'package:flutter/material.dart';
import 'package:portfolio_website/widgets/hover_card.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 700;

    // Tunables for the look
    final nameSize = isMobile ? 36.0 : 90.0;
    final taglineSize = isMobile ? 36.0 : 96.0;
    final taglineSize_1 = isMobile ? 30.0 : 70.0;
    final stackHeight = isMobile ? 220.0 : 300.0;
    final cardWidth = isMobile ? 170.0 : 300.0;
    final cardHeight = isMobile ? 150.0 : 250.0;

    return Container(
      width: size.width,
      height: size.height,
      color: const Color.fromARGB(255, 23, 118, 243), // SECTION background (blue)
      child: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
  color: Colors.white, // fallback background color
  borderRadius: BorderRadius.only(
    bottomLeft: Radius.circular(60),
    bottomRight: Radius.circular(60),
  ),
  image: DecorationImage(
    image: AssetImage('assets/background.jpg'), // your image path
    fit: BoxFit.cover, // make it fill the container
  ),
),

          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 60,
              vertical: isMobile ? 90 : 90,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ======= NAME (top) =======
                Text(
                  'MANISH PARMAR',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: nameSize,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    color: const Color.fromARGB(255, 23, 118, 243),
                    shadows: const [
                      Shadow(
                          color: Colors.black38,
                          blurRadius: 16,
                          offset: Offset(0, 6)),
                    ],
                  ),
                ),

                // ======= CARDS (middle) =======
                SizedBox(
                  height: stackHeight,
                  child: Center(
                    child: SizedBox(
                      width: (cardWidth * 3) + (isMobile ? 20 : 60),
                      height: stackHeight,
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          PlacedCard(
                            width: cardWidth,
                            height: cardHeight,
                            dx: isMobile ? -cardWidth * 0.85 : -cardWidth * 0.95,
                            dy: 18,
                            angle: -0.10,
                            child: _buildImageOnlyCard('assets/Card_4.jpg'),
                          ),
                          PlacedCard(
                            width: cardWidth,
                            height: cardHeight,
                            dx: isMobile ? -cardWidth * 0.25 : -cardWidth * 0.30,
                            dy: -6,
                            angle: -0.06,
                            child: _buildImageOnlyCard('assets/Card_1.jpg'),
                          ),
                          PlacedCard(
                            width: cardWidth,
                            height: cardHeight,
                            dx: isMobile ? cardWidth * 0.25 : cardWidth * 0.30,
                            dy: 6,
                            angle: 0.08,
                            child: _buildImageOnlyCard('assets/Card_3.jpg'),
                          ),
                          PlacedCard(
                            width: cardWidth,
                            height: cardHeight,
                            dx: isMobile ? cardWidth * 0.85 : cardWidth * 0.95,
                            dy: -12,
                            angle: 0.05,
                            child: _buildImageOnlyCard('assets/card_2.jpg'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ======= TAGLINE (bottom) =======
                Text(
                  'DATA ENGINEER',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: taglineSize,
                    height: 0.85,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    color: const Color.fromARGB(145, 23, 118, 243),
                    shadows: const [
                      Shadow(
                          color: Colors.black38,
                          blurRadius: 16,
                          offset: Offset(0, 6)),
                    ],
                  ),
                ),
                Text(
                  'TURNING DATA INTO INSIGHTS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: taglineSize_1,
                    height: 0.75,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    color: const Color.fromARGB(145, 23, 118, 243),
                    shadows: const [
                      Shadow(
                          color: Colors.black38,
                          blurRadius: 16,
                          offset: Offset(0, 6)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageOnlyCard(String imagePath) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 25,
            offset: const Offset(0, 12),
            spreadRadius: -5,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey.shade300,
            child: const Icon(Icons.image, size: 50, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
