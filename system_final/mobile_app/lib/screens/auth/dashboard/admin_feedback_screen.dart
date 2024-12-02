import 'package:flutter/material.dart';
import '../../../models/feedback_message.dart';
import '../../../services/feedback_service.dart';

class AdminFeedbackScreen extends StatefulWidget {
  const AdminFeedbackScreen({super.key});

  @override
  State<AdminFeedbackScreen> createState() => _AdminFeedbackScreenState();
}

class _AdminFeedbackScreenState extends State<AdminFeedbackScreen> {
  final _searchController = TextEditingController();
  final _feedbackService = FeedbackService();
  List<FeedbackMessage> _feedbackMessages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFeedback();
  }

  Future<void> _loadFeedback() async {
    setState(() => _isLoading = true);
    try {
      final messages = await _feedbackService.searchFeedback(_searchController.text);
      setState(() => _feedbackMessages = messages);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback Management'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search feedback...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _loadFeedback();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onSubmitted: (_) => _loadFeedback(),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _feedbackMessages.length,
                    itemBuilder: (context, index) {
                      final feedback = _feedbackMessages[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ListTile(
                          title: Text('Rating: ${feedback.rating} stars'),
                          subtitle: Text(feedback.message),
                          trailing: Text(
                            feedback.createdAt.toString().split('.')[0],
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
} 