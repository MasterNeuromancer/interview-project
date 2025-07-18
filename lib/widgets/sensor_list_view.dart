import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_project/cubit/sensor_cubit.dart';
import 'package:interview_project/widgets/sensor_card.dart';

class SensorListView extends StatelessWidget {
  const SensorListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SensorCubit, SensorState>(
      builder: (context, state) {
        return switch (state) {
          SensorInitial() ||
          SensorLoading() => const Center(child: CircularProgressIndicator()),
          SensorError(message: final msg) => Center(child: Text('Error: $msg')),
          SensorLoaded(displayedSensors: final sensors) =>
            sensors.isEmpty
                ? const Center(child: Text('No sensors match your criteria.'))
                : AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: ListView.builder(
                      key: ValueKey(sensors),
                      itemCount: sensors.length,
                      itemBuilder: (context, index) {
                        return SensorCard(sensor: sensors[index]);
                      },
                    ),
                  ),
        };
      },
    );
  }
}
