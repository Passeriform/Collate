module installable;

import sdlang       : Tag;
import std.file     : mkdirRecurse;
import std.path     : absolutePath, buildNormalizedPath;
import std.process  : spawnProcess, wait;
import std.stdio    : stderr, stdin, stdout;
import std.variant  : Variant;

import preset       : Preset, PresetBackupResult, PresetValidateResult;
import utility      : generateRandomString, getCoerced, getCoercedTagValues, prepareScriptArg;

class Installable : Preset {
  override PresetValidateResult validate(Tag presetOptions, Variant[string] globalOptions) {
    // Validation logic
    return true;
  }

  override PresetBackupResult backup(Tag presetOptions, Variant[string] globalOptions) {
    string targetPath = buildNormalizedPath(globalOptions.getCoerced!(string)("target", "./target"), "installable");
    targetPath.mkdirRecurse;

    string defaultLabel = presetOptions.getTagValue!(string)("include", generateRandomString(6));
    string label = presetOptions.getAttribute!(string)("label", defaultLabel);

    string includeString = presetOptions.getCoercedTagValues!(string)("include", []).prepareScriptArg!(string[]);
    string excludeString = presetOptions.getCoercedTagValues!(string)("exclude", []).prepareScriptArg!(string[]);

    auto pid = spawnProcess(
      [
        "powershell",
        absolutePath("registry/Backup-Installable.ps1"),
        "-Target", targetPath,
        "-Label", label,
        "-Include", includeString,
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
mixin Preset.register!(Installable, "installable");
