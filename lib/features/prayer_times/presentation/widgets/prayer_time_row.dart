import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/date_utils.dart';

class PrayerTimeRow extends StatelessWidget {
  final String name;
  final String time;
  final IconData icon;
  final Color color;

  const PrayerTimeRow({
    super.key,
    required this.name,
    required this.time,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isNear = AppDateUtils.isTimeNear(time);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isNear ? color.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isNear ? Border.all(color: color.withOpacity(0.3)) : null,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isNear ? FontWeight.bold : FontWeight.normal,
                color: isNear ? color : AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            AppDateUtils.formatTime(time),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isNear ? color : AppColors.textPrimary,
            ),
          ),
          if (isNear) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
              child: const Text(
                'Yaklaşıyor',
                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
