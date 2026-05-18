import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../blocs/item/item_bloc.dart';
import '../blocs/item/item_event.dart';
import '../blocs/item/item_state.dart';
import '../models/item_model.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';
import '../widgets/item_card.dart';
import '../widgets/common_widgets.dart';
import 'add_item_screen.dart';
import 'edit_item_screen.dart';
import 'item_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedStatus;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    context.read<ItemBloc>().add(const FetchItemsEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showDeleteDialog(BuildContext context, ItemModel item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Remove Item',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        content: Text(
          'Are you sure you want to remove "${item.title}"? This action cannot be undone.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            color: AppTheme.textMedium,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: GoogleFonts.plusJakartaSans(
                color: AppTheme.textMedium,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lostRed,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<ItemBloc>().add(DeleteItemEvent(item.id!));
            },
            child: Text(
              'Remove',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceWhite,
      appBar: _buildAppBar(),
      body: BlocConsumer<ItemBloc, ItemState>(
        listener: (context, state) {
          if (state is ItemSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded,
                        color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Text(state.message),
                  ],
                ),
                backgroundColor: AppTheme.foundTeal,
                duration: const Duration(seconds: 2),
              ),
            );
            // Transition to loaded state with the new items
            context.read<ItemBloc>().add(const FetchItemsEvent());
          } else if (state is ItemOperationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error_outline_rounded,
                        color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Expanded(child: Text(state.message)),
                  ],
                ),
                backgroundColor: AppTheme.lostRed,
                duration: const Duration(seconds: 3),
                action: SnackBarAction(
                  label: 'Retry',
                  textColor: Colors.white,
                  onPressed: () =>
                      context.read<ItemBloc>().add(const FetchItemsEvent()),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              _buildSearchAndFilter(context, state),
              Expanded(child: _buildBody(context, state)),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddItemScreen()),
        ),
        icon: const Icon(Icons.add_rounded),
        label: Text(
          'Report Item',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child:
                const Icon(Icons.search_rounded, size: 18, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FindIt AAU',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.3,
                ),
              ),
              Text(
                'Campus Lost & Found',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.75),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded),
          onPressed: () {
            context.read<ItemBloc>().add(const FetchItemsEvent());
          },
          tooltip: 'Refresh',
        ),
      ],
    );
  }

  Widget _buildSearchAndFilter(BuildContext context, ItemState state) {
    final hasActiveFilters =
        _selectedStatus != null || _selectedCategory != null;

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (q) =>
                  context.read<ItemBloc>().add(SearchItemsEvent(q)),
              decoration: InputDecoration(
                hintText: 'Search by title, location, category...',
                prefixIcon: const Icon(Icons.search_rounded,
                    color: AppTheme.textLight, size: 20),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded,
                            color: AppTheme.textLight, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          context
                              .read<ItemBloc>()
                              .add(const SearchItemsEvent(''));
                        },
                      )
                    : null,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                filled: true,
                fillColor: AppTheme.surfaceWhite,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.divider),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.divider),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                      color: AppTheme.primaryGreen, width: 1.5),
                ),
              ),
            ),
          ),

          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              children: [
                // Status filters
                CategoryChip(
                  label: '🔍 Lost',
                  isSelected: _selectedStatus == AppConstants.statusLost,
                  onTap: () {
                    setState(() {
                      _selectedStatus =
                          _selectedStatus == AppConstants.statusLost
                              ? null
                              : AppConstants.statusLost;
                    });
                    context.read<ItemBloc>().add(FilterItemsEvent(
                          status: _selectedStatus,
                          category: _selectedCategory,
                        ));
                  },
                ),
                const SizedBox(width: 8),
                CategoryChip(
                  label: '✅ Found',
                  isSelected: _selectedStatus == AppConstants.statusFound,
                  onTap: () {
                    setState(() {
                      _selectedStatus =
                          _selectedStatus == AppConstants.statusFound
                              ? null
                              : AppConstants.statusFound;
                    });
                    context.read<ItemBloc>().add(FilterItemsEvent(
                          status: _selectedStatus,
                          category: _selectedCategory,
                        ));
                  },
                ),
                const SizedBox(width: 12),
                const SizedBox(
                  height: 20,
                  child: VerticalDivider(thickness: 1),
                ),
                const SizedBox(width: 12),

                // Category filters
                ...AppConstants.categories.map((cat) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: CategoryChip(
                      label: cat,
                      isSelected: _selectedCategory == cat,
                      onTap: () {
                        setState(() {
                          _selectedCategory =
                              _selectedCategory == cat ? null : cat;
                        });
                        context.read<ItemBloc>().add(FilterItemsEvent(
                              status: _selectedStatus,
                              category: _selectedCategory,
                            ));
                      },
                    ),
                  );
                }),

                if (hasActiveFilters) ...[
                  const SizedBox(width: 4),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedStatus = null;
                        _selectedCategory = null;
                        _searchController.clear();
                      });
                      context.read<ItemBloc>().add(const ClearFiltersEvent());
                    },
                    icon: const Icon(Icons.clear_all_rounded, size: 16),
                    label: Text(
                      'Clear',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.lostRed,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const Divider(height: 1, color: AppTheme.divider),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, ItemState state) {
    if (state is ItemLoading) {
      return const LoadingWidget(message: 'Fetching items...');
    }

    if (state is ItemError) {
      return AppErrorWidget(
        message: state.message,
        onRetry: () => context.read<ItemBloc>().add(const FetchItemsEvent()),
      );
    }

    List<ItemModel> items = [];

    if (state is ItemLoaded) {
      items = state.filteredItems;
    } else if (state is ItemSubmitting) {
      return const LoadingWidget(message: 'Processing...');
    }

    if (items.isEmpty) {
      return EmptyStateWidget(
        title: 'Nothing here yet',
        subtitle:
            'Be the first to report a lost or found item on the AAU campus.',
        onAction: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddItemScreen()),
        ),
        actionLabel: 'Report Item',
      );
    }

    return RefreshIndicator(
      color: AppTheme.primaryGreen,
      onRefresh: () async {
        context.read<ItemBloc>().add(const FetchItemsEvent());
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 100),
        itemCount: items.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildListHeader(items.length);
          }
          final item = items[index - 1];
          return ItemCard(
            item: item,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ItemDetailScreen(item: item)),
            ),
            onEdit: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => EditItemScreen(item: item)),
            ),
            onDelete: () => _showDeleteDialog(context, item),
          );
        },
      ),
    );
  }

  Widget _buildListHeader(int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          Text(
            '$count ${count == 1 ? 'item' : 'items'} found',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppTheme.textLight,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
