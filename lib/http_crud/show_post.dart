import 'package:flutter/material.dart';
import 'package:learning/http_crud/http_crud_vm.dart';

class ShowPost extends StatelessWidget {
  final int userId;
  final HttpCrudVM viewModel;

  const ShowPost({super.key, required this.userId, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, _) {
        final user = viewModel.userById(userId);

        if (user == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('User Detail')),
            body: const Center(
              child: Text('This user is no longer available.'),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('User Detail')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 20,
              children: [
                _LargeAvatar(url: user.avatar),
                Text(
                  user.fullName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8,
                  children: [
                    const Icon(
                      Icons.email_outlined,
                      color: Colors.grey,
                      size: 18,
                    ),
                    Text(
                      user.email,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const Divider(),
                _ActionButton(
                  label: 'PUT Update',
                  icon: Icons.save_outlined,
                  color: const Color(0xFF2C95CA),
                  onPressed: () => viewModel.showPutDialog(context, userId),
                ),
                _ActionButton(
                  label: 'PATCH Update',
                  icon: Icons.edit,
                  color: const Color(0xFF5A83AD),
                  onPressed: () => viewModel.showUpdateDialog(
                    context,
                    userId,
                    usePut: false,
                  ),
                ),
                _ActionButton(
                  label: 'DELETE',
                  icon: Icons.delete,
                  color: const Color(0xFFC22424),
                  onPressed: () async {
                    final ok = await viewModel.delete(userId);
                    if (!context.mounted) {
                      return;
                    }
                    if (ok) {
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LargeAvatar extends StatelessWidget {
  final String url;
  const _LargeAvatar({required this.url});

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return const CircleAvatar(
        radius: 52,
        backgroundColor: Color(0xFF2C95CA),
        child: Icon(Icons.person, size: 52, color: Colors.white),
      );
    }
    return CircleAvatar(
      radius: 52,
      backgroundImage: NetworkImage(url),
      backgroundColor: const Color(0xFFE0E0E0),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.55,
      child: TextButton.icon(
        onPressed: onPressed,
        label: Text(label),
        icon: Icon(icon),
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: color,
        ),
      ),
    );
  }
}
