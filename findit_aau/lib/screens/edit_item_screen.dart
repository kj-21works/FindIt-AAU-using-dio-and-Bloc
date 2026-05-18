import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../blocs/item/item_bloc.dart';
import '../blocs/item/item_event.dart';
import '../blocs/item/item_state.dart';
import '../models/item_model.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';
import '../widgets/common_widgets.dart';

class EditItemScreen extends StatefulWidget {
  final ItemModel item;

  const EditItemScreen({super.key, required this.item});

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _imageUrlCtrl;
  late final TextEditingController _contactCtrl;

  late String _selectedCategory;
  late String _selectedLocation;
  late String _selectedStatus;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    // Pre-populate with existing item data
    _titleCtrl = TextEditingController(text: widget.item.title);
    _descCtrl = TextEditingController(text: widget.item.description);
    _imageUrlCtrl = TextEditingController(text: widget.item.imageUrl);
    _contactCtrl = TextEditingController(text: widget.item.contactInfo);

    _selectedCategory = AppConstants.categories.contains(widget.item.category)
        ? widget.item.category
        : AppConstants.categories.first;

    _selectedLocation = AppConstants.locations.contains(widget.item.location)
        ? widget.item.location
        : AppConstants.locations.first;

    _selectedStatus = widget.item.status;

    try {
      _selectedDate = DateTime.parse(widget.item.date);
    } catch (_) {
      _selectedDate = DateTime.now();
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _imageUrlCtrl.dispose();
    _contactCtrl.dispose();
    super.dispose();
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: AppTheme.primaryGreen),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final updatedItem = widget.item.copyWith(
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      category: _selectedCategory,
      imageUrl: _imageUrlCtrl.text.trim().isEmpty
          ? AppConstants.placeholderImage
          : _imageUrlCtrl.text.trim(),
      location: _selectedLocation,
      contactInfo: _contactCtrl.text.trim(),
      status: _selectedStatus,
      date: _selectedDate.toIso8601String(),
    );

    context.read<ItemBloc>().add(UpdateItemEvent(updatedItem));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ItemBloc, ItemState>(
      listener: (context, state) {
        if (state is ItemSuccess) {
          Navigator.pop(context);
        } else if (state is ItemOperationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppTheme.lostRed,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.surfaceWhite,
        appBar: AppBar(
          title: const Text('Edit Item'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocBuilder<ItemBloc, ItemState>(
          builder: (context, state) {
            final isLoading = state is ItemSubmitting;
            return Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Edit notice banner
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: AppTheme.lightGreen,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppTheme.accentGreen.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline_rounded,
                            color: AppTheme.primaryGreen, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Editing: "${widget.item.title}"',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              color: AppTheme.primaryGreen,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  _buildSectionHeader('Status'),
                  const SizedBox(height: 12),
                  _buildStatusToggle(),
                  const SizedBox(height: 20),

                  _buildSectionHeader('Item Details'),
                  const SizedBox(height: 12),

                  CustomTextField(
                    label: 'Item Title *',
                    controller: _titleCtrl,
                    prefixIcon: const Icon(Icons.title_rounded, size: 20),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Title is required'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    label: 'Description *',
                    controller: _descCtrl,
                    maxLines: 3,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Description is required'
                        : null,
                  ),
                  const SizedBox(height: 20),

                  _buildSectionHeader('Classification'),
                  const SizedBox(height: 12),

                  _buildDropdown(
                    label: 'Category *',
                    value: _selectedCategory,
                    items: AppConstants.categories,
                    icon: Icons.category_rounded,
                    onChanged: (v) => setState(() => _selectedCategory = v!),
                  ),
                  const SizedBox(height: 16),

                  _buildDropdown(
                    label: 'Campus Location *',
                    value: _selectedLocation,
                    items: AppConstants.locations,
                    icon: Icons.location_on_rounded,
                    onChanged: (v) => setState(() => _selectedLocation = v!),
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    label: 'Date *',
                    controller: TextEditingController(
                      text: DateFormat('MMM d, yyyy').format(_selectedDate),
                    ),
                    prefixIcon:
                        const Icon(Icons.calendar_today_rounded, size: 18),
                    suffixIcon: const Icon(Icons.arrow_drop_down_rounded),
                    readOnly: true,
                    onTap: _pickDate,
                  ),
                  const SizedBox(height: 20),

                  _buildSectionHeader('Contact & Image'),
                  const SizedBox(height: 12),

                  CustomTextField(
                    label: 'Contact Info *',
                    controller: _contactCtrl,
                    prefixIcon:
                        const Icon(Icons.contact_phone_rounded, size: 20),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Contact info is required'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    label: 'Image URL (optional)',
                    controller: _imageUrlCtrl,
                    prefixIcon: const Icon(Icons.image_rounded, size: 20),
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: 32),

                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          label: 'Discard',
                          isOutlined: true,
                          onPressed: () => Navigator.pop(context),
                          icon: Icons.close_rounded,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: CustomButton(
                          label: 'Save Changes',
                          onPressed: isLoading ? null : _submit,
                          isLoading: isLoading,
                          icon: Icons.check_rounded,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: AppTheme.textLight,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildStatusToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () =>
                  setState(() => _selectedStatus = AppConstants.statusLost),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: _selectedStatus == AppConstants.statusLost
                      ? AppTheme.lostRed
                      : Colors.transparent,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(11),
                    bottomLeft: Radius.circular(11),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_rounded,
                        size: 18,
                        color: _selectedStatus == AppConstants.statusLost
                            ? Colors.white
                            : AppTheme.textMedium),
                    const SizedBox(width: 8),
                    Text(
                      'Lost Item',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _selectedStatus == AppConstants.statusLost
                            ? Colors.white
                            : AppTheme.textMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () =>
                  setState(() => _selectedStatus = AppConstants.statusFound),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: _selectedStatus == AppConstants.statusFound
                      ? AppTheme.foundTeal
                      : Colors.transparent,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(11),
                    bottomRight: Radius.circular(11),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_rounded,
                        size: 18,
                        color: _selectedStatus == AppConstants.statusFound
                            ? Colors.white
                            : AppTheme.textMedium),
                    const SizedBox(width: 8),
                    Text(
                      'Found Item',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _selectedStatus == AppConstants.statusFound
                            ? Colors.white
                            : AppTheme.textMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required IconData icon,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20, color: AppTheme.textLight),
      ),
      style: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        color: AppTheme.textDark,
        fontWeight: FontWeight.w500,
      ),
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(12),
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
    );
  }
}
