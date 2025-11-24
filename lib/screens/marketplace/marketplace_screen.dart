// lib/screens/marketplace/marketplace_screen.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';


import '../../services/marketplace_service.dart';
import '../../models/marketplace_item.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  final _service = MarketplaceService.instance;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _service.fetchItems();
  }

  Future<void> _openAddItemSheet() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return _AddItemSheet(
          picker: _picker,
          onItemCreated: () {
            // refresh kalau perlu (sebenarnya stream sudah update)
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Marketplace Sayuran'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed('marketplace-add-item'),
        icon: const Icon(Icons.add),
        label: const Text('Jual Sayuran'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Marketplace Sayuran',
                  style:
                      theme.textTheme.displayLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  'Warga bisa menjual hasil panen sayuran secara mudah.',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.97),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: StreamBuilder<List<MarketplaceItem>>(
                      stream: _service.items$,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting &&
                            !snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Gagal memuat data.\n${snapshot.error}',
                              textAlign: TextAlign.center,
                            ),
                          );
                        }

                        final items = snapshot.data ?? [];

                        if (items.isEmpty) {
                          return const Center(
                            child: Text('Belum ada sayuran yang dijual.'),
                          );
                        }

                        return ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: items.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return _MarketplaceCard(item: item);
                          },
                        );
                      },
                    ),
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

class _MarketplaceCard extends StatelessWidget {
  final MarketplaceItem item;

  const _MarketplaceCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          if (item.imageUrl != null)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                bottomLeft: Radius.circular(18),
              ),
              child: Image.network(
                item.imageUrl!,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
            )
          else
            Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                ),
                color: Color(0xFFE2E8F0),
              ),
              child: const Icon(Icons.local_florist, size: 32),
            ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  if (item.description != null && item.description!.isNotEmpty)
                    Text(
                      item.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium,
                    ),
                  const SizedBox(height: 6),
                  Text(
                    'Rp ${item.price.toStringAsFixed(0)}'
                    '${item.unit != null ? ' / ${item.unit}' : ''}',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddItemSheet extends StatefulWidget {
  final ImagePicker picker;
  final VoidCallback onItemCreated;

  const _AddItemSheet({
    required this.picker,
    required this.onItemCreated,
  });

  @override
  State<_AddItemSheet> createState() => _AddItemSheetState();
}

class _AddItemSheetState extends State<_AddItemSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleC = TextEditingController();
  final _priceC = TextEditingController();
  final _descC = TextEditingController();
  final _unitC = TextEditingController();

  File? _imageFile;
  bool _loading = false;

  Future<void> _pickFromCamera() async {
    final picked = await widget.picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1200,
      imageQuality: 85,
    );
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      await MarketplaceService.instance.addItem(
        title: _titleC.text.trim(),
        price: double.parse(_priceC.text.trim()),
        description: _descC.text.trim().isEmpty ? null : _descC.text.trim(),
        unit: _unitC.text.trim().isEmpty ? null : _unitC.text.trim(),
        imageFile: _imageFile,
      );

      widget.onItemCreated();
      if (mounted) Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berhasil menambahkan sayuran')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: bottom + 16,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Jual Sayuran',
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 12),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _pickFromCamera,
                        child: Container(
                          height: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: const Color(0xFFF1F5F9),
                          ),
                          child: _imageFile == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.camera_alt, size: 32),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Ambil foto sayuran',
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ],
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.file(
                                    _imageFile!,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _titleC,
                        decoration:
                            const InputDecoration(labelText: 'Nama sayuran'),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Wajib diisi' : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _priceC,
                        decoration:
                            const InputDecoration(labelText: 'Harga (Rp)'),
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Wajib diisi' : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _unitC,
                        decoration: const InputDecoration(
                            labelText: 'Satuan (contoh: kg, ikat)'),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _descC,
                        decoration:
                            const InputDecoration(labelText: 'Deskripsi'),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _submit,
                          child: _loading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text('Pasang di Marketplace'),
                        ),
                      ),
                    ],
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
