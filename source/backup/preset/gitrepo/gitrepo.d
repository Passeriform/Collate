module gitrepo;

import sdlang       : Tag;
import std.file     : mkdirRecurse;
import std.path     : buildNormalizedPath;
import std.variant  : Variant;

import download			:	getScript;
import preset       : Preset, PresetBackupResult, PresetValidateResult;
import runner				:	run;
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

		getScript("backup", "GitRepo").run([
      "-Target", targetPath,
      recurse ? "-Recurse" : "",
      "-Depth", depth,
      "-Exclude", excludeString,
      scanroot,
    ]);
  }
}

// TODO: Abstract into mixin template
mixin Preset.register!(GitRepo, "gitrepo");
