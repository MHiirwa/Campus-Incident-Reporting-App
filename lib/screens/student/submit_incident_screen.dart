import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/incident_provider.dart';
import '../../utils/validators.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/category_selector.dart';
import '../../widgets/primary_button.dart';

class SubmitIncidentScreen extends StatefulWidget {
  const SubmitIncidentScreen({super.key});

  @override
  State<SubmitIncidentScreen> createState() => _SubmitIncidentScreenState();
}

class _SubmitIncidentScreenState extends State<SubmitIncidentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  String? _category;
  bool _categoryError = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final formOk = _formKey.currentState!.validate();
    if (_category == null) setState(() => _categoryError = true);
    if (!formOk || _category == null) return;

    final provider = context.read<IncidentProvider>();
    final user = context.read<AuthProvider>().appUser!;

    final ok = await provider.submit(
      title: _titleCtrl.text,
      description: _descCtrl.text,
      category: _category!,
      location: _locationCtrl.text,
      reporter: user,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            ok ? 'Report submitted' : (provider.error ?? 'Submission failed'))));
    if (ok) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final submitting = context.watch<IncidentProvider>().submitting;

    return Scaffold(
      appBar: AppBar(title: const Text('Report an Incident')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Select a category',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                CategorySelector(
                  selected: _category,
                  errorText:
                      _categoryError ? 'Please select a category' : null,
                  onSelected: (c) => setState(() {
                    _category = c;
                    _categoryError = false;
                  }),
                ),
                const SizedBox(height: 20),
                AppTextField(
                  controller: _titleCtrl,
                  label: 'Title',
                  icon: Icons.title,
                  validator: (v) => Validators.minLength(v, 'Title', 5),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _descCtrl,
                  label: 'Description',
                  icon: Icons.notes,
                  maxLines: 5,
                  validator: (v) =>
                      Validators.minLength(v, 'Description', 10),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _locationCtrl,
                  label: 'Location (e.g. Block B, Room 204)',
                  icon: Icons.place_outlined,
                  validator: (v) => Validators.required(v, 'Location'),
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  label: 'Submit Report',
                  onPressed: _submit,
                  loading: submitting,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}