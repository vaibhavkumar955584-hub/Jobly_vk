import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    _nameController = TextEditingController(text: user?.name);
    _bioController = TextEditingController(text: user?.bio ?? 'Passionate professional looking for new opportunities.');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    
    final success = await context.read<AuthProvider>().updateProfile(
      _nameController.text.trim(),
      _bioController.text.trim(),
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          auth.isLoading 
            ? const Center(child: Padding(padding: EdgeInsets.only(right: 16), child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))))
            : TextButton(
                onPressed: _saveProfile,
                child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: AppTheme.background,
                      child: Icon(Icons.person, size: 60, color: AppTheme.textSecondary),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppTheme.joblyBlue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit, size: 20, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              const Text('Personal Information', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) => value == null || value.isEmpty ? 'Name cannot be empty' : null,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                initialValue: user?.email,
                decoration: const InputDecoration(labelText: 'Email Address'),
                enabled: false,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _bioController,
                decoration: const InputDecoration(labelText: 'Bio'),
                maxLines: 3,
              ),
              
              const SizedBox(height: 32),
              const Text('Documents', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 12),
              
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.description, color: AppTheme.joblyBlue),
                title: const Text('Resume / CV'),
                subtitle: const Text('Updated 2 days ago'),
                trailing: const Icon(Icons.upload_file),
                onTap: () {
                   ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Upload resume functionality triggered')),
                  );
                },
              ),
              
              const SizedBox(height: 32),
              const Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.delete_outline, color: AppTheme.error),
                title: const Text('Delete Account', style: TextStyle(color: AppTheme.error)),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Account?'),
                      content: const Text('This action is permanent and cannot be undone.'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                        TextButton(
                          onPressed: () {
                             context.read<AuthProvider>().logout();
                             Navigator.pop(context);
                             Navigator.pop(context);
                          }, 
                          child: const Text('Delete', style: TextStyle(color: AppTheme.error)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
