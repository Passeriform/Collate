module preset;

import sdlang         : Tag;
import std.variant    : Variant;

import exception			: PresetNotFoundException;

alias PresetValidateResult = bool;
alias PresetBackupResult = void;

abstract class Preset {
  private static ref Preset[string] getRegistry() {
    static Preset[string] registry;
    return registry;
  }

  public static bool _register(string strName, Preset clazz) {
    getRegistry()[strName] = clazz;
    return true;
  }

  public static Preset getPreset(string presetName) {
    if (presetName in getRegistry()) {
      return getRegistry()[presetName];
    }

    throw new PresetNotFoundException("Preset " ~ presetName ~ " wasn't found", "Maybe preset isn't registered. Register using static method `register` for Preset");
  }

  mixin template register(T, string name) {
    static this() {
      Preset._register(name, cast(Preset) new T);
    }
  }

  public abstract PresetValidateResult validate(Tag presetOptions, Variant[string] globalOptions) { return false; }
  public abstract PresetBackupResult backup(Tag presetOptions, Variant[string] globalOptions) { }
}

void validatePreset(Tag presetTag, Variant[string] globalOptions) {
  Preset.getPreset(presetTag.getValue!string).validate(presetTag, globalOptions);
}

void backupPreset(Tag presetTag, Variant[string] globalOptions) {
  Preset.getPreset(presetTag.getValue!string).backup(presetTag, globalOptions);
}
