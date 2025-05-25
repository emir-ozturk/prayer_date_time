import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/utils/date_utils.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;

  const AnimatedBackground({super.key, required this.child});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> with TickerProviderStateMixin {
  late AnimationController _sunController;
  late AnimationController _moonController;
  late AnimationController _starsController;

  @override
  void initState() {
    super.initState();

    _sunController = AnimationController(duration: const Duration(seconds: 10), vsync: this)
      ..repeat();

    _moonController = AnimationController(duration: const Duration(seconds: 15), vsync: this)
      ..repeat();

    _starsController = AnimationController(duration: const Duration(seconds: 3), vsync: this)
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _sunController.dispose();
    _moonController.dispose();
    _starsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDaytime = AppDateUtils.isDaytime();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDaytime ? _getDaytimeColors() : _getNighttimeColors(),
        ),
      ),
      child: Stack(
        children: [
          if (isDaytime) ..._buildDaytimeElements(),
          if (!isDaytime) ..._buildNighttimeElements(),
          widget.child,
        ],
      ),
    );
  }

  List<Color> _getDaytimeColors() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 7) {
      // Dawn
      return [
        const Color(0xFFFFB347), // Orange
        const Color(0xFFFFD700), // Gold
        const Color(0xFF87CEEB), // Sky blue
      ];
    } else if (hour >= 7 && hour < 17) {
      // Day
      return [
        const Color(0xFF87CEEB), // Sky blue
        const Color(0xFF98D8E8), // Light blue
        const Color(0xFFE6F3FF), // Very light blue
      ];
    } else {
      // Sunset
      return [
        const Color(0xFFFF6B6B), // Red
        const Color(0xFFFFD93D), // Yellow
        const Color(0xFF6BCF7F), // Light green
      ];
    }
  }

  List<Color> _getNighttimeColors() {
    return [
      const Color(0xFF191970), // Midnight blue
      const Color(0xFF483D8B), // Dark slate blue
      const Color(0xFF2F2F4F), // Dark slate gray
    ];
  }

  List<Widget> _buildDaytimeElements() {
    return [
      // Sun
      AnimatedBuilder(
        animation: _sunController,
        builder: (context, child) {
          return Positioned(
            top: 50 + math.sin(_sunController.value * 2 * math.pi) * 20,
            right: 50 + math.cos(_sunController.value * 2 * math.pi) * 30,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [Colors.yellow.shade300, Colors.orange.shade400]),
                boxShadow: [
                  BoxShadow(color: Colors.yellow.withOpacity(0.3), blurRadius: 20, spreadRadius: 5),
                ],
              ),
            ),
          );
        },
      ),
      // Clouds
      ..._buildClouds(),
    ];
  }

  List<Widget> _buildNighttimeElements() {
    return [
      // Moon
      AnimatedBuilder(
        animation: _moonController,
        builder: (context, child) {
          return Positioned(
            top: 80 + math.sin(_moonController.value * 2 * math.pi) * 15,
            right: 60 + math.cos(_moonController.value * 2 * math.pi) * 25,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [Colors.grey.shade200, Colors.grey.shade400]),
                boxShadow: [
                  BoxShadow(color: Colors.white.withOpacity(0.2), blurRadius: 15, spreadRadius: 3),
                ],
              ),
            ),
          );
        },
      ),
      // Stars
      ..._buildStars(),
    ];
  }

  List<Widget> _buildClouds() {
    return [
      Positioned(
        top: 100,
        left: 20,
        child: AnimatedBuilder(
          animation: _sunController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_sunController.value * 50 - 25, 0),
              child: Icon(Icons.cloud, size: 40, color: Colors.white.withOpacity(0.7)),
            );
          },
        ),
      ),
      Positioned(
        top: 120,
        right: 80,
        child: AnimatedBuilder(
          animation: _sunController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(-_sunController.value * 30 + 15, 0),
              child: Icon(Icons.cloud, size: 30, color: Colors.white.withOpacity(0.5)),
            );
          },
        ),
      ),
    ];
  }

  List<Widget> _buildStars() {
    return List.generate(15, (index) {
      return Positioned(
        top: 50 + (index * 23) % 200,
        left: 30 + (index * 47) % 300,
        child: AnimatedBuilder(
          animation: _starsController,
          builder: (context, child) {
            return Opacity(
              opacity: 0.3 + (_starsController.value * 0.7),
              child: Icon(Icons.star, size: 8 + (index % 3) * 4, color: Colors.white),
            );
          },
        ),
      );
    });
  }
}
