import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/social_models.dart';
import '../../../../shared/providers/auth_provider.dart';

class EventsScreen extends ConsumerStatefulWidget {
  const EventsScreen({super.key});

  @override
  ConsumerState<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends ConsumerState<EventsScreen> {
  List<GreenityEvent> _events = [];
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Upcoming', 'This Week', 'Online', 'In-Person'];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  void _loadEvents() {
    _events = _getSampleEvents();
  }

  @override
  Widget build(BuildContext context) {
    final filteredEvents = _getFilteredEvents();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eco Events'),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showCreateEventDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                      backgroundColor: AppTheme.lightGreen.withValues(alpha: 0.2),
                      selectedColor: AppTheme.primaryGreen.withValues(alpha: 0.3),
                      labelStyle: TextStyle(
                        color: isSelected ? AppTheme.primaryGreen : AppTheme.darkGreen,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Events list
          Expanded(
            child: filteredEvents.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredEvents.length,
                    itemBuilder: (context, index) {
                      return _buildEventCard(filteredEvents[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No events found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters or create a new event!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(GreenityEvent event) {
    final isUpcoming = event.startDate.isAfter(DateTime.now());
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _showEventDetails(event),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isUpcoming 
                          ? AppTheme.primaryGreen.withValues(alpha: 0.1)
                          : Colors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isUpcoming ? 'Upcoming' : 'Past',
                      style: TextStyle(
                        color: isUpcoming ? AppTheme.primaryGreen : Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (event.isOnline)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.videocam, size: 12, color: Colors.blue[700]),
                          const SizedBox(width: 4),
                          Text(
                            'Online',
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 12),

              // Event title
              Text(
                event.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              // Event description
              Text(
                event.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),

              // Event details
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('MMM dd, yyyy').format(event.startDate),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('HH:mm').format(event.startDate),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      event.location,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Attendees and action
              Row(
                children: [
                  Text(
                    '${event.attendees.length}/${event.maxAttendees} attending',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const Spacer(),
                  if (isUpcoming)
                    ElevatedButton(
                      onPressed: () => _joinEvent(event),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryGreen,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        minimumSize: Size.zero,
                      ),
                      child: const Text(
                        'Join',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<GreenityEvent> _getFilteredEvents() {
    switch (_selectedFilter) {
      case 'Upcoming':
        return _events.where((e) => e.startDate.isAfter(DateTime.now())).toList();
      case 'This Week':
        final now = DateTime.now();
        final weekEnd = now.add(const Duration(days: 7));
        return _events.where((e) => 
          e.startDate.isAfter(now) && e.startDate.isBefore(weekEnd)
        ).toList();
      case 'Online':
        return _events.where((e) => e.isOnline).toList();
      case 'In-Person':
        return _events.where((e) => !e.isOnline).toList();
      default:
        return _events;
    }
  }

  void _showEventDetails(GreenityEvent event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(event.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event.description),
            const SizedBox(height: 16),
            Text('📅 ${DateFormat('MMM dd, yyyy HH:mm').format(event.startDate)}'),
            const SizedBox(height: 8),
            Text('📍 ${event.location}'),
            const SizedBox(height: 8),
            Text('👥 ${event.attendees.length}/${event.maxAttendees} attending'),
            if (event.isOnline && event.meetingLink != null) ...[
              const SizedBox(height: 8),
              Text('🔗 Meeting Link: ${event.meetingLink}'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          if (event.startDate.isAfter(DateTime.now()))
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _joinEvent(event);
              },
              child: const Text('Join Event'),
            ),
        ],
      ),
    );
  }

  void _joinEvent(GreenityEvent event) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Joined "${event.title}"!')),
    );
  }

  void _showCreateEventDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Event'),
        content: const Text('Event creation feature coming soon!\n\nThis will allow you to create eco-friendly events for the community.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  List<GreenityEvent> _getSampleEvents() {
    final now = DateTime.now();
    return [
      GreenityEvent(
        id: 'event1',
        title: 'Community Beach Cleanup',
        description: 'Join us for a morning of cleaning up our local beach and protecting marine life.',
        startDate: now.add(const Duration(days: 3)),
        endDate: now.add(const Duration(days: 3, hours: 3)),
        location: 'Sunset Beach, California',
        organizerId: 'org1',
        organizerName: 'Green Ocean Initiative',
        attendees: ['user1', 'user2', 'user3'],
        maxAttendees: 50,
        isOnline: false,
      ),
      GreenityEvent(
        id: 'event2',
        title: 'Sustainable Living Workshop',
        description: 'Learn practical tips for reducing your environmental footprint at home.',
        startDate: now.add(const Duration(days: 7)),
        endDate: now.add(const Duration(days: 7, hours: 2)),
        location: 'Online Event',
        organizerId: 'org2',
        organizerName: 'EcoLife Academy',
        attendees: ['user1', 'user4', 'user5', 'user6'],
        maxAttendees: 100,
        isOnline: true,
        meetingLink: 'https://meet.example.com/sustainable-living',
      ),
      GreenityEvent(
        id: 'event3',
        title: 'Urban Gardening Meetup',
        description: 'Connect with fellow urban gardeners and share tips for growing food in small spaces.',
        startDate: now.subtract(const Duration(days: 2)),
        endDate: now.subtract(const Duration(days: 2, hours: -2)),
        location: 'Central Park Community Garden',
        organizerId: 'org3',
        organizerName: 'City Growers',
        attendees: ['user2', 'user3', 'user7'],
        maxAttendees: 25,
        isOnline: false,
      ),
    ];
  }
}
