import 'dart:async';

import 'package:flutter/material.dart';
import 'package:learning/http_crud/http_crud_api.dart';
import 'package:learning/http_crud/resource.dart';
import 'package:learning/http_crud/show_post.dart';
import 'package:stacked/stacked.dart';

class HttpCrudVM extends BaseViewModel {
  HttpCrudVM({HttpCrudApi? api}) : _api = api ?? HttpCrudApi();

  static const String apiEndpoint = HttpCrudApi.usersCollectionUrl;

  final HttpCrudApi _api;

  final List<Resource> users = [];

  bool isError = false;
  String errorMessage = '';

  Future<void> fetchData() async {
    final previousUsers = List<Resource>.from(users);

    setBusy(true);
    isError = false;
    errorMessage = '';

    try {
      final fetchedUsers = await _api.fetchUsers();
      users
        ..clear()
        ..addAll(fetchedUsers);
    } catch (error) {
      isError = true;
      errorMessage = _formatGenericFailure(error);
      debugPrint('fetchData failed: $error');

      if (previousUsers.isNotEmpty) {
        users
          ..clear()
          ..addAll(previousUsers);
      }
    } finally {
      setBusy(false);
    }
  }

  Resource? userById(int id) {
    for (final user in users) {
      if (user.id == id) {
        return user;
      }
    }
    return null;
  }

  Future<void> showPost(BuildContext context, int index) async {
    if (index < 0 || index >= users.length) {
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ShowPost(userId: users[index].id, viewModel: this),
      ),
    );
  }

  Future<void> showCreateDialog(BuildContext context) async {
    final values =
        await showDialog<({String firstName, String lastName, String email})>(
          context: context,
          builder: (dialogContext) =>
              const _UserFormDialog(title: 'New User', confirmLabel: 'Create'),
        );

    if (values == null) {
      return;
    }

    final ok = await create(
      firstName: values.firstName,
      lastName: values.lastName,
      email: values.email,
    );

    if (!context.mounted) {
      return;
    }

    if (ok) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User created')));
    }
  }

  Future<void> showUpdateDialog(
    BuildContext context,
    int userId, {
    required bool usePut,
  }) async {
    final currentUser = userById(userId);
    if (currentUser == null) {
      return;
    }

    final values =
        await showDialog<({String firstName, String lastName, String email})>(
          context: context,
          builder: (dialogContext) => _UserFormDialog(
            title: usePut ? 'Replace User' : 'Edit User',
            confirmLabel: usePut ? 'PUT' : 'PATCH',
            initialUser: currentUser,
          ),
        );

    if (values == null) {
      return;
    }

    final ok = usePut
        ? await put(
            userId,
            firstName: values.firstName,
            lastName: values.lastName,
            email: values.email,
          )
        : await patch(
            userId,
            firstName: values.firstName,
            lastName: values.lastName,
            email: values.email,
          );

    if (!context.mounted) {
      return;
    }

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(usePut ? 'User replaced' : 'User updated')),
      );
    }
  }

  Future<void> showEditDialog(BuildContext context, int index) async {
    if (index < 0 || index >= users.length) {
      return;
    }

    await showUpdateDialog(context, users[index].id, usePut: false);
  }

  Future<void> showPutDialog(BuildContext context, int index) async {
    if (index < 0 || index >= users.length) {
      return;
    }

    await showUpdateDialog(context, users[index].id, usePut: true);
  }

  Future<bool> edit(
    int userId, {
    required String firstName,
    required String lastName,
    required String email,
  }) {
    return patch(
      userId,
      firstName: firstName,
      lastName: lastName,
      email: email,
    );
  }

  Future<bool> patch(
    int userId, {
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    isError = false;
    errorMessage = '';

    try {
      final updated = await _api.patchUser(
        id: userId,
        firstName: firstName,
        lastName: lastName,
        email: email,
      );

      _upsertUser(updated, preserveAvatarFromCurrent: true);
      _notifyListenersSafely();
      return true;
    } catch (error) {
      isError = true;
      errorMessage = _formatGenericFailure(error);
      debugPrint('patch failed: $error');
      return false;
    }
  }

  Future<bool> put(
    int userId, {
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    isError = false;
    errorMessage = '';

    try {
      final updated = await _api.putUser(
        id: userId,
        firstName: firstName,
        lastName: lastName,
        email: email,
      );

      _upsertUser(updated, preserveAvatarFromCurrent: true);
      _notifyListenersSafely();
      return true;
    } catch (error) {
      isError = true;
      errorMessage = _formatGenericFailure(error);
      debugPrint('put failed: $error');
      return false;
    }
  }

  Future<bool> create({
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    isError = false;
    errorMessage = '';

    try {
      final created = await _api.createUser(
        firstName: firstName,
        lastName: lastName,
        email: email,
      );

      users.insert(0, created);
      _notifyListenersSafely();
      return true;
    } catch (error) {
      isError = true;
      errorMessage = _formatGenericFailure(error);
      debugPrint('create failed: $error');
      return false;
    }
  }

  Future<bool> delete(int userId) async {
    isError = false;
    errorMessage = '';

    try {
      await _api.deleteUser(userId);

      final index = users.indexWhere((user) => user.id == userId);
      if (index != -1) {
        users.removeAt(index);
      }

      notifyListeners();
      return true;
    } catch (error) {
      isError = true;
      errorMessage = _formatGenericFailure(error);
      debugPrint('delete failed: $error');
      return false;
    }
  }

  void _upsertUser(
    Resource updatedUser, {
    required bool preserveAvatarFromCurrent,
  }) {
    final index = users.indexWhere((user) => user.id == updatedUser.id);
    if (index == -1) {
      users.insert(0, updatedUser);
      return;
    }

    final currentUser = users[index];
    users[index] = updatedUser.copyWith(
      avatar: preserveAvatarFromCurrent && updatedUser.avatar.isEmpty
          ? currentUser.avatar
          : updatedUser.avatar,
    );
  }

  String _formatGenericFailure(Object error) {
    if (error is HttpCrudApiException) {
      return error.message;
    }

    if (error is TimeoutException) {
      return 'Request timed out. Check your connection and try again.';
    }

    return error.toString();
  }

  void _notifyListenersSafely() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (hasListeners) {
        notifyListeners();
      }
    });
  }
}

