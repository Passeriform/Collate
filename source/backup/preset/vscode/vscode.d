module vscode;

import sdlang       : Tag;
import std.file     : mkdirRecurse;
import std.path     : buildNormalizedPath;
import std.variant  : Variant;

import download			:	getScript;
import preset       : Preset, PresetBackupResult, PresetValidateResult;
import runner				:	run;
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

		getScript("backup", "vscode").run([
      "-Target", targetPath,
      "-Keep", keepString,
      "-Ignore", ignoreString,
    ]);
  }
}

mixin Preset.register!(VSCode, "vscode");
