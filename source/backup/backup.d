module backup;

import std.stdio : writeln;
import std.algorithm.iteration : each;
import std.variant  : Variant;
import sdlang                   : Tag;

import preset       : validatePreset, backupPreset;
import config       : getPresets;

void backup(Tag[] backupEntries, Variant[string] globalOptions) {
  // Override backup options with the latest entry in config for backup stage
  foreach(backupEntry; backupEntries) {
    auto presetEntries = backupEntry.getPresets;

    // Halts execution on exception throw
    presetEntries.each!((presetEntry) => presetEntry.validatePreset(globalOptions));
    presetEntries.each!((presetEntry) => presetEntry.backupPreset(globalOptions));
  }
}
