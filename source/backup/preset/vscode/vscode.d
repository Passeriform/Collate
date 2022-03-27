module vscode;

import std.stdio    : stdout, stdin, stderr;
import std.algorithm: map;
import std.array    : array;
import std.conv     : to;
import std.file     : mkdirRecurse;
import std.path     : absolutePath, buildNormalizedPath;
import std.process  : spawnProcess, wait;
import std.typecons : Tuple;
import std.variant  : Variant;
import sdlang       : Tag;

import preset       : Preset, PresetValidateResult, PresetBackupResult;
import utility      : getCoerced, getCoercedTagValues, prepareScriptArg;

class VSCode : Preset {
  override PresetValidateResult validate(Tag vscodeOptions, Variant[string] globalOptions) {
    // Validation logic
    return true;
  }

  override PresetBackupResult backup(Tag presetOptions, Variant[string] globalOptions) {
    string targetPath = buildNormalizedPath(globalOptions.getCoerced!(string)("target", "./target"), "vscode");
    targetPath.mkdirRecurse;

    string keepString = presetOptions.getCoercedTagValues!(string)("keep", []).prepareScriptArg!(string[]);
    string ignoreString = presetOptions.getCoercedTagValues!(string)("ignore", []).prepareScriptArg!(string[]);

    auto pid = spawnProcess(
      [
        "powershell",
        absolutePath("registry/Backup-VSCode.ps1"),
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

mixin Preset.register!(VSCode, "vscode");
