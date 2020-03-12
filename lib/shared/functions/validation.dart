String validateEmail(String email) {
  return email.isEmpty ? "Please provide an email" : null;
}

String validatePassword(String value) {
  if (value.isEmpty) {
    return "Please provide a password";
  }
  return value.length < 6 ? "Password is too short" : null;
}

String validateForm(String value, {String name}) {
  name = name ?? "a value";
  return value.isEmpty ? "Please provide $name" : null;
}
