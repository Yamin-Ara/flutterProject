class CloudStorageException implements Exception {
  const CloudStorageException();
}

// C in CRUD
class CouldNotCreateNoteException extends CloudStorageException {}

// R in CRUD
class CouldNotGetAllNotesException extends CloudStorageException {}

// U in CRUD
class CouldNotUpdateNoteException extends CloudStorageException {}

// D in CRUD
class CouldNotDeleteNoteException extends CloudStorageException {}

class CouldNotCreateReminderException extends CloudStorageException {}

// R in CRUD
class CouldNotGetAllRemindersException extends CloudStorageException {}

// U in CRUD
class CouldNotUpdateReminderException extends CloudStorageException {}

// D in CRUD
class CouldNotDeleteReminderException extends CloudStorageException {}
