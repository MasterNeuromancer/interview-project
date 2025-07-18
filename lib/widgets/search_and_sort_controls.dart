import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_project/cubit/sensor_cubit.dart';
import 'package:interview_project/enums/sort_order.dart';
import 'package:interview_project/widgets/sort_button.dart';

class SearchAndSortControls extends StatelessWidget {
  const SearchAndSortControls({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SensorCubit, SensorState>(
      builder: (context, state) {
        final currentSortOrder = state is SensorLoaded
            ? state.sortOrder
            : SortOrder.none;

        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search by name or description...',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                  ),
                  onChanged: (query) =>
                      context.read<SensorCubit>().search(query),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    left: 8.0,
                    right: 8.0,
                  ),
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Text(
                        'Sort by Temp:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SortButton(
                            label: 'Low-High',
                            icon: Icons.arrow_upward,
                            isActive: currentSortOrder == SortOrder.ascending,
                            onPressed: () => context.read<SensorCubit>().sort(
                              SortOrder.ascending,
                            ),
                          ),
                          const SizedBox(width: 8),
                          SortButton(
                            label: 'High-Low',
                            icon: Icons.arrow_downward,
                            isActive: currentSortOrder == SortOrder.descending,
                            onPressed: () => context.read<SensorCubit>().sort(
                              SortOrder.descending,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
