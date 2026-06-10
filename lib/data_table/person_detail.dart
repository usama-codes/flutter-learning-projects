import 'package:flutter/material.dart';
import 'package:learning/data_table/extensions.dart';
import 'package:learning/data_table/person.dart';

class PersonDetailVU extends StatelessWidget {
  const PersonDetailVU({super.key, required this.person});

  final Person person;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(person.name)),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _HeaderBackground(person: person),
                  24.height,
                  Card(
                    child: Column(
                      children: [
                        _DetailTile(
                          icon: Icons.tag_rounded,
                          label: 'ID',
                          value: '${person.id}',
                        ),
                        const Divider(height: 1, indent: 56),
                        _DetailTile(
                          icon: Icons.title_rounded,
                          label: 'Name',
                          value: person.name,
                        ),
                        const Divider(height: 1, indent: 56),
                        _DetailTile(
                          icon: Icons.location_city_outlined,
                          label: 'City',
                          value: person.city,
                        ),
                        const Divider(height: 1, indent: 56),
                        _DetailTile(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          value: person.email,
                        ),
                        const Divider(height: 1, indent: 56),
                        _DetailTile(
                          icon: Icons.cake_outlined,
                          label: 'Age',
                          value: person.age.toString(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderBackground extends StatelessWidget {
  const _HeaderBackground({required this.person});

  final Person person;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4F6AF5), Color(0xFF7966D5)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: CircleAvatar(
          radius: 46,
          backgroundColor: Colors.white.withAlpha(45),
          foregroundColor: Colors.white,
          child: Text(
            person.name.isNotEmpty ? person.name[0].toUpperCase() : 'A',
            style: const TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  const _DetailTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: const Color(0xFF4F6AF5)),
          18.width,
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: tt.bodyMedium?.copyWith(color: const Color(0xFF44464F)),
            ),
          ),
        ],
      ),
    );
  }
}
