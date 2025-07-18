import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_project/cubit/sensor_cubit.dart';
import 'package:interview_project/repository/sensor_repository.dart';
import 'package:interview_project/widgets/search_and_sort_controls.dart';
import 'package:interview_project/widgets/sensor_list_view.dart';

class SensorScreen extends StatelessWidget {
  const SensorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SensorCubit(context.read<SensorRepository>())..initialize(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sensor Dashboard'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 0,
        ),
        body: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              SearchAndSortControls(),
              SizedBox(height: 16),
              Expanded(child: SensorListView()),
            ],
          ),
        ),
      ),
    );
  }
}
