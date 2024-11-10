import 'dart:io';

class Contact {
  String name;
  String phone;
  String? avatar;
  bool isFavorite; // Tambahkan atribut favorit
  bool isBlocked;  // Tambahkan atribut blokir

  Contact(this.name, this.phone, [this.avatar, this.isFavorite = false, this.isBlocked = false]);

  File? get avatarFile => avatar != null ? File(avatar!) : null;
}
