import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  String _textDanger = '';

  // CRIAR NOVA CONTA NO FIREBASE
  Future<void> createCredentials() async {
    try {
      // CRIA USURIO COM EMAIL E SENHA
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (credential.user != null) {
        // podemos logar
        await signIn();
      } else {
        // precisamos passar m aviso para o usuario
        setState(() {
          _textDanger = 'Falha inesperada ao tentar criar conta';
        });
      }
    } catch (e) {
      setState(() {
        _textDanger = 'Erro: $e';
      });
    }
  }

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
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar conta'),
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
                      TextFormField(
                        autofocus: false,
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Confirmar senha',
                          prefixIcon: Icon(Icons.password),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira uma senha';
                          }
                          if (value != _passwordController.text) {
                            return 'Senha não confere';
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
                            //função de criar conta
                            if (_formKey.currentState!.validate()) {
                              createCredentials();
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              'Criar conta',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
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
