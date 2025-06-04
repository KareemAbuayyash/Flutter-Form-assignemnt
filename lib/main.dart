import 'package:flutter/material.dart';
import 'package:auth_project/OutputScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Form Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // 1️⃣ Use named routing
      initialRoute: MyFormScreen.routeName,
      routes: {
        MyFormScreen.routeName: (context) => const MyFormScreen(),
        OutputScreen.routeName: (context) {
          // 4️⃣ Extract arguments from the route
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return OutputScreen(
            username: args['username'] as String?,
            password: args['password'] as String?,
            email: args['email'] as String?,
            rememberMe: args['rememberMe'] as bool?,
            gender: args['gender'] as String?,
            country: args['country'] as String?,
            age: args['age'] as double?,
            selectedDate: args['selectedDate'] as DateTime?,
          );
        },
      },
    );
  }
}

class MyFormScreen extends StatefulWidget {
  // 2️⃣ Define routeName
  static const routeName = '/';

  const MyFormScreen({super.key});

  @override
  State<MyFormScreen> createState() => _MyFormScreenState();
}

class _MyFormScreenState extends State<MyFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _username;
  String? _password;
  String? _email;
  bool _rememberMe = false;
  String? _gender;
  String? _country;
  double _age = 18;
  DateTime? _selectedDate;

  final List<String> _countries = ['Palestine', 'Jordan', 'Egypt', 'Syria', 'Iraq'];
  final List<String> _genders   = ['Male', 'Female'];

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // 3️⃣ Navigate with pushNamed, passing all fields in arguments
      Navigator.of(context).pushNamed(
        OutputScreen.routeName,
        arguments: {
          'username':     _username,
          'password':     _password,
          'email':        _email,
          'rememberMe':   _rememberMe,
          'gender':       _gender,
          'country':      _country,
          'age':          _age,
          'selectedDate': _selectedDate,
        },
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate:   DateTime(1900),
      lastDate:    DateTime(2050),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Form Demo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // — Username —
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Username',
                  hintText: 'Enter your username',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v==null||v.isEmpty) ? 'Please enter your username' : null,
                onSaved:  (v) => _username = v,
              ),
              const SizedBox(height:16),

              // — Password —
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (v) {
                  if (v==null||v.isEmpty) return 'Please enter your password';
                  if (v.length<6)           return 'Password must be at least 6 characters';
                  return null;
                },
                onSaved: (v) => _password = v,
              ),
              const SizedBox(height:16),

              // — Email —
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v==null||v.isEmpty)    return 'Please enter your email';
                  if (!v.contains('@'))       return 'Please enter a valid email';
                  return null;
                },
                onSaved: (v) => _email = v,
              ),
              const SizedBox(height:16),

              // — Remember Me —
              CheckboxListTile(
                title: const Text('Remember me'),
                value: _rememberMe,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (val) => setState(() => _rememberMe = val ?? false),
              ),
              const SizedBox(height:16),

              // — Gender —
              Row(
                children: [
                  const Text('Gender:'),
                  const SizedBox(width:10),
                  ..._genders.map((g) => Row(
                    children: [
                      Radio<String>(
                        value: g.toLowerCase(),
                        groupValue: _gender,
                        onChanged:(v)=>setState(()=>_gender=v),
                      ),
                      Text(g),
                      const SizedBox(width:10),
                    ],
                  )),
                ],
              ),
              const SizedBox(height:16),

              // — Country —
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Country',
                  border: OutlineInputBorder(),
                ),
                value: _country,
                items: _countries.map((c)=>DropdownMenuItem(value:c,child:Text(c))).toList(),
                onChanged: (v)=> setState(()=>_country=v),
                validator: (v) => (v==null||v.isEmpty) ? 'Please select a country' : null,
                onSaved: (v) => _country = v,
              ),
              const SizedBox(height:16),

              // — Age —
              Row(
                children: [
                  const Text('Age:'),
                  Expanded(
                    child: Slider(
                      value: _age,
                      min: 18,
                      max: 99,
                      divisions: 81,
                      label: _age.round().toString(),
                      onChanged: (v)=> setState(()=>_age=v),
                    ),
                  ),
                  Text(_age.round().toString()),
                ],
              ),
              const SizedBox(height:16),

              // — Date Picker —
              InkWell(
                onTap: ()=>_selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Select Date',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                      Text(_selectedDate==null
                        ? 'No date selected'
                        : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height:24),

              // — Submit Button —
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
