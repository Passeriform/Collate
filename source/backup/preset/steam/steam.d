module steam;

import sdlang       : Tag;
import std.file     : mkdirRecurse;
import std.path     : buildNormalizedPath;
import std.variant  : Variant;

import download			:	getScript;
import preset       : Preset, PresetBackupResult, PresetValidateResult;
import runner				:	run;
import utility      : getCoerced, getCoercedTagValues, prepareScriptArg;

class Steam : Preset {
  override PresetValidateResult validate(Tag presetOptions, Variant[string] globalOptions) {
    // Validation logic
    return true;
  }

  override PresetBackupResult backup(Tag presetOptions, Variant[string] globalOptions) {
    string targetPath = buildNormalizedPath(globalOptions.getCoerced!(string)("target", "./target"), "steam");
    targetPath.mkdirRecurse;

    string includeString = presetOptions.getCoercedTagValues!(string)("include", []).prepareScriptArg!(string[]);
    string ignoreString = presetOptions.getCoercedTagValues!(string)("ignore", []).prepareScriptArg!(string[]);

		getScript("backup", "steam").run([
      "-Target", targetPath,
      "-Include", includeString,
      "-Ignore", ignoreString,
    ]);
  }
}

// TODO: Abstract into mixin template
mixin Preset.register!(Steam, "steam");
