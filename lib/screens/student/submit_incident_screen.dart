import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/incident_provider.dart';
import '../../services/storage_service.dart';
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
  XFile? _photo;
  bool _categoryError = false;
  bool _uploadingPhoto = false;

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
    String? imageUrl;

    try {
      if (_photo != null) {
        setState(() => _uploadingPhoto = true);
        imageUrl = await StorageService().uploadIncidentPhoto(
          file: File(_photo!.path),
          reporterId: user.uid,
        );
      }

      final ok = await provider.submit(
        title: _titleCtrl.text,
        description: _descCtrl.text,
        category: _category!,
        location: _locationCtrl.text,
        reporter: user,
        imageUrl: imageUrl,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ok ? 'Report submitted' : (provider.error ?? 'Submission failed'),
          ),
        ),
      );
      if (ok) Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not upload the photo. Please try again.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _uploadingPhoto = false);
    }
  }

  Future<void> _pickPhoto() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take a photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;

    final picked = await ImagePicker().pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1600,
    );
    if (picked != null && mounted) setState(() => _photo = picked);
  }

  @override
  Widget build(BuildContext context) {
    final submitting =
        context.watch<IncidentProvider>().submitting || _uploadingPhoto;

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
                const Text(
                  'Select a category',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                CategorySelector(
                  selected: _category,
                  errorText: _categoryError ? 'Please select a category' : null,
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
                  validator: (v) => Validators.minLength(v, 'Description', 10),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _locationCtrl,
                  label: 'Location (e.g. Block B, Room 204)',
                  icon: Icons.place_outlined,
                  validator: (v) => Validators.required(v, 'Location'),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Photo (optional)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                if (_photo == null)
                  OutlinedButton.icon(
                    onPressed: submitting ? null : _pickPhoto,
                    icon: const Icon(Icons.add_a_photo_outlined),
                    label: const Text('Attach a photo'),
                  )
                else
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Stack(
                      children: [
                        Image.file(
                          File(_photo!.path),
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton.filled(
                            onPressed: submitting
                                ? null
                                : () => setState(() => _photo = null),
                            icon: const Icon(Icons.close),
                            tooltip: 'Remove photo',
                          ),
                        ),
                      ],
                    ),
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
