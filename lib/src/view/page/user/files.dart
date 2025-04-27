part of 'user.dart';

final class _UserFilesPage extends StatefulWidget {
  final User user;

  const _UserFilesPage({
    required this.user,
  });

  @override
  State<_UserFilesPage> createState() => _UserFilesPageState();
}

final class _UserFilesPageState extends State<_UserFilesPage> {
  final List<String> _fileNames = [];
  bool _isLoading = false;
  String? _error;

  Future<void> _uploadFiles() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final result = await FilePicker.platform.pickFiles(allowMultiple: true);
      if (result != null && result.paths.isNotEmpty) {
        final paths = result.paths.whereType<String>().toList();
        if (paths.isNotEmpty) {
          final uploadedUrls = await FileApi.upload(paths, dir: widget.user.id);
          final newNames = uploadedUrls.map(FileApi.urlToName).toList();
          setState(() {
            // Avoid duplicates if re-uploading
            _fileNames.addAll(newNames.where((n) => !_fileNames.contains(n)));
            _isLoading = false;
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Uploaded ${newNames.length} file(s).')),
            );
          }
        } else {
           setState(() => _isLoading = false);
        }
      } else {
        // User canceled the picker
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() {
        _error = 'Upload failed: $e';
        _isLoading = false;
      });
      if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(_error!), backgroundColor: Colors.red),
         );
      }
    }
  }

  Future<void> _deleteFile(String name) async {
     // Optional: Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete "$name"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      await FileApi.delete([name], dir: widget.user.id);
      setState(() {
        _fileNames.remove(name);
        _isLoading = false;
      });
       if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('Deleted "$name".')),
         );
       }
    } catch (e) {
      setState(() {
        _error = 'Delete failed for $name: $e';
        _isLoading = false;
      });
       if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(_error!), backgroundColor: Colors.red),
         );
       }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.user.name}\'s Files'),
      ),
      body: Stack(
        children: [
          if (_fileNames.isEmpty && !_isLoading)
            const Center(child: Text('No files found.')),
          if (_fileNames.isNotEmpty)
            ListView.builder(
              itemCount: _fileNames.length,
              itemBuilder: (context, index) {
                final fileName = _fileNames[index];
                return ListTile(
                  leading: const Icon(Icons.insert_drive_file),
                  title: Text(fileName),
                  // Add download functionality if needed
                  // onTap: () => _downloadFile(fileName),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    tooltip: 'Delete',
                    onPressed: _isLoading ? null : () => _deleteFile(fileName),
                  ),
                );
              },
            ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
       floatingActionButton: FloatingActionButton(
        onPressed: _isLoading ? null : _uploadFiles,
        tooltip: 'Upload Files',
        child: const Icon(Icons.upload_file),
      ),
    );
  }
}
