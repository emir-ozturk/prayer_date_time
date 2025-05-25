import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../pages/city_selection_page.dart';

class AddCityFab extends StatelessWidget {
  const AddCityFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const CitySelectionPage()));
      },
      backgroundColor: AppColors.primary,
      child: const Icon(AppIcons.add, color: Colors.white),
    );
  }
}
