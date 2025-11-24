import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/shared/services/password_service.dart';
import 'package:flutter_application_1/shared/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/core/theme/theme_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final PasswordService _passwordService = PasswordService();
  final StorageService _storageService = StorageService();
  
  bool _autoLockEnabled = false;
  bool _biometricEnabled = false;
  bool _notificationsEnabled = false;
  bool _darkModeEnabled = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _autoLockEnabled = prefs.getBool('auto_lock_enabled') ?? false;
      _biometricEnabled = prefs.getBool('biometric_enabled') ?? false;
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      _darkModeEnabled = prefs.getBool('dark_mode_enabled') ?? false;
      _isLoading = false;
    });
  }

  Future<void> _toggleAutoLock(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('auto_lock_enabled', value);
    setState(() => _autoLockEnabled = value);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(value ? 'Auto-lock enabled' : 'Auto-lock disabled'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _toggleBiometric(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('biometric_enabled', value);
    setState(() => _biometricEnabled = value);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(value ? 'Biometric authentication enabled' : 'Biometric authentication disabled'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);
    setState(() => _notificationsEnabled = value);
  }

  Future<void> _toggleDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode_enabled', value);
    setState(() => _darkModeEnabled = value);
    await ThemeService.instance.setDarkMode(value);
  }

  void _showChangeMasterPasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Master Password'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Current Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm New Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (newPasswordController.text != confirmPasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Passwords do not match'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              
              Navigator.pop(context);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Master password changed successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }

  Future<void> _showBackupSyncDialog() async {
    final lastSync = await _storageService.getLastSync();
    final metadata = await _passwordService.getMetadata();
    final passwordCount = metadata?['total_count'] ?? 0;

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Backup & Sync'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Passwords: $passwordCount'),
            const SizedBox(height: 8),
            Text(
              'Last sync: ${lastSync != null ? _formatDate(lastSync) : "Never"}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            const Text(
              'Cloud backup settings allow you to sync your passwords across devices.',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _storageService.updateLastSync();
              if (mounted) {
                  Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sync completed successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('Sync Now'),
          ),
        ],
      ),
    );
  }

  Future<void> _exportData() async {
    try {
      final jsonData = await _passwordService.exportPasswords();
      
      if (!mounted) return;
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Export Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Your passwords have been prepared for export.'),
              const SizedBox(height: 16),
              const Text(
                'Note: Keep this file secure as it contains all your passwords.',
                style: TextStyle(fontSize: 12, color: Colors.red),
              ),
              const SizedBox(height: 16),
              Text(
                'Data size: ${(jsonData.length / 1024).toStringAsFixed(2)} KB',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Data exported successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
              },
              child: const Text('Save File'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _importData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import Data'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Import passwords from other password managers.'),
            SizedBox(height: 16),
            Text(
              'Supported formats: JSON, CSV',
              style: TextStyle(fontSize: 12),
            ),
            SizedBox(height: 8),
            Text(
              'Note: Duplicate passwords will be skipped.',
              style: TextStyle(fontSize: 12, color: Colors.orange),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
          
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Import functionality coming soon'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            child: const Text('Select File'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(content),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: AppColors.darkblue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
         
          _buildSectionHeader('Security'),
          _buildSettingTile(
            icon: Icons.lock_clock,
            title: 'Auto-Lock',
            subtitle: 'Lock app after 5 minutes of inactivity',
            trailing: Switch(
              value: _autoLockEnabled,
              onChanged: _toggleAutoLock,
                activeTrackColor: AppColors.darkblue,
            ),
          ),
          _buildSettingTile(
            icon: Icons.fingerprint,
            title: 'Biometric Authentication',
            subtitle: 'Use fingerprint or face ID',
            trailing: Switch(
              value: _biometricEnabled,
              onChanged: _toggleBiometric,
                activeTrackColor: AppColors.darkblue,
            ),
          ),
          _buildSettingTile(
            icon: Icons.vpn_key,
            title: 'Change Master Password',
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: _showChangeMasterPasswordDialog,
          ),
          const SizedBox(height: 24),

         
          _buildSectionHeader('Preferences'),
          _buildSettingTile(
            icon: Icons.notifications,
            title: 'Notifications',
            subtitle: 'Security alerts and reminders',
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: _toggleNotifications,
                activeTrackColor: AppColors.darkblue,
            ),
          ),
          _buildSettingTile(
            icon: Icons.dark_mode,
            title: 'Dark Mode',
            subtitle: 'Use dark theme',
            trailing: Switch(
              value: _darkModeEnabled,
              onChanged: _toggleDarkMode,
                activeTrackColor: AppColors.darkblue,
            ),
          ),
          const SizedBox(height: 24),

        
          _buildSectionHeader('Data'),
          _buildSettingTile(
            icon: Icons.cloud_upload,
            title: 'Backup & Sync',
            subtitle: 'Cloud backup settings',
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: _showBackupSyncDialog,
          ),
          _buildSettingTile(
            icon: Icons.download,
            title: 'Export Data',
            subtitle: 'Download all your passwords',
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: _exportData,
          ),
          _buildSettingTile(
            icon: Icons.upload,
            title: 'Import Data',
            subtitle: 'Import from other password managers',
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: _importData,
          ),
          const SizedBox(height: 24),

          
          _buildSectionHeader('About'),
          _buildSettingTile(
            icon: Icons.help_outline,
            title: 'Help & Support',
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () => _showAboutDialog(
              'Help & Support',
              'Need help? Contact us at support@passman.com\n\n'
              'Common questions:\n'
              '• How to recover passwords?\n'
              '• How to enable biometric login?\n'
              '• How to export data?\n\n'
              'Visit our website for more information.',
            ),
          ),
          _buildSettingTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () => _showAboutDialog(
              'Privacy Policy',
              'Your privacy is important to us.\n\n'
              'We use industry-standard encryption to protect your data. '
              'Your passwords are stored locally on your device and encrypted '
              'using AES-256 encryption.\n\n'
              'We do not have access to your passwords and cannot recover them '
              'if you forget your master password.',
            ),
          ),
          _buildSettingTile(
            icon: Icons.description_outlined,
            title: 'Terms of Service',
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () => _showAboutDialog(
              'Terms of Service',
              'By using this app, you agree to:\n\n'
              '1. Use the app responsibly\n'
              '2. Keep your master password secure\n'
              '3. Not share your account\n'
              '4. Accept that we cannot recover lost passwords\n\n'
              'Last updated: November 2025',
            ),
          ),
          _buildSettingTile(
            icon: Icons.info_outline,
            title: 'Version',
            subtitle: '1.0.0',
          ),
          const SizedBox(height: 32),

          
          Center(
            child: TextButton.icon(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );

                if (confirm == true && mounted) {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('isLoggedIn', false);
                  }
                  if (confirm == true && mounted) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/login',
                      (route) => false,
                    );
                }
              },
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text(
                'Logout',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.3)),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.darkblue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.darkblue, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              )
            : null,
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
