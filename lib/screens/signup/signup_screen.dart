import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:xlo_mobx/screens/signup/components/field_title.dart';
import 'package:xlo_mobx/stores/signup_store.dart';

import '../../components/error_box.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final SignupStore signupStore = SignupStore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Cadastro',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Observer(builder: (_) {
                    //Passando msg de erro para ser exibida para o usuário
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: ErrorBox(message: signupStore.error),
                    );
                  }),
                  const FieldTitle(
                    title: 'Apelido',
                    subtitle: 'Como aparecerá em seus anúncios.',
                  ),
                  Observer(builder: (_) {
                    return TextField(
                      enabled: !signupStore.loading,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'Exemplo: João S.',
                        isDense: true,
                        errorText: signupStore.nameError,
                      ),
                      cursorColor: Colors.orange,
                      onChanged: signupStore.setName,
                    );
                  }),
                  const SizedBox(height: 16),
                  const FieldTitle(
                    title: 'E-mail',
                    subtitle: 'Enviaremos um e-mail de confirmação.',
                  ),
                  Observer(builder: (_) {
                    return TextField(
                      enabled: !signupStore.loading,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'Exemplo: joao@gmail.com',
                        isDense: true,
                        errorText: signupStore.emailError,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      cursorColor: Colors.orange,
                      onChanged: signupStore.setEmail,
                    );
                  }),
                  const SizedBox(height: 16),
                  const FieldTitle(
                    title: 'Celular',
                    subtitle: 'Proteja sua conta',
                  ),
                  Observer(builder: (_) {
                    return TextField(
                      enabled: !signupStore.loading,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: '(99) 99999-9999',
                        isDense: true,
                        errorText: signupStore.phoneError,
                      ),
                      keyboardType: TextInputType.phone,
                      cursorColor: Colors.orange,
                      inputFormatters: [
                        //permitir apenas números
                        FilteringTextInputFormatter.digitsOnly,
                        //formata o campo de telefone no padrão brasileiro
                        TelefoneInputFormatter(),
                      ],
                      onChanged: signupStore.setPhone,
                    );
                  }),
                  const SizedBox(height: 16),
                  const FieldTitle(
                    title: 'Senha',
                    subtitle: 'Use letras, números e caracteres especiais',
                  ),
                  Observer(builder: (_) {
                    return TextField(
                      enabled: !signupStore.loading,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        isDense: true,
                        errorText: signupStore.pass1Error,
                      ),
                      cursorColor: Colors.orange,
                      obscureText: true,
                      onChanged: signupStore.setPass1,
                    );
                  }),
                  const SizedBox(height: 16),
                  const FieldTitle(
                    title: 'Confirmar Senha',
                    subtitle: 'Repita a senha',
                  ),
                  Observer(builder: (_) {
                    return TextField(
                      enabled: !signupStore.loading,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        isDense: true,
                        errorText: signupStore.pass2Error,
                      ),
                      cursorColor: Colors.orange,
                      obscureText: true,
                      onChanged: signupStore.setPass2,
                    );
                  }),
                  Observer(builder: (_) {
                    return Container(
                      height: 40,
                      margin: const EdgeInsets.only(top: 20, bottom: 12),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          disabledBackgroundColor: Colors.orange.withAlpha(120),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: signupStore.signUpPressed,
                        child: signupStore.loading
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              )
                            : const Text(
                                'CADASTRAR',
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    );
                  }),
                  const Divider(color: Colors.grey),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Já tem uma conta? ',
                          style: TextStyle(fontSize: 16),
                        ),
                        GestureDetector(
                          onTap: Navigator.of(context).pop,
                          child: const Text(
                            'Entrar',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.purple,
                              fontSize: 16,
                            ),
                          ),
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
