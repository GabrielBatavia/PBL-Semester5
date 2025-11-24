// lib/screens/marketplace/add_marketplace_item_screen.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/marketplace_service.dart';

class AddMarketplaceItemScreen extends StatefulWidget {
  const AddMarketplaceItemScreen({super.key});

  @override
  State<AddMarketplaceItemScreen> createState() =>
      _AddMarketplaceItemScreenState();
}

class _AddMarketplaceItemScreenState extends State<AddMarketplaceItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleC = TextEditingController();
  final _priceC = TextEditingController();
  final _descC = TextEditingController();
  final _unitC = TextEditingController(text: 'kg');

  final _picker = ImagePicker();

  File? _imageFile;
  bool _saving = false;
  bool _analyzing = false;
  String? _aiHint;

  @override
  void dispose() {
    _titleC.dispose();
    _priceC.dispose();
    _descC.dispose();
    _unitC.dispose();
    super.dispose();
  }

  Future<void> _pick(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      maxWidth: 1200,
      imageQuality: 85,
    );
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
        _aiHint = null; // reset hasil AI kalau foto ganti
      });
    }
  }

  Future<void> _pickFromCamera() async {
    await _pick(ImageSource.camera);
  }

  Future<void> _pickFromGallery() async {
    await _pick(ImageSource.gallery);
  }

  Future<void> _analyzeWithAI() async {
    if (_imageFile == null) return;

    setState(() {
      _analyzing = true;
      _aiHint = null;
    });

    try {
      final result =
          await MarketplaceService.instance.analyzeImage(_imageFile!);

      final label = result['label']?.toString() ?? 'tidak_terdeteksi';
      final confidence = double.tryParse(
            result['confidence']?.toString() ?? '',
          ) ??
          0.0;

      setState(() {
        _aiHint =
            '$label (${(confidence * 100).toStringAsFixed(1)}% keyakinan)';
        if (_titleC.text.trim().isEmpty) {
          _titleC.text = label;
        }
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal analisa gambar: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _analyzing = false);
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    try {
      await MarketplaceService.instance.addItem(
        title: _titleC.text.trim(),
        price: double.parse(_priceC.text.trim()),
        description:
            _descC.text.trim().isEmpty ? null : _descC.text.trim(),
        unit: _unitC.text.trim().isEmpty ? null : _unitC.text.trim(),
        imageFile: _imageFile,
      );

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berhasil menambahkan sayuran')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jual Sayuran'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ----- Foto sayuran -----
                GestureDetector(
                  onTap: _pickFromCamera, // default: buka kamera
                  child: Container(
                    height: 190,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: const Color(0xFFF1F5F9),
                      border: Border.all(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    child: _imageFile == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.camera_alt, size: 40),
                              const SizedBox(height: 8),
                              Text(
                                'Ambil foto sayuran (kamera)',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Image.file(
                              _imageFile!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: _pickFromGallery,
                      icon: const Icon(Icons.photo_library_outlined),
                      label: const Text('Pilih dari galeri'),
                    ),
                    const Spacer(),
                    if (_imageFile != null)
                      TextButton.icon(
                        onPressed: _analyzing ? null : _analyzeWithAI,
                        icon: _analyzing
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.auto_awesome),
                        label: const Text('Analisa dengan AI'),
                      ),
                  ],
                ),
                if (_aiHint != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    _aiHint!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.green.shade700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                const SizedBox(height: 20),

                // ----- Form field -----
                TextFormField(
                  controller: _titleC,
                  decoration: const InputDecoration(
                    labelText: 'Nama sayuran',
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Nama wajib diisi' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _priceC,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Harga (Rp)',
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Harga wajib diisi' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _unitC,
                  decoration: const InputDecoration(
                    labelText: 'Satuan (contoh: kg, ikat, pcs)',
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descC,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi',
                  ),
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saving ? null : _submit,
                    child: _saving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Pasang di Marketplace'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
