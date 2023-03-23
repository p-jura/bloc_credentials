import 'package:flutter/foundation.dart' show immutable;

import '../models.dart';

@immutable
abstract class NotesApiProtocol {
  const NotesApiProtocol();
  Future<Iterable<Note>?> getNotes({
    required LoginHandle loginHandle,
  });
}
