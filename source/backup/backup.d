module backup;

import sdlang         : Tag;
import std.algorithm  : each;
import std.file       : FileException, mkdirRecurse;
import std.variant    : Variant;

import config         : getPresets;
import exception      : BackupException;
import preset         : backupPreset, validatePreset;
import utility        : getCoerced;

void backup(Tag[] backupEntries, Variant[string] globalOptions) {
  // Create backup target folder if doesn't exist
  try {
    globalOptions.getCoerced!(string)("target", "./target").mkdirRecurse;
  } catch(FileException ex) {
    throw new BackupException(
      "Exception occurred while creating backup directory.\n\t" ~ ex.msg,
      "Maybe the backup directory isn't accessible.",
      "Make sure the directory is accessible and try again."
    );
  }

  // Override backup options with the latest entry in config for backup stage
  foreach(backupEntry; backupEntries) {
    Tag[] presetEntries = backupEntry.getPresets;

    // Halts execution on exception throw
    presetEntries.each!((presetEntry) => presetEntry.validatePreset(globalOptions));
    presetEntries.each!((presetEntry) => presetEntry.backupPreset(globalOptions));
  }
}
