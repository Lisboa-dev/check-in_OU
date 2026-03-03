enum UserRole { student, driver, admin }

UserRole parseRole(String role) {
  switch (role.toLowerCase()) {
    case 'student':
      return UserRole.student;
    case 'driver':
      return UserRole.driver;
    case 'admin':
      return UserRole.admin;
    default:
      return UserRole.student;
  }
}
