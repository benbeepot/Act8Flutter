import 'package:flutter/material.dart';

import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';

enum ReportUiState { idle, loading, success, empty, error }

class ReportFormScreen extends StatefulWidget {
  const ReportFormScreen({super.key});

  @override
  State<ReportFormScreen> createState() => _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();

  ReportUiState _uiState = ReportUiState.idle;
  bool _simulateFailure = false;

  Future<void> submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _uiState = ReportUiState.loading;
    });

    try {
      // Simulates an asynchronous request.
      await Future<void>.delayed(const Duration(seconds: 3));

      if (_simulateFailure) {
        throw Exception('Simulated failure');
      }

      if (!mounted) return;

      setState(() {
        _uiState = ReportUiState.success;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _uiState = ReportUiState.error;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Widget buildStateMessage(IconData icon, String title, String message) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 65),
        const SizedBox(height: 15),
        Text(
          title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(message, textAlign: TextAlign.center),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_uiState == ReportUiState.loading) {
      content = buildStateMessage(
        Icons.hourglass_top,
        'Loading...',
        'Your report is being processed.',
      );
    } else if (_uiState == ReportUiState.success) {
      content = Column(
        children: [
          buildStateMessage(
            Icons.check_circle,
            'Success!',
            'Your report was submitted successfully.\n'
                'This is a simulated submission.',
          ),
          AppButton(
            text: 'Back to Form',
            onPressed: () {
              setState(() {
                _uiState = ReportUiState.idle;
              });
            },
          ),
        ],
      );
    } else if (_uiState == ReportUiState.empty) {
      content = Column(
        children: [
          buildStateMessage(
            Icons.inbox,
            'No Reports Available',
            'There are no reports to display yet.',
          ),
          AppButton(
            text: 'Create a Report',
            onPressed: () {
              setState(() {
                _uiState = ReportUiState.idle;
              });
            },
          ),
        ],
      );
    } else if (_uiState == ReportUiState.error) {
      content = Column(
        children: [
          buildStateMessage(
            Icons.error,
            'Submission Failed',
            'Something went wrong. Please try again.',
          ),
          AppButton(text: 'Retry', onPressed: submitReport),
          AppButton(
            text: 'Edit Form',
            onPressed: () {
              setState(() {
                _uiState = ReportUiState.idle;
              });
            },
          ),
        ],
      );
    } else {
      content = Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Submit a Report',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            AppTextField(
              label: 'Report Title',
              controller: _titleController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a report title';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            AppTextField(
              label: 'Category',
              controller: _categoryController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a category';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            AppTextField(
              label: 'Description',
              controller: _descriptionController,
              maxLines: 3,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Simulate submission error'),
              value: _simulateFailure,
              onChanged: (value) {
                setState(() {
                  _simulateFailure = value ?? false;
                });
              },
            ),
            const SizedBox(height: 10),
            AppButton(text: 'Submit Report', onPressed: submitReport),
            const SizedBox(height: 10),
            AppButton(
              text: 'View Reports',
              onPressed: () {
                setState(() {
                  _uiState = ReportUiState.empty;
                });
              },
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Lockin - Report Form')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: content,
          ),
        ),
      ),
    );
  }
}
