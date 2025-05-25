import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../bloc/city_selection_bloc.dart';
import '../bloc/prayer_times_bloc.dart';
import '../bloc/prayer_times_event.dart' as prayer_events;
import '../widgets/city_list_item.dart';
import '../widgets/district_list_item.dart';

class CitySelectionPage extends StatelessWidget {
  const CitySelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Şehir Seç'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<CitySelectionBloc, CitySelectionState>(
        builder: (context, state) {
          if (state is CitySelectionInitial) {
            context.read<CitySelectionBloc>().add(LoadCities());
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CitySelectionLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CitySelectionError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(AppIcons.error, size: 64, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(
                    'Hata: ${state.message}',
                    style: const TextStyle(color: AppColors.error),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CitySelectionBloc>().add(LoadCities());
                    },
                    child: const Text('Tekrar Dene'),
                  ),
                ],
              ),
            );
          }

          if (state is CitiesLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.cities.length,
              itemBuilder: (context, index) {
                final city = state.cities[index];
                return CityListItem(
                  city: city,
                  onTap: () {
                    context.read<CitySelectionBloc>().add(SelectCity(cityId: city.id));
                  },
                );
              },
            );
          }

          if (state is DistrictsLoaded) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  color: AppColors.primary.withValues(alpha: 0.1),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          context.read<CitySelectionBloc>().add(LoadCities());
                        },
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'İlçe Seçin',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.districts.length,
                    itemBuilder: (context, index) {
                      final district = state.districts[index];
                      return DistrictListItem(
                        district: district,
                        onTap: () {
                          context.read<PrayerTimesBloc>().add(
                            prayer_events.AddCity(
                              districtId: district.id,
                              districtName: district.name,
                            ),
                          );
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
