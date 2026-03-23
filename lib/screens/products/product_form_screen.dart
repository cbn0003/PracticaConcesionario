import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product_model.dart';
import '../../providers/product_provider.dart';
import '../../core/theme.dart';

class ProductFormScreen extends StatefulWidget {
  final ProductModel? product;

  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _priceCtrl;
  late TextEditingController _stockCtrl;
  String _category = 'Coche';

  final List<String> _categories = ['Coche', 'Moto', 'Furgoneta'];
  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.product != null;
    _nameCtrl = TextEditingController(text: widget.product?.name ?? '');
    _descCtrl = TextEditingController(text: widget.product?.description ?? '');
    _priceCtrl = TextEditingController(
        text: widget.product?.price.toString() ?? '');
    _stockCtrl = TextEditingController(
        text: widget.product?.stock.toString() ?? '');
    _category = widget.product?.category ?? 'Coche';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _stockCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final provider = context.read<ProductProvider>();
    final product = ProductModel(
      id: widget.product?.id ?? '',
      name: _nameCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      category: _category,
      price: double.parse(_priceCtrl.text),
      stock: int.parse(_stockCtrl.text),
    );

    if (_isEditing) {
      await provider.updateProduct(product);
    } else {
      await provider.addProduct(product);
    }

    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pop(context);
    }
  }

  // Estilo compartido para todos los campos
  InputDecoration _inputDecoration(String label, {String? suffix}) {
    return InputDecoration(
      labelText: label,
      suffixText: suffix,
      labelStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 14),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar producto' : 'Nuevo producto'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nombre
              TextFormField(
                controller: _nameCtrl,
                decoration: _inputDecoration('Nombre'),
                validator: (v) =>
                v == null || v.isEmpty ? 'Campo obligatorio' : null,
              ),
              const SizedBox(height: 16),

              // Descripción
              TextFormField(
                controller: _descCtrl,
                decoration: _inputDecoration('Descripción'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Categoría
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: _inputDecoration('Categoría'),
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _category = v!),
              ),
              const SizedBox(height: 16),

              // Precio
              TextFormField(
                controller: _priceCtrl,
                decoration: _inputDecoration('Precio', suffix: '€'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Campo obligatorio';
                  if (double.tryParse(v) == null) return 'Número no válido';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Stock
              TextFormField(
                controller: _stockCtrl,
                decoration: _inputDecoration('Cantidad en stock'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Campo obligatorio';
                  if (int.tryParse(v) == null) return 'Número entero requerido';
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Botón guardar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _save,
                  child: _isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : Text(
                      _isEditing ? 'Guardar cambios' : 'Añadir producto'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}