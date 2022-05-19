module portable;

import sdlang       : Tag;
import std.file     : mkdirRecurse;
import std.path     : buildNormalizedPath;
import std.variant  : Variant;

import download			:	getScript;
import preset				: Preset, PresetBackupResult, PresetValidateResult;
import runner				:	run;
import utility			: getCoerced, getCoercedTagValues, prepareScriptArg, generateRandomString;

class Portable : Preset {
  override PresetValidateResult validate(Tag presetOptions, Variant[string] globalOptions) {
    // Validation logic
    return true;
  }

  override PresetBackupResult backup(Tag presetOptions, Variant[string] globalOptions) {
    string targetPath = buildNormalizedPath(globalOptions.getCoerced!(string)("target", "./target"), "portable");
    targetPath.mkdirRecurse;

    string defaultLabel = presetOptions.getTagValue!(string)("include", generateRandomString(6));
    string label = presetOptions.getAttribute!(string)("label", defaultLabel);

    string includeString = presetOptions.getCoercedTagValues!(string)("include", []).prepareScriptArg!(string[]);
    string excludeString = presetOptions.getCoercedTagValues!(string)("exclude", []).prepareScriptArg!(string[]);

		getScript("backup", "portable").run([
      "-Target", targetPath,
      "-Label", label,
      "-Include", includeString,
      "-Exclude", excludeString,
    ]);
  }
}

// TODO: Abstract into mixin template
mixin Preset.register!(Portable, "portable");
