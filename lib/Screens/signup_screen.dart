import 'package:flutter/material.dart';
import 'success_screen.dart';

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

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2002, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      _dobController.text = "${picked.day}/${picked.month}/${picked.year}";
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
  }) {
    return TextFormField(
      controller: controller,
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
            child: Column(
              children: [
                // Header
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
                const SizedBox(height: 30),

                // Avatar Picker
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
                      onTap: () => setState(() => _avatar = a),
                      child: CircleAvatar(
                        radius: 26,
                        backgroundColor:
                        selected ? Colors.deepPurple : Colors.grey[200],
                        child: Text(a, style: const TextStyle(fontSize: 24)),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Name
                _buildTextField(
                  controller: _nameController,
                  label: 'Adventure Name',
                  icon: Icons.person,
                  validator: (v) => (v == null || v.isEmpty)
                      ? 'What should we call you on this adventure?'
                      : null,
                ),
                const SizedBox(height: 20),

                // Email
                _buildTextField(
                  controller: _emailController,
                  label: 'Email Address',
                  icon: Icons.email,
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
                const SizedBox(height: 20),

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
                  validator: (v) =>
                  (v == null || v.isEmpty) ? 'When did your adventure begin?' : null,
                ),
                const SizedBox(height: 20),

                // Password
                TextFormField(
                  controller: _pwdController,
                  obscureText: !_showPwd,
                  decoration: InputDecoration(
                    labelText: 'Secret Password',
                    prefixIcon:
                    const Icon(Icons.lock, color: Colors.deepPurple),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showPwd ? Icons.visibility_off : Icons.visibility,
                        color: Colors.deepPurple,
                      ),
                      onPressed: () =>
                          setState(() => _showPwd = !_showPwd),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
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
                const SizedBox(height: 30),

                // Submit button
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
