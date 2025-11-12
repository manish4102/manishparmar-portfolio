import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _first = TextEditingController();
  final _last = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _message = TextEditingController();

  bool _sending = false;
  bool _hoverSend = false;

  static const kBlue = Color.fromARGB(255, 23, 118, 243);

  // EmailJS credentials
  static const _emailJsServiceId = 'service_imfy7ly';
  static const _emailJsTemplateId = 'template_opc18i8';
  static const _emailJsPublicKey = 'zqsy4LOgByBi1CKF8';

  // ---------- Custom Snackbar (top-center) ----------
  Future<void> _showTopSnack({
    required String text,
    required bool success,
  }) async {
    final overlay = Overlay.of(context);
    if (overlay == null) return;
    final bg = success ? const Color(0xFF2E7D32) : const Color(0xFFC62828);

    late final OverlayEntry entry;
    final controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 280));
    final fade = CurvedAnimation(parent: controller, curve: Curves.easeOutCubic);
    final slide =
        Tween<Offset>(begin: const Offset(0, -0.15), end: Offset.zero).animate(fade);

    entry = OverlayEntry(
      builder: (_) => Positioned(
        top: 24,
        left: 0,
        right: 0,
        child: SafeArea(
          child: Center(
            child: SlideTransition(
              position: slide,
              child: FadeTransition(
                opacity: fade,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);
    await controller.forward();
    await Future.delayed(const Duration(milliseconds: 1600));
    await controller.reverse();
    entry.remove();
    controller.dispose();
  }

  // ---------- Send via EmailJS ----------
  Future<void> _sendEmail() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _sending = true);
    try {
      final payload = {
        'service_id': _emailJsServiceId,
        'template_id': _emailJsTemplateId,
        'user_id': _emailJsPublicKey,
        'template_params': {
          'first_name': _first.text.trim(),
          'last_name': _last.text.trim(),
          'reply_to': _email.text.trim(),
          'contact_no': _phone.text.trim(),
          'message': _message.text.trim(),
          'from_name': '${_first.text.trim()} ${_last.text.trim()}'.trim(),
        },
      };

      final resp = await http.post(
        Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
        headers: const {
          'origin': 'http://localhost',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      if (!mounted) return;

      if (resp.statusCode == 200) {
        _showTopSnack(text: 'Message sent! I’ll get back to you soon.', success: true);
        _first.clear();
        _last.clear();
        _email.clear();
        _phone.clear();
        _message.clear();
      } else {
        _showTopSnack(text: 'Failed to send. Please try again.', success: false);
      }
    } catch (_) {
      if (mounted) {
        _showTopSnack(text: 'Network error. Please try again.', success: false);
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  void dispose() {
    _first.dispose();
    _last.dispose();
    _email.dispose();
    _phone.dispose();
    _message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Container(
      color: kBlue,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // ✅ left align
        children: [
          // ---- "Get in Touch" outside container ----
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 60),
            child: Text(
              'Get in Touch',
              style: TextStyle(
                fontSize: isMobile ? 36 : 80,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                shadows: const [
                  Shadow(color: Colors.black38, blurRadius: 12, offset: Offset(0, 4)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),

          // ---- White container with all content ----
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 60),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : 60,
                vertical: isMobile ? 40 : 60,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30), // all corners rounded
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // ---------- Form ----------
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Row 1: First / Last
                        isMobile
                            ? Column(
                                children: [
                                  _shadowField(
                                    child: TextFormField(
                                      controller: _first,
                                      decoration: _dec('First Name'),
                                      validator: (v) => (v == null || v.trim().isEmpty)
                                          ? 'Enter first name'
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _shadowField(
                                    child: TextFormField(
                                      controller: _last,
                                      decoration: _dec('Last Name'),
                                      validator: (v) => (v == null || v.trim().isEmpty)
                                          ? 'Enter last name'
                                          : null,
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    child: _shadowField(
                                      child: TextFormField(
                                        controller: _first,
                                        decoration: _dec('First Name'),
                                        validator: (v) =>
                                            (v == null || v.trim().isEmpty)
                                                ? 'Enter first name'
                                                : null,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: _shadowField(
                                      child: TextFormField(
                                        controller: _last,
                                        decoration: _dec('Last Name'),
                                        validator: (v) =>
                                            (v == null || v.trim().isEmpty)
                                                ? 'Enter last name'
                                                : null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        const SizedBox(height: 16),

                        // Row 2: Email / Contact
                        isMobile
                            ? Column(
                                children: [
                                  _shadowField(
                                    child: TextFormField(
                                      controller: _email,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: _dec('Email'),
                                      validator: (v) {
                                        final s = v?.trim() ?? '';
                                        if (s.isEmpty) return 'Enter email';
                                        final ok =
                                            RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(s);
                                        return ok ? null : 'Enter a valid email';
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _shadowField(
                                    child: TextFormField(
                                      controller: _phone,
                                      keyboardType: TextInputType.phone,
                                      decoration: _dec('Contact No.'),
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    child: _shadowField(
                                      child: TextFormField(
                                        controller: _email,
                                        keyboardType: TextInputType.emailAddress,
                                        decoration: _dec('Email'),
                                        validator: (v) {
                                          final s = v?.trim() ?? '';
                                          if (s.isEmpty) return 'Enter email';
                                          final ok = RegExp(
                                                  r'^[^@]+@[^@]+\.[^@]+$')
                                              .hasMatch(s);
                                          return ok ? null : 'Enter a valid email';
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: _shadowField(
                                      child: TextFormField(
                                        controller: _phone,
                                        keyboardType: TextInputType.phone,
                                        decoration: _dec('Contact No.'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        const SizedBox(height: 16),

                        // Message
                        _shadowField(
                          child: TextFormField(
                            controller: _message,
                            maxLines: 6,
                            decoration: _dec('Message'),
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Enter a message'
                                : null,
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Send button (hover + shadow)
                        MouseRegion(
                          onEnter: (_) => setState(() => _hoverSend = true),
                          onExit: (_) => setState(() => _hoverSend = false),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            curve: Curves.easeOutCubic,
                            transformAlignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..translate(0.0, _hoverSend ? -3.0 : 0.0)
                              ..scale(_hoverSend ? 1.02 : 1.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: _hoverSend
                                    ? const [const Color.fromARGB(255, 23, 118, 243), Color(0xFF2563EB)]
                                    : const [const Color.fromARGB(255, 23, 118, 243), Color(0xFF1E40AF)],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(
                                      _hoverSend ? 0.30 : 0.20),
                                  blurRadius: _hoverSend ? 18 : 12,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Material(
                              type: MaterialType.transparency,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(14),
                                onTap: _sending ? null : _sendEmail,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 28, vertical: 16),
                                  child: Center(
                                    child: _sending
                                        ? const SizedBox(
                                            height: 22,
                                            width: 22,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                        : const Text(
                                            'Send',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 48),

                  // ---- OR Connect with me on ----
                  Row(
                    children: [
                      Expanded(
                          child:
                              Divider(color: Colors.grey.shade400, thickness: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          '— OR Connect with me on —',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                          child:
                              Divider(color: Colors.grey.shade400, thickness: 1)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Social icons
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _socialImageCard(
                        imagePath: 'assets/linkedin.jpg',
                        tooltip: 'LinkedIn',
                        onTap: () =>
                            _open('https://www.linkedin.com/in/manish-champalal-parmar-b03303210/'),
                      ),
                      _socialImageCard(
                        imagePath: 'assets/github.jpg',
                        tooltip: 'GitHub',
                        onTap: () => _open('https://github.com/manish4102'),
                      ),
                      _socialImageCard(
                        imagePath: 'assets/location.jpg',
                        tooltip: 'Location',
                        onTap: () => _open(
                            'https://maps.app.goo.gl/gstAJVgTveoCywTx5'),
                      ),
                      _socialImageCard(
                        imagePath: 'assets/gmail.jpg',
                        tooltip: 'Email',
                        onTap: () => _open(
                            'mailto:parmarmanish.work@gmail.com?subject=Hello%20Manish'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- UI helpers ----------
  InputDecoration _dec(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: kBlue, fontSize: 18, fontWeight: FontWeight.w600),
      contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: BorderSide(color: const Color(0xFFCFD8DC).withOpacity(0.8), width: 1.3),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(28)),
        borderSide: BorderSide(color: kBlue, width: 2),
      ),
      fillColor: const Color(0xFF5C5CFF).withOpacity(0.10),
      filled: true,
    );
  }

  Widget _shadowField({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _socialImageCard({
    required String imagePath,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOutCubic,
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
            ),
          ),
        ),
      ),
    );
  }
}
