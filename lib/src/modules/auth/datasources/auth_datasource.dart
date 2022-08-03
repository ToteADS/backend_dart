abstract class AuthDatasource {
  Future<Map> getIdAndRoleByEmail(String email);
  Future<String> getRoleById(id);
  Future<String> getPasswordById(id);
  Future<void> updatePasswordById(id, String password);
}
