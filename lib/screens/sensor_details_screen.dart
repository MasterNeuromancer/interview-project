import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_project/cubit/sensor_cubit.dart';
import 'package:interview_project/model/sensor.dart';
import 'package:interview_project/utils/temp_color.dart';

class SensorDetailsScreen extends StatefulWidget {
  final Sensor sensor;

  const SensorDetailsScreen({super.key, required this.sensor});

  @override
  State<SensorDetailsScreen> createState() => _SensorDetailsScreenState();
}

class _SensorDetailsScreenState extends State<SensorDetailsScreen> {
  bool _isEditing = false;
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.sensor.name);
    _descriptionController = TextEditingController(
      text: widget.sensor.description,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      final cubit = context.read<SensorCubit>();
      final updatedSensor = widget.sensor.copyWith(
        name: _nameController.text,
        description: _descriptionController.text,
      );
      cubit.updateSensorDetails(updatedSensor);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('${updatedSensor.name} updated.'),
            backgroundColor: Colors.teal,
          ),
        );
      _toggleEditMode();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Sensor' : 'Sensor Details'),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _onSave,
              tooltip: 'Save',
            )
          else
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _toggleEditMode,
              tooltip: 'Edit',
            ),
        ],
      ),
      body: BlocBuilder<SensorCubit, SensorState>(
        builder: (context, state) {
          final latestSensor = (state as SensorLoaded).displayedSensors
              .firstWhere(
                (s) => s.id == widget.sensor.id,
                orElse: () => widget.sensor,
              );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: _isEditing
                ? _buildEditView()
                : _buildReadOnlyView(latestSensor),
          );
        },
      ),
    );
  }

  Widget _buildEditView() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Sensor Name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.sensors),
            ),
            validator: (value) =>
                (value?.trim().isEmpty ?? true) ? 'Please enter a name.' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.description),
            ),
            validator: (value) => (value?.trim().isEmpty ?? true)
                ? 'Please enter a description.'
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyView(Sensor sensor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Column(
            children: [
              Text(
                'Current Temperature',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.grey.shade400),
              ),
              Text(
                '${sensor.value.toStringAsFixed(1)}°F',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: getTempColor(sensor.value),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        const SizedBox(height: 32),
        DetailItem(
          icon: Icons.sensors,
          title: 'Sensor Name',
          content: sensor.name,
        ),
        const Divider(height: 32),
        DetailItem(
          icon: Icons.description,
          title: 'Description',
          content: sensor.description,
        ),
      ],
    );
  }
}

class DetailItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const DetailItem({
    super.key,
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.grey.shade400, size: 28),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: Colors.grey.shade500),
              ),
              const SizedBox(height: 4),
              Text(content, style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
        ),
      ],
    );
  }
}
