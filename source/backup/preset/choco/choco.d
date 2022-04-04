module choco;

import sdlang       : Tag;
import std.file     : mkdirRecurse;
import std.path     : absolutePath, buildNormalizedPath;
import std.process  : spawnProcess, wait;
import std.stdio    : stderr, stdin, stdout;
import std.variant  : Variant;

import preset       : Preset, PresetBackupResult, PresetValidateResult;
import utility      : getCoerced, getCoercedTagValues, prepareScriptArg;

class Choco : Preset {
  override PresetValidateResult validate(Tag presetOptions, Variant[string] globalOptions) {
    // Validation logic
    return true;
  }

  override PresetBackupResult backup(Tag presetOptions, Variant[string] globalOptions) {
    string targetPath = buildNormalizedPath(globalOptions.getCoerced!(string)("target", "./target"), "choco");
    targetPath.mkdirRecurse;

    string keepString = presetOptions.getCoercedTagValues!(string)("keep", []).prepareScriptArg!(string[]);
    string excludeString = presetOptions.getCoercedTagValues!(string)("exclude", []).prepareScriptArg!(string[]);

    auto pid = spawnProcess(
      [
        "powershell",
        absolutePath("registry/Backup-Choco.ps1"),
        "-Target", targetPath,
        "-Keep", keepString,
        "-Exclude", excludeString,
      ],
      stdin,
      stdout,
      stderr
    );
    scope(exit) wait(pid);
  }
}

// TODO: Abstract into mixin template
mixin Preset.register!(Choco, "choco");
