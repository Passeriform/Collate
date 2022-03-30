module steam;

import sdlang       : Tag;
import std.file     : mkdirRecurse;
import std.path     : absolutePath, buildNormalizedPath;
import std.process  : spawnProcess, wait;
import std.stdio    : stderr, stdin, stdout;
import std.variant  : Variant;

import preset       : Preset, PresetBackupResult, PresetValidateResult;
import utility      : getCoerced, getCoercedTagValues, prepareScriptArg;

class Steam : Preset {
  override PresetValidateResult validate(Tag presetOptions, Variant[string] globalOptions) {
    // Validation logic
    return true;
  }

  override PresetBackupResult backup(Tag presetOptions, Variant[string] globalOptions) {
    string targetPath = buildNormalizedPath(globalOptions.getCoerced!(string)("target", "./target"), "steam");
    targetPath.mkdirRecurse;

    string keepString = presetOptions.getCoercedTagValues!(string)("keep", []).prepareScriptArg!(string[]);
    string ignoreString = presetOptions.getCoercedTagValues!(string)("ignore", []).prepareScriptArg!(string[]);

    auto pid = spawnProcess(
      [
        "powershell",
        absolutePath("registry/Backup-Steam.ps1"),
        "-Target", targetPath,
        "-Keep", keepString,
        "-Ignore", ignoreString,
      ],
      stdin,
      stdout,
      stderr
    );
    scope(exit) wait(pid);
  }
}

// TODO: Abstract into mixin template
mixin Preset.register!(Steam, "steam");
