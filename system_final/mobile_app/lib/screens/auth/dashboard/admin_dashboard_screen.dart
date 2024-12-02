import 'package:feedback_app/models/feedback_message.dart';
import 'package:flutter/material.dart';
import '../../../services/search_history_service.dart';
import '../../../services/auth_service.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  final SearchHistoryService _searchHistoryService = SearchHistoryService();
  final AuthService _authService = AuthService();
  
  List<UserSearchHistory> _searchHistory = [];
  bool _showSearchHistory = false;
  bool _isLoading = false;

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
    setState(() => _isLoading = true);
    try {
      final history = await _searchHistoryService.getSearchHistory();
      setState(() => _searchHistory = history);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading search history: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) return;

    try {
      // Perform the search and save to history
      await _searchHistoryService.saveSearchHistory(query, null);
      await _loadSearchHistory(); // Reload history after saving
      setState(() => _showSearchHistory = false);
      
      // Implement your search logic here
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error performing search: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search users...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _showSearchHistory = false);
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onSubmitted: _performSearch,
            ),
          ),
          if (_showSearchHistory && _searchHistory.isNotEmpty)
            Expanded(
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  itemCount: _searchHistory.length,
                  itemBuilder: (context, index) {
                    final history = _searchHistory[index];
                    return ListTile(
                      leading: const Icon(Icons.history),
                      title: Text(history.searchQuery),
                      subtitle: Text(history.searchedAt.toString()),
                      onTap: () {
                        _searchController.text = history.searchQuery;
                        _performSearch(history.searchQuery);
                      },
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}