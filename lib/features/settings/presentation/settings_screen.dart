import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../providers/personalised_feed_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _breakingNewsNotifications = true;
  bool _dailyDigestNotifications = false;
  String _selectedLanguage = 'English';

  @override
  void initState() {
    super.initState();
    _loadLanguagePreference();
  }

  Future<void> _loadLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('newsx_preferred_language') ?? 'English';
    });
  }

  Future<void> _saveLanguagePreference(String lang) async {
    setState(() => _selectedLanguage = lang);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('newsx_preferred_language', lang);
    ref.read(personalisedFeedProvider.notifier).loadFeed();
  }

  void _showLanguageDialog() {
    final languages = [
      'English',
      'Hindi (हिंदी)',
      'Marathi (मराठी)',
      'Tamil (தமிழ்)',
      'Telugu (తెలుగు)',
      'Gujarati (ગુજરાતી)',
      'Bengali (বাংলা)',
      'Kannada (ಕನ್ನಡ)',
      'Malayalam (मलयज)',
      'Punjabi (ਪੰਜਾਬੀ)'
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select News Language',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: languages.length,
                  itemBuilder: (context, index) {
                    final lang = languages[index];
                    final isSelected = _selectedLanguage == lang || _selectedLanguage == lang.split(' ')[0];
                    return ListTile(
                      title: Text(lang),
                      trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: AppColors.primary) : null,
                      onTap: () {
                        _saveLanguagePreference(lang.split(' ')[0]);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showInfoModal(String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentThemeMode = ref.watch(themeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Appearance Header
          const _SettingsSectionHeader(title: 'APPEARANCE'),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: const Text('App Theme'),
            subtitle: Text(
              currentThemeMode == ThemeMode.dark
                  ? 'Dark Mode'
                  : currentThemeMode == ThemeMode.light
                      ? 'Light Mode'
                      : 'System Default',
            ),
            trailing: SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(value: ThemeMode.light, icon: Icon(Icons.light_mode, size: 16)),
                ButtonSegment(value: ThemeMode.dark, icon: Icon(Icons.dark_mode, size: 16)),
                ButtonSegment(value: ThemeMode.system, icon: Icon(Icons.brightness_auto, size: 16)),
              ],
              selected: {currentThemeMode},
              onSelectionChanged: (Set<ThemeMode> newSelection) {
                ref.read(themeProvider.notifier).setThemeMode(newSelection.first);
              },
            ),
          ),
          const Divider(),
          // Notifications Section
          const _SettingsSectionHeader(title: 'NOTIFICATIONS'),
          SwitchListTile(
            secondary: const Icon(Icons.bolt_outlined),
            title: const Text('Breaking News Alerts'),
            subtitle: const Text('Receive instant notifications for major Indian & national news events'),
            value: _breakingNewsNotifications,
            onChanged: (val) => setState(() => _breakingNewsNotifications = val),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.mark_email_read_outlined),
            title: const Text('Daily Morning Digest'),
            subtitle: const Text('Get a curated 25-word news briefing every morning'),
            value: _dailyDigestNotifications,
            onChanged: (val) => setState(() => _dailyDigestNotifications = val),
          ),
          const Divider(),
          // Content & Preferences
          const _SettingsSectionHeader(title: 'PREFERENCES'),
          ListTile(
            leading: const Icon(Icons.language_outlined),
            title: const Text('News Language'),
            subtitle: Text(_selectedLanguage),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: _showLanguageDialog,
          ),
          const Divider(),
          // About & Legal
          const _SettingsSectionHeader(title: 'ABOUT & LEGAL'),
          ListTile(
            leading: const Icon(Icons.info_outline_rounded),
            title: const Text('About ${AppConstants.appName}'),
            subtitle: const Text('${AppConstants.appName} - ${AppConstants.appTagline}'),
            onTap: () => _showInfoModal(
              'About ${AppConstants.appName}',
              '${AppConstants.appName} is an AI-powered smart news application providing 25-word briefings, native sharing, and full publisher reading experience.',
            ),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            onTap: () => _showInfoModal(
              'Privacy Policy',
              'NewsX values user privacy. Personal account preferences and authentication tokens are stored securely.',
            ),
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('Terms of Service'),
            onTap: () => _showInfoModal(
              'Terms of Service',
              'Standard terms apply for using ${AppConstants.appName} services and news aggregation feeds.',
            ),
          ),
          const SizedBox(height: 32),
          // App Version Footer
          Center(
            child: Column(
              children: [
                Text(
                  '${AppConstants.appName} v${AppConstants.appVersion}+${AppConstants.buildNumber}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Crafted with Flutter & Riverpod',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSectionHeader extends StatelessWidget {
  final String title;

  const _SettingsSectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}
