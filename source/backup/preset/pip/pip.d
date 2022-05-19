module pip;

import sdlang       : Tag;
import std.file     : mkdirRecurse;
import std.path     : buildNormalizedPath;
import std.variant  : Variant;

import download			:	getScript;
import preset       : Preset, PresetBackupResult, PresetValidateResult;
import runner				:	run;
import utility      : getCoerced, getCoercedTagValues, prepareScriptArg;

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

		getScript("backup", "pip").run([
      "-Target", targetPath,
      "-IncludeDir", includeDirString,
      "-Include", includeString,
      "-Exclude", excludeString,
    ]);
  }
}

// TODO: Abstract into mixin template
mixin Preset.register!(Pip, "pip");
