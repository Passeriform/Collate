module choco;

import std.path     : buildNormalizedPath;
import std.conv     : to;
import std.process  : execute;
import sdlang       : Tag;
import std.variant	:	Variant;

import preset       : Preset, PresetValidateResult, PresetBackupResult;

class Choco : Preset {
  override PresetBackupResult backup(Tag chocoOptions, Variant[string] globalOptions) {
    // Get default value of target here
    auto proc = execute([
      "./choco.ps1",
      "-Target", buildNormalizedPath(globalOptions["target"].to!string, "choco"),
      "-Keep", chocoOptions.getTagValue!string("keep", []),
      "-Ignore", chocoOptions.getTagValue!string("ignore", []),
    ]);

    // proc.status;
  }

}
