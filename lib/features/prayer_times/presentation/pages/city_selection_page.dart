import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../domain/entities/city.dart';
import '../../domain/entities/district.dart';
import '../bloc/city_selection_bloc.dart';
import '../bloc/prayer_times_bloc.dart';
import '../bloc/prayer_times_event.dart' as prayer_events;
import '../widgets/city_list_item.dart';
import '../widgets/district_list_item.dart';

class CitySelectionPage extends StatefulWidget {
  const CitySelectionPage({super.key});

  @override
  State<CitySelectionPage> createState() => _CitySelectionPageState();
}

class _CitySelectionPageState extends State<CitySelectionPage> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List<City> _filteredCities = [];
  List<District> _filteredDistricts = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _filteredCities.clear();
        _filteredDistricts.clear();
      }
    });
  }

  void _filterCities(String query, List<City> allCities) {
    setState(() {
      if (query.isEmpty) {
        _filteredCities = allCities;
      } else {
        _filteredCities = allCities
            .where((city) => city.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _filterDistricts(String query, List<District> allDistricts) {
    setState(() {
      if (query.isEmpty) {
        _filteredDistricts = allDistricts;
      } else {
        _filteredDistricts = allDistricts
            .where((district) => district.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Şehir ara...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                onChanged: (query) {
                  final state = context.read<CitySelectionBloc>().state;
                  if (state is CitiesLoaded) {
                    _filterCities(query, state.cities);
                  } else if (state is DistrictsLoaded) {
                    _filterDistricts(query, state.districts);
                  }
                },
              )
            : const Text('Şehir Seç'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
        ],
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
            // Initialize filtered cities if not searching
            if (!_isSearching && _filteredCities.isEmpty) {
              _filteredCities = state.cities;
            }

            final citiesToShow = _isSearching || _searchController.text.isNotEmpty
                ? _filteredCities
                : state.cities;

            if (citiesToShow.isEmpty && _searchController.text.isNotEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 64, color: AppColors.textHint),
                    const SizedBox(height: 16),
                    Text(
                      'Aradığınız şehir bulunamadı',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '"${_searchController.text}" için sonuç yok',
                      style: TextStyle(color: AppColors.textHint),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: citiesToShow.length,
              itemBuilder: (context, index) {
                final city = citiesToShow[index];
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
            // Initialize filtered districts if not searching
            if (!_isSearching && _filteredDistricts.isEmpty) {
              _filteredDistricts = state.districts;
            }

            final districtsToShow = _isSearching || _searchController.text.isNotEmpty
                ? _filteredDistricts
                : state.districts;

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
                          setState(() {
                            _isSearching = false;
                            _searchController.clear();
                            _filteredCities.clear();
                            _filteredDistricts.clear();
                          });
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
                if (districtsToShow.isEmpty && _searchController.text.isNotEmpty)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 64, color: AppColors.textHint),
                          const SizedBox(height: 16),
                          Text(
                            'Aradığınız ilçe bulunamadı',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '"${_searchController.text}" için sonuç yok',
                            style: TextStyle(color: AppColors.textHint),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: districtsToShow.length,
                      itemBuilder: (context, index) {
                        final district = districtsToShow[index];
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
