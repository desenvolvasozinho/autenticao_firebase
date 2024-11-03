import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  String _textDanger = '';

  Future<void> signIn() async {
    try {
      final crentials = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (crentials.user != null) {
        if (mounted) {
          Navigator.pushNamed(context, '/home-page');
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          _textDanger = 'Usuario não encontrado';
        });
      } else if (e.code == 'wrong-password') {
        setState(() {
          _textDanger = 'Senha incorreta';
        });
      } else {
        setState(() {
          _textDanger = 'Falha desconhecida';
        });
      }
    } catch (e) {
      setState(() {
        _textDanger = 'Erro ao loar: $e';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        autofocus: false,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira seu email';
                          }
                          return null;
                        },
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                      ),
                      TextFormField(
                        autofocus: false,
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Senha',
                          prefixIcon: Icon(Icons.password),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira uma senha';
                          }
                          return null;
                        },
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              signIn();
                            }
                          },
                          child: const Text('Logar'),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/create-account-page');
                        },
                        child: const Text('Criar conta'),
                      ),
                      const SizedBox(height: 20),
                      SelectableText(_textDanger.isNotEmpty ? _textDanger : '')
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
