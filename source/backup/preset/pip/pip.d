module pip;

import std.stdio    : stdout, stdin, stderr;
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

class Pip : Preset {
  override PresetValidateResult validate(Tag presetOptions, Variant[string] globalOptions) {
    // Validation logic
    return true;
  }

  override PresetBackupResult backup(Tag presetOptions, Variant[string] globalOptions) {
    string targetPath = buildNormalizedPath(globalOptions.getCoerced!(string)("target", "./target"), "pip");
    targetPath.mkdirRecurse;

    string includeDirString = presetOptions.getCoercedTagValues!(string)("includeDir", []).prepareScriptArg!(string[]);
    string includeString = presetOptions.getCoercedTagValues!(string)("include", []).prepareScriptArg!(string[]);
    string excludeString = presetOptions.getCoercedTagValues!(string)("exclude", []).prepareScriptArg!(string[]);

    auto pid = spawnProcess(
      [
        "powershell",
        absolutePath("registry/Backup-Pip.ps1"),
        "-Target", targetPath,
        "-IncludeDir", includeDirString,
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
mixin Preset.register!(Pip, "pip");
