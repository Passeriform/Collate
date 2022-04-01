module gitrepo;

import sdlang       : Tag;
import std.file     : mkdirRecurse;
import std.path     : absolutePath, buildNormalizedPath;
import std.process  : spawnProcess, wait;
import std.stdio    : stderr, stdin, stdout;
import std.variant  : Variant;

import preset       : Preset, PresetBackupResult, PresetValidateResult;
import utility      : getCoerced, getCoercedTagValues, prepareScriptArg;

class GitRepo : Preset {
  override PresetValidateResult validate(Tag presetOptions, Variant[string] globalOptions) {
    // Validation logic
    return true;
  }

  override PresetBackupResult backup(Tag presetOptions, Variant[string] globalOptions) {
    string targetPath = buildNormalizedPath(globalOptions.getCoerced!(string)("target", "./target"), "gitrepo");
    targetPath.mkdirRecurse;

    string depth = presetOptions.getAttribute!(int)("depth", 0).prepareScriptArg!(int);
    bool recurse = presetOptions.getAttribute!(bool)("recurse", false);

    string scanroot = presetOptions.expectTagValue!(string)("scanroot").prepareScriptArg!(string);
    string includeString = presetOptions.getCoercedTagValues!(string)("include", []).prepareScriptArg!(string[]);
    string excludeString = presetOptions.getCoercedTagValues!(string)("exclude", []).prepareScriptArg!(string[]);

    auto pid = spawnProcess(
      [
        "powershell",
        absolutePath("registry/Backup-GitRepo.ps1"),
        "-Target", targetPath,
        recurse ? "-Recurse" : "",
        "-Depth", depth,
        "-Exclude", excludeString,
        scanroot,
      ],
      stdin,
      stdout,
      stderr
    );
    scope(exit) wait(pid);
  }
}

// TODO: Abstract into mixin template
mixin Preset.register!(GitRepo, "gitrepo");
