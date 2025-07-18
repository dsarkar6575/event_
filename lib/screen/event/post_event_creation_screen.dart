import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/controllers/postProvider.dart';
import 'package:provider/provider.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _placeController = TextEditingController();

  List<File> _selectedImages = [];
  DateTime? _selectedDateTime;
  bool _isLoading = false;

  Future<void> _pickImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _selectedImages = pickedFiles.map((xfile) => File(xfile.path)).toList();
      });
    }
  }

  Future<void> _pickDateTime() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (date == null) return;

    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        date.year, date.month, date.day,
        time.hour, time.minute,
      );
    });
  }

  Future<void> _submitPost() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedImages.isEmpty) {
      _showSnackbar('Select at least one image.', isError: true);
      return;
    }

    if (_selectedDateTime == null) {
      _showSnackbar('Select event date & time.', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    final provider = Provider.of<PostProvider>(context, listen: false);
    final error = await provider.createPost(
      title: _titleController.text,
      description: _descriptionController.text,
      place: _placeController.text,
      eventDateTime: _selectedDateTime!,
      images: _selectedImages,
    );

    setState(() => _isLoading = false);

    if (error == null) {
      _showSnackbar("Post created!");
      _formKey.currentState?.reset();
      _titleController.clear();
      _descriptionController.clear();
      _placeController.clear();
      setState(() {
        _selectedImages = [];
        _selectedDateTime = null;
      });
    } else {
      _showSnackbar(error, isError: true);
    }
  }

  void _showSnackbar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Event Post')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(labelText: 'Title'),
                        validator: (value) => value!.isEmpty ? 'Enter a title' : null,
                      ),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                        validator: (value) => value!.isEmpty ? 'Enter description' : null,
                      ),
                      TextFormField(
                        controller: _placeController,
                        decoration: InputDecoration(labelText: 'Place'),
                        validator: (value) => value!.isEmpty ? 'Enter place' : null,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _pickDateTime,
                        child: Text(_selectedDateTime == null
                            ? 'Select Event Date & Time'
                            : 'Selected: ${_selectedDateTime.toString()}'),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _pickImages,
                        child: const Text('Pick Images'),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: _selectedImages
                            .map((file) => Image.file(file, width: 80, height: 80, fit: BoxFit.cover))
                            .toList(),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _submitPost,
                        child: const Text('Submit Post'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
