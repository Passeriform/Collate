module cargo;

import std.stdio    : stdin, stdout, stderr;
import std.algorithm: map;
import std.array    : array;
import std.conv     : to;
import std.file     : mkdirRecurse;
import std.path     : absolutePath, buildNormalizedPath;
import std.process  : spawnProcess, wait;
import std.typecons :	Tuple;
import std.variant	:	Variant;
import sdlang       : Tag;

import preset       : Preset, PresetValidateResult, PresetBackupResult;
import utility    	:	getCoerced, getCoercedTagValues, prepareScriptArg;

class Cargo : Preset {
  override PresetValidateResult validate(Tag presetOptions, Variant[string] globalOptions) {
    // Validation logic
    return true;
  }

  override PresetBackupResult backup(Tag presetOptions, Variant[string] globalOptions) {
    string targetPath = buildNormalizedPath(globalOptions.getCoerced!(string)("target", "./target"), "cargo");
    targetPath.mkdirRecurse;

    string includeString = presetOptions.getCoercedTagValues!(string)("include", []).prepareScriptArg!(string[]);
    string excludeString = presetOptions.getCoercedTagValues!(string)("exclude", []).prepareScriptArg!(string[]);

    auto pid = spawnProcess(
      [
        "powershell",
        absolutePath("registry/Backup-Cargo.ps1"),
        "-Target", targetPath,
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
mixin Preset.register!(Cargo, "cargo");
