import 'package:feedback_app/models/search_history.dart';
import 'package:feedback_app/screens/auth/dashboard/admin_feedback_screen.dart';
import 'package:feedback_app/screens/auth/dashboard/hotel_details_sheet.dart';
import 'package:feedback_app/widgets/animated_hotel_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/auth/auth_event.dart';
import '../../../blocs/auth/auth_state.dart';
import '../../../models/hotel.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _filterRating = 'all';
  List<SearchHistory> _searchHistory = [];
  bool _showSearchHistory = false;

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
    _searchController.addListener(() {
      setState(() {
        _showSearchHistory = _searchController.text.isNotEmpty;
      });
    });
  }

  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('search_history') ?? [];
    setState(() {
      _searchHistory = history
          .map((item) => SearchHistory.fromJson(json.decode(item)))
          .toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    });
  }

  Future<void> _saveSearchQuery(String query) async {
    if (query.isEmpty) return;

    final history = SearchHistory(
      query: query,
      timestamp: DateTime.now(),
    );

    setState(() {
      _searchHistory.insert(0, history);
      if (_searchHistory.length > 5) {
        _searchHistory.removeLast();
      }
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'search_history',
      _searchHistory.map((item) => json.encode(item.toJson())).toList(),
    );
  }

  List<Hotel> get filteredHotels {
    return dummyHotels.where((hotel) {
      final matchesSearch = hotel.name
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          hotel.description.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesRating =
          _filterRating == 'all' || hotel.rating >= double.parse(_filterRating);
      return matchesSearch && matchesRating;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Hotels'),
              actions: [
                PopupMenuButton<String>(
                  icon: const Icon(Icons.filter_list),
                  onSelected: (value) {
                    setState(() {
                      _filterRating = value;
                    });
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                        value: 'all', child: Text('All Ratings')),
                    const PopupMenuItem(value: '4', child: Text('4+ Stars')),
                    const PopupMenuItem(
                        value: '4.5', child: Text('4.5+ Stars')),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    context.read<AuthBloc>().add(LogoutEvent());
                    Navigator.of(context).pushReplacementNamed('/');
                  },
                ),
                if (state.user.role == 'admin')
                  IconButton(
                    icon: const Icon(Icons.feedback),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminFeedbackScreen(),
                        ),
                      );
                    },
                  ),
              ],
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search hotels...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _searchQuery = '';
                                      _showSearchHistory = false;
                                    });
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onSubmitted: (value) {
                          _saveSearchQuery(value);
                          setState(() {
                            _searchQuery = value;
                            _showSearchHistory = false;
                          });
                        },
                      ),
                      if (_showSearchHistory && _searchHistory.isNotEmpty)
                        Card(
                          margin: const EdgeInsets.only(top: 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: _searchHistory.map((history) {
                              return ListTile(
                                leading: const Icon(Icons.history),
                                title: Text(history.query),
                                trailing: Text(
                                  _formatDate(history.timestamp),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                onTap: () {
                                  _searchController.text = history.query;
                                  setState(() {
                                    _searchQuery = history.query;
                                    _showSearchHistory = false;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: ListView.builder(
                      key: ValueKey<String>('$_searchQuery$_filterRating'),
                      itemCount: filteredHotels.length,
                      itemBuilder: (context, index) {
                        final hotel = filteredHotels[index];
                        return AnimatedHotelCard(
                          hotel: hotel,
                          onTap: () => _showHotelDetails(context, hotel),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showHotelDetails(BuildContext context, Hotel hotel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => HotelDetailsSheet(
          hotel: hotel,
          scrollController: scrollController,
        ),
      ),
    );
  }
}
