module vscode;

import sdlang         : Tag;
import std.variant	:	Variant;

import preset       : Preset, PresetValidateResult, PresetBackupResult;

class VSCode: Preset {
  override PresetValidateResult backup(Tag vscodeOptions, Variant[string] globalOptions) {
    // Get default value of target here
    // auto proc = execute([
    //   "./vscode.ps1",
    //   "-Target", buildNormalizedPath(globalOptions.getTagValues("target"), "choco"),
    //   "-Keep", chocoOptions.getTagValues("keep", []),
    //   "-Ignore", chocoOptions.getTagValues("ignore", []),
    // ]);
    //
    // return proc.status;
  }
  override PresetValidateResult validate(Tag vscodeOptions, Variant[string] globalOptions) {
    // Validation logic
  }
}
