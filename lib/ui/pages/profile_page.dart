import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  String? photoUrl;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = context.read<AuthProvider>().currentUser;
    if (user != null) {
      nameCtrl.text = user.name ?? '';
      phoneCtrl.text = user.phone ?? '';
      photoUrl = user.photoUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          t.t('profile'),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            // GestureDetector(
            //   onTap: _pickAndUpload,
            //   child: CircleAvatar(
            //     radius: 50,
            //     backgroundColor: Colors.grey.shade200,
            //     backgroundImage: (photoUrl != null && photoUrl!.isNotEmpty)
            //         ? NetworkImage(photoUrl!)
            //         : null,
            //     child: (photoUrl == null || photoUrl!.isEmpty)
            //         ? const Icon(Icons.camera_alt, size: 30, color: Colors.grey)
            //         : null,
            //   ),
            // ),
            const SizedBox(height: 16),
            Text(
              user?.email ?? '',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            if (nameCtrl.text.isNotEmpty)
              Text(
                nameCtrl.text,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 32),
            _buildTextField(nameCtrl, 'Name'),
            const SizedBox(height: 16),
            _buildTextField(phoneCtrl, 'Phone'),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: _updateProfile,
                child: Text(
                  t.t('Update Profile'),
                  style: const TextStyle(fontSize: 16, letterSpacing: 1, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Future<void> _pickAndUpload() async {
    try {
      final auth = context.read<AuthProvider>();
      final uid = auth.currentUser?.uid;
      if (uid == null) return;

      // Request permissions
      PermissionStatus permissionStatus;
      if (Platform.isAndroid) {
        permissionStatus = await Permission.photos.request();
        if (!permissionStatus.isGranted) {
          permissionStatus = await Permission.storage.request();
        }
      } else {
        permissionStatus = await Permission.photos.request();
      }

      if (!permissionStatus.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permission denied to access photos')),
        );
        return;
      }

      // Pick image
      final picker = ImagePicker();
      final XFile? img = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (img == null) return;

      // Crop image
      final CroppedFile? cropped = await ImageCropper().cropImage(
        sourcePath: img.path,
        compressQuality: 85,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Photo',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Crop Photo',
            aspectRatioLockEnabled: true,
          ),
        ],
      );
      if (cropped == null) return;

      final file = File(cropped.path);

      // Upload to Firebase Storage
      final ref = FirebaseStorage.instance.ref().child('users/$uid/profile.jpg');
// Upload file
      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask; // Wait for completion

      // Wait for upload to complete
      if (snapshot.state == TaskState.success) {
        // Get download URL AFTER upload is fully completed
        final url = await ref.getDownloadURL();
        print('Firebase URL: $url');

        setState(() {
          photoUrl = url;
        });

        // Save to Firestore
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'name': nameCtrl.text.trim(),
          'phone': phoneCtrl.text.trim(),
          'photoUrl': url,
          'email': auth.currentUser?.email ?? '',
        }, SetOptions(merge: true));

        await auth.updateProfile(photoUrl: url);
      } else {
        throw FirebaseException(
            plugin: 'firebase_storage',
            code: 'upload-failed',
            message: 'Upload did not complete successfully');
      }
    } on FirebaseException catch (e) {
      debugPrint('Firebase error: ${e.code} - ${e.message}');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Firebase error: ${e.code}')),
        );
      }
    } catch (e, stack) {
      debugPrint('Error uploading photo: $e\n$stack');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload photo')),
        );
      }
    }
  }

  Future<void> _updateProfile() async {
    try {
      final auth = context.read<AuthProvider>();
      final uid = auth.currentUser?.uid;
      if (uid == null) return;

      final name = nameCtrl.text.trim();
      final phone = phoneCtrl.text.trim();

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': name,
        'phone': phone,
        'photoUrl': photoUrl ?? '',
        'email': auth.currentUser?.email ?? '',
      }, SetOptions(merge: true));

      await auth.updateProfile(name: name, phone: phone);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated')),
      );
    } catch (e, stack) {
      debugPrint('Error updating profile: $e\n$stack');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile')),
        );
      }
    }
  }
}
