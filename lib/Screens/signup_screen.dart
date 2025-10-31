import 'package:flutter/material.dart';
import '../widgets/progress_tracker.dart';
import 'success_screen.dart';
import '../widgets/password_strength.dart';
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();
  final _pwdController = TextEditingController();

  bool _showPwd = false;
  String? _avatar; // selected emoji

  int _progress = 0;
  final Set<String> _done = {};

  @override
  void initState() {
    super.initState();
    // initial recalc covers default values (none selected yet)
    _recalcProgress();
  }

  @override
  void dispose() {
    for (var c in [
      _nameController,
      _emailController,
      _dobController,
      _pwdController
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _recalcProgress() {
    _done.clear();

    if (_avatar != null && _avatar!.isNotEmpty) _done.add('avatar');

    final name = _nameController.text.trim();
    if (name.isNotEmpty) _done.add('name');

    final email = _emailController.text.trim();
    final validEmail = email.isNotEmpty && email.contains('@') && email.contains('.');
    if (validEmail) _done.add('email');

    if (_dobController.text.trim().isNotEmpty) _done.add('dob');

    if (_pwdController.text.length >= 6) _done.add('pwd');

    setState(() {
      _progress = ((_done.length / 5) * 100).round();
    });
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2002, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      _dobController.text = "${picked.day}/${picked.month}/${picked.year}";
      _recalcProgress();
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SuccessScreen(
            userName: _nameController.text,
            avatar: _avatar ?? "🙂",
          ),
        ),
      );
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    const avatars = ["🦊", "🐱", "🐻", "🐸", "🐧", "🙂"];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Your Account 🎉'),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            onChanged: _recalcProgress, // safety net: any change triggers update
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // PROGRESS
                ProgressTracker(progress: _progress),
                const SizedBox(height: 20),

                // Header card
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.tips_and_updates,
                          color: Colors.deepPurple[800]),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Complete your adventure profile!',
                          style: TextStyle(
                            color: Colors.deepPurple[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Avatar Picker (counts toward progress)
                const Text(
                  "Choose your avatar",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.deepPurple),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  children: avatars.map((a) {
                    final selected = _avatar == a;
                    return GestureDetector(
                      onTap: () {
                        setState(() => _avatar = a);
                        _recalcProgress();
                      },
                      child: CircleAvatar(
                        radius: 26,
                        backgroundColor:
                        selected ? Colors.deepPurple : Colors.grey[200],
                        child: Text(a, style: const TextStyle(fontSize: 24)),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Name
                _buildTextField(
                  controller: _nameController,
                  label: 'Adventure Name',
                  icon: Icons.person,
                  onChanged: (_) => _recalcProgress(),
                  validator: (v) => (v == null || v.isEmpty)
                      ? 'What should we call you on this adventure?'
                      : null,
                ),
                const SizedBox(height: 16),

                // Email
                _buildTextField(
                  controller: _emailController,
                  label: 'Email Address',
                  icon: Icons.email,
                  onChanged: (_) => _recalcProgress(),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'We need your email for adventure updates!';
                    }
                    if (!v.contains('@') || !v.contains('.')) {
                      return 'Oops! That doesn\'t look like a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // DOB
                TextFormField(
                  controller: _dobController,
                  readOnly: true,
                  onTap: _selectDate,
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
                    prefixIcon: const Icon(Icons.calendar_today,
                        color: Colors.deepPurple),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.date_range),
                      onPressed: _selectDate,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  validator: (v) => (v == null || v.isEmpty)
                      ? 'When did your adventure begin?'
                      : null,
                ),
                const SizedBox(height: 16),

                // PASSWORD
                TextFormField(
                  controller: _pwdController,
                  obscureText: !_showPwd,
                  onChanged: (_) => _recalcProgress(),
                  decoration: InputDecoration(
                    labelText: 'Secret Password',
                    prefixIcon: const Icon(Icons.lock, color: Colors.deepPurple),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showPwd ? Icons.visibility_off : Icons.visibility,
                        color: Colors.deepPurple,
                      ),
                      onPressed: () => setState(() => _showPwd = !_showPwd),
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Every adventurer needs a secret password!';
                    }
                    if (v.length < 6) {
                      return 'Make it stronger! At least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                PasswordStrengthBar(password: _pwdController.text),
                // Submit
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 32),
                  ),
                  child: const Text('Start My Adventure',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
