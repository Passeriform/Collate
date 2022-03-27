module preset;

import std.format;
import std.stdio      : writeln;
import std.uni        : toLower;
import std.array      : array, split, join;
import std.range      : tail, only;
import std.algorithm  : map, filter, equal, find;
import std.typecons   : Tuple;
import std.variant    : Variant;
import std.meta       : aliasSeqOf;
import sdlang         : Tag;

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

    throw new PresetNotFoundException("Preset wasn't found", "Maybe preset isn't registered. Register using static method `register` for Preset");
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

class PresetNotFoundException : Exception {
    this(string msg, string suggestion, string file = __FILE__, size_t line = __LINE__) {
        super(msg ~ "\n" ~ suggestion, file, line);
    }
}

class ValidationError : Exception {
    this(string msg, string file = __FILE__, size_t line = __LINE__) {
        super(msg, file, line);
    }
}

class BackupError : Exception {
    this(string msg, string file = __FILE__, size_t line = __LINE__) {
        super(msg, file, line);
    }
}
