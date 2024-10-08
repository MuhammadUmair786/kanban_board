import 'local_keys.dart';

/// key, en, fr
class LocaleItem {
  final String key;

  /// English
  final String en;

  /// France
  final String fr;

  /// Arabic
  final String ar;

  /// German
  final String de;

  LocaleItem({
    required this.key,
    required this.en,
    required this.fr,
    required this.ar,
    required this.de,
  });
}

List<LocaleItem> localeList = <LocaleItem>[
  // Backup screen
  LocaleItem(
    key: uploadBackupLK,
    en: 'Upload Backup',
    fr: 'Télécharger la sauvegarde',
    ar: 'تحميل النسخة الاحتياطية',
    de: 'Backup hochladen',
  ),
  LocaleItem(
    key: savesDataToCloudLK,
    en: 'Saves your current data to the cloud for safekeeping.',
    fr: 'Enregistre vos données actuelles dans le cloud pour les protéger.',
    ar: 'يخزن بياناتك الحالية في السحابة لحفظها.',
    de: 'Speichert Ihre aktuellen Daten in der Cloud zur Aufbewahrung.',
  ),
  LocaleItem(
    key: restoreBackupLK,
    en: 'Restore Backup',
    fr: 'Restaurer la sauvegarde',
    ar: 'استعادة النسخة الاحتياطية',
    de: 'Backup wiederherstellen',
  ),
  LocaleItem(
    key: retrievesDataFromCloudLK,
    en: 'Retrieves your previously saved data from the cloud and restores it to your device.',
    fr: 'Récupère vos données précédemment sauvegardées depuis le cloud et les restaure sur votre appareil.',
    ar: 'يستعيد بياناتك المحفوظة سابقًا من السحابة ويسترجعها إلى جهازك.',
    de: 'Ruft Ihre zuvor gespeicherten Daten aus der Cloud ab und stellt sie auf Ihrem Gerät wieder her.',
  ),
  LocaleItem(
    key: deleteBackupLK,
    en: 'Delete Backup',
    fr: 'Supprimer la sauvegarde',
    ar: 'حذف النسخة الاحتياطية',
    de: 'Backup löschen',
  ),
  LocaleItem(
    key: deleteBackupWarningLK,
    en: 'Permanently removes your saved data from the cloud. Please note that this action cannot be undone.',
    fr: 'Supprime définitivement vos données sauvegardées du cloud. Veuillez noter que cette action est irréversible.',
    ar: 'يزيل بياناتك المحفوظة من السحابة بشكل دائم. يرجى ملاحظة أن هذه الخطوة لا يمكن التراجع عنها.',
    de: 'Entfernt Ihre gespeicherten Daten dauerhaft aus der Cloud. Bitte beachten Sie, dass diese Aktion nicht rückgängig gemacht werden kann.',
  ),
  LocaleItem(
    key: cloudBackupLK,
    en: 'Cloud Backup',
    fr: 'Sauvegarde sur le cloud',
    ar: 'نسخة احتياطية على السحابة',
    de: 'Cloud-Backup',
  ),
  LocaleItem(
    key: backupSuccessLK,
    en: 'Your data has been successfully backed up.',
    fr: 'Vos données ont été sauvegardées avec succès.',
    ar: 'تم نسخ بياناتك احتياطيًا بنجاح.',
    de: 'Ihre Daten wurden erfolgreich gesichert.',
  ),
  LocaleItem(
    key: backupFailureLK,
    en: 'Failed to back up your data. Please try again later.',
    fr: 'Échec de la sauvegarde de vos données. Veuillez réessayer plus tard.',
    ar: 'فشل في نسخ بياناتك احتياطيًا. يرجى المحاولة مرة أخرى لاحقًا.',
    de: 'Fehler beim Sichern Ihrer Daten. Bitte versuchen Sie es später erneut.',
  ),
  LocaleItem(
    key: authorizationFailureLK,
    en: 'Authorization failed.',
    fr: 'Échec de l\'autorisation.',
    ar: 'فشل التفويض.',
    de: 'Autorisierung fehlgeschlagen.',
  ),
  LocaleItem(
    key: noBackupFoundLK,
    en: 'No backup found on your drive.',
    fr: 'Aucune sauvegarde trouvée sur votre lecteur.',
    ar: 'لم يتم العثور على نسخة احتياطية على محرك الأقراص الخاص بك.',
    de: 'Kein Backup auf Ihrem Laufwerk gefunden.',
  ),
  LocaleItem(
    key: importFailureLK,
    en: 'Failed to import data from your drive.',
    fr: 'Échec de l\'importation des données de votre lecteur.',
    ar: 'فشل في استيراد البيانات من محرك الأقراص الخاص بك.',
    de: 'Fehler beim Importieren von Daten von Ihrem Laufwerk.',
  ),
  LocaleItem(
    key: backupDeletionSuccessLK,
    en: 'Backup deleted successfully.',
    fr: 'Sauvegarde supprimée avec succès.',
    ar: 'تم حذف النسخة الاحتياطية بنجاح.',
    de: 'Backup erfolgreich gelöscht.',
  ),
  LocaleItem(
    key: backupDeletionFailureLK,
    en: 'Failed to delete the backup.',
    fr: 'Échec de la suppression de la sauvegarde.',
    ar: 'فشل في حذف النسخة الاحتياطية.',
    de: 'Fehler beim Löschen des Backups.',
  ),

  // Theme
  LocaleItem(
    key: appearanceLK,
    en: 'Appearance',
    fr: 'Apparence',
    ar: 'المظهر',
    de: 'Erscheinungsbild',
  ),
  // Language
  LocaleItem(
    key: languageLK,
    en: 'Language',
    fr: 'Langue',
    ar: 'اللغة',
    de: 'Sprache',
  ),
  // Upcoming notifications
  LocaleItem(
    key: upcomingTasksLK,
    en: 'Upcoming Tasks',
    fr: 'Tâches à venir',
    ar: 'المهام القادمة',
    de: 'Bevorstehende Aufgaben',
  ),
  // History
  LocaleItem(
    key: searchHereLK,
    en: 'Search here ...',
    fr: 'Recherchez ici ...',
    ar: 'ابحث هنا ...',
    de: 'Hier suchen ...',
  ),
  // General
  LocaleItem(
    key: boardMustBeEmptyBeforeDeletingLK,
    en: 'The board must be empty before deleting.',
    fr: 'Le tableau doit être vide avant de le supprimer.',
    ar: 'يجب أن يكون اللوح فارغًا قبل الحذف.',
    de: 'Das Board muss leer sein, bevor es gelöscht werden kann.',
  ),
  LocaleItem(
    key: addBoardLK,
    en: 'Add Board',
    fr: 'Ajouter un tableau',
    ar: 'إضافة لوح',
    de: 'Board hinzufügen',
  ),
  LocaleItem(
    key: addTaskLK,
    en: 'Add Task',
    fr: 'Ajouter une tâche',
    ar: 'إضافة مهمة',
    de: 'Aufgabe hinzufügen',
  ),
  LocaleItem(
    key: historyLK,
    en: 'History',
    fr: 'Historique',
    ar: 'التاريخ',
    de: 'Verlauf',
  ),
  LocaleItem(
    key: updateLK,
    en: 'Update',
    fr: 'Mettre à jour',
    ar: 'تحديث',
    de: 'Aktualisieren',
  ),
  LocaleItem(
    key: confirmDeleteLK,
    en: 'Are you sure you want to delete it?',
    fr: 'Êtes-vous sûr de vouloir le supprimer ?',
    ar: 'هل أنت متأكد أنك تريد حذفه؟',
    de: 'Sind Sie sicher, dass Sie es löschen möchten?',
  ),
  LocaleItem(
    key: totalTimespanLK,
    en: 'Total timespan',
    fr: 'Durée totale',
    ar: 'المدة الإجمالية',
    de: 'Gesamtdauer',
  ),
  LocaleItem(
    key: timespansLK,
    en: 'Timespans',
    fr: 'Périodes',
    ar: 'الفترات الزمنية',
    de: 'Zeiträume',
  ),
  LocaleItem(
    key: startTimeLK,
    en: 'Start Time',
    fr: 'Heure de début',
    ar: 'وقت البدء',
    de: 'Startzeit',
  ),
  LocaleItem(
    key: endTimeLK,
    en: 'End Time',
    fr: 'Heure de fin',
    ar: 'وقت الانتهاء',
    de: 'Endzeit',
  ),
  LocaleItem(
    key: confirmCancelReminderLK,
    en: 'Are you sure you want to cancel this reminder?',
    fr: 'Êtes-vous sûr de vouloir annuler ce rappel ?',
    ar: 'هل أنت متأكد أنك تريد إلغاء هذا التذكير؟',
    de: 'Sind Sie sicher, dass Sie diese Erinnerung abbrechen möchten?',
  ),
  LocaleItem(
    key: dismissAlarmLK,
    en: 'Dismiss Alarm',
    fr: 'Rejeter l\'alarme',
    ar: 'رفض المنبه',
    de: 'Alarm abweisen',
  ),
  LocaleItem(
    key: updateTaskLK,
    en: 'Update Task',
    fr: 'Mettre à jour la tâche',
    ar: 'تحديث المهمة',
    de: 'Aufgabe aktualisieren',
  ),
  LocaleItem(
    key: taskAddedSuccessfullyLK,
    en: 'Task added successfully.',
    fr: 'Tâche ajoutée avec succès.',
    ar: 'تمت إضافة المهمة بنجاح.',
    de: 'Aufgabe erfolgreich hinzugefügt.',
  ),
  LocaleItem(
    key: taskUpdatedSuccessfullyLK,
    en: 'Task updated successfully.',
    fr: 'Tâche mise à jour avec succès.',
    ar: 'تم تحديث المهمة بنجاح.',
    de: 'Aufgabe erfolgreich aktualisiert.',
  ),
  LocaleItem(
    key: updateBoardLK,
    en: 'Update Board',
    fr: 'Mettre à jour le tableau',
    ar: 'تحديث اللوح',
    de: 'Board aktualisieren',
  ),
  LocaleItem(
    key: boardAddedSuccessfullyLK,
    en: 'Board added successfully.',
    fr: 'Tableau ajouté avec succès.',
    ar: 'تمت إضافة اللوح بنجاح.',
    de: 'Board erfolgreich hinzugefügt.',
  ),
  LocaleItem(
    key: boardUpdatedSuccessfullyLK,
    en: 'Board updated successfully.',
    fr: 'Tableau mis à jour avec succès.',
    ar: 'تم تحديث اللوح بنجاح.',
    de: 'Board erfolgreich aktualisiert.',
  ),
  LocaleItem(
    key: durationLK,
    en: 'Duration',
    fr: 'Durée',
    ar: 'المدة',
    de: 'Dauer',
  ),
  LocaleItem(
    key: noUpcomingTasksLK,
    en: 'No upcoming tasks',
    fr: 'Aucune tâche à venir',
    ar: 'لا توجد مهام قادمة',
    de: 'Keine bevorstehenden Aufgaben',
  ),
  LocaleItem(
    key: featureNotAvailableWebLK,
    en: 'This feature is not available on the web platform at the moment. It is only available on the Android app.',
    fr: 'Cette fonctionnalité n\'est pas disponible sur la plateforme web pour le moment. Elle est uniquement disponible sur l\'application Android.',
    ar: 'هذه الميزة غير متوفرة على المنصة الإلكترونية في الوقت الحالي. إنها متوفرة فقط على تطبيق Android.',
    de: 'Diese Funktion ist derzeit nicht auf der Webplattform verfügbar. Sie ist nur in der Android-App verfügbar.',
  ),
  LocaleItem(
    key: filterSearchFailureLK,
    en: 'Failed to filter and search tasks.',
    fr: 'Échec du filtrage et de la recherche des tâches.',
    ar: 'فشل في تصفية والبحث عن المهام.',
    de: 'Fehler beim Filtern und Suchen von Aufgaben.',
  ),
  LocaleItem(
    key: somethingWentWrongLK,
    en: 'Something went wrong.',
    fr: 'Quelque chose a mal tourné.',
    ar: 'حدث خطأ ما.',
    de: 'Etwas ist schiefgelaufen.',
  ),
  LocaleItem(
    key: deleteCommentLK,
    en: 'Delete Comment',
    fr: 'Supprimer le commentaire',
    ar: 'حذف التعليق',
    de: 'Kommentar löschen',
  ),
  LocaleItem(
    key: alarmScheduledAtLK,
    en: 'Alarm Scheduled At',
    fr: 'Alarme programmée à',
    ar: 'الإنذار المجدول في',
    de: 'Alarm geplant für',
  ),
];
