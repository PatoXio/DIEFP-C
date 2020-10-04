class Usuario {
  String id;
  String name;
  String email;
  String password;

  Usuario() {
    id = null;
    name = null;
    email = null;
    password = null;
  }
  Usuario.carga(String id, name, email, password) {
    this.id = id;
    this.name = name;
    this.email = email;
    this.password = password;
  }

  String getId() {
    return id;
  }

  String getname() {
    return name;
  }

  String getEmail() {
    return email;
  }

  String getPassword() {
    return password;
  }

  void setId(String id) {
    this.id = id;
  }

  void setName(String name) {
    this.name = name;
  }

  void setEmail(String email) {
    this.email = email;
  }

  void setPassword(String password) {
    this.password = password;
  }
}
