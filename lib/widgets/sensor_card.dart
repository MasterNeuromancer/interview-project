import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_project/cubit/sensor_cubit.dart';
import 'package:interview_project/model/sensor.dart';
import 'package:interview_project/screens/sensor_details_screen.dart';
import 'package:interview_project/utils/temp_color.dart';

class SensorCard extends StatelessWidget {
  final Sensor sensor;
  const SensorCard({super.key, required this.sensor});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        title: Text(
          sensor.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            sensor.description,
            style: TextStyle(color: Colors.grey.shade400),
          ),
        ),
        trailing: Text(
          '${sensor.value.toStringAsFixed(1)}°F',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: getTempColor(sensor.value),
          ),
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) {
                return BlocProvider.value(
                  value: context.read<SensorCubit>(),
                  child: SensorDetailsScreen(sensor: sensor),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