class _UserFormDialog extends StatefulWidget {
  final String title;
  final String confirmLabel;
  final Resource? initialUser;

  const _UserFormDialog({
    required this.title,
    required this.confirmLabel,
    this.initialUser,
  });

  @override
  State<_UserFormDialog> createState() => _UserFormDialogState();
}

class _UserFormDialogState extends State<_UserFormDialog> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(
      text: widget.initialUser?.firstName ?? '',
    );
    _lastNameController = TextEditingController(
      text: widget.initialUser?.lastName ?? '',
    );
    _emailController = TextEditingController(
      text: widget.initialUser?.email ?? '',
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            if (_errorText != null) ...[
              const SizedBox(height: 12),
              Text(
                _errorText!,
                style: const TextStyle(color: Colors.redAccent, fontSize: 12),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final firstName = _firstNameController.text.trim();
            final lastName = _lastNameController.text.trim();
            final email = _emailController.text.trim();

            final validationError = _validateUserInput(
              firstName: firstName,
              lastName: lastName,
              email: email,
            );

            if (validationError != null) {
              setState(() {
                _errorText = validationError;
              });
              return;
            }

            Navigator.pop(context, (
              firstName: firstName,
              lastName: lastName,
              email: email,
            ));
          },
          child: Text(widget.confirmLabel),
        ),
      ],
    );
  }

  String? _validateUserInput({
    required String firstName,
    required String lastName,
    required String email,
  }) {
    if (firstName.isEmpty) {
      return 'First name is required.';
    }

    if (lastName.isEmpty) {
      return 'Last name is required.';
    }

    if (email.isEmpty) {
      return 'Email is required.';
    }

    if (!email.contains('@') || !email.contains('.')) {
      return 'Enter a valid email address.';
    }

    return null;
  }
}
