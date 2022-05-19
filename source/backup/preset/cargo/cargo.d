module cargo;

import sdlang       : Tag;
import std.file     : mkdirRecurse;
import std.path     : buildNormalizedPath;
import std.variant  : Variant;

import download			:	getScript;
import preset       : Preset, PresetBackupResult, PresetValidateResult;
import runner				:	run;
import utility      : getCoerced, getCoercedTagValues, prepareScriptArg;

class Cargo : Preset {
  override PresetValidateResult validate(Tag presetOptions, Variant[string] globalOptions) {
    return true;
  }

  override PresetBackupResult backup(Tag presetOptions, Variant[string] globalOptions) {
    string targetPath = buildNormalizedPath(globalOptions.getCoerced!(string)("target", "./target"), "cargo");
    targetPath.mkdirRecurse;

    string includeString = presetOptions.getCoercedTagValues!(string)("include", []).prepareScriptArg!(string[]);
    string excludeString = presetOptions.getCoercedTagValues!(string)("exclude", []).prepareScriptArg!(string[]);

		getScript("backup", "cargo").run([
			"-Target", targetPath,
			"-Include", includeString,
			"-Exclude", excludeString,
		]);
  }
}

// TODO: Abstract into mixin template
mixin Preset.register!(Cargo, "cargo");
