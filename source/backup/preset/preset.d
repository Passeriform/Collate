module preset;

import std.format;
import std.stdio      :	writeln;
import std.uni        :	toLower;
import std.array	:	array, split, join;
import std.range      : tail, only;
import std.algorithm	:	map, filter, equal;
import std.variant	:	Variant;
import std.meta       : aliasSeqOf;
import sdlang         : Tag;

public import choco   : Choco;
public import vscode  : VSCode;


alias PresetValidateResult = void;
alias PresetBackupResult = void;

abstract class Preset {
  abstract PresetValidateResult validate(Tag presetOptions, Variant[string] globalOptions) { }
  abstract PresetBackupResult backup(Tag presetOptions, Variant[string] globalOptions) { }
}

auto getPresets() {
  ClassInfo[] children;

  foreach(mod; ModuleInfo) {
    foreach(clazz; mod.localClasses) {
      if (clazz.base == typeid(Preset)) {
        children ~= clazz;
      }
    }
  }

  return children;
}

auto getPreset(string presetName) {
  return getPresets.filter!((presetInfo) => presetInfo.name.split(".").tail(1).map!toLower.array.equal(only(presetName.toLower))).array[0].name;
}

// mixin template injectDispatch(alias presetTag) {
//   string presetType = presetTag.getValue!string();
//   string presetOptions = presetTag.tags;
//
//   Presets = aliasSeqOf!([__traits(allMembers, S)].sort().map!capitalize());
//
//   void operate(auto presetOptions, auto backupOptions, auto globalOptions, auto defaultOperation = () {}) {
//     SW: switch (presetType.toLower) {
//       static foreach (T; SupportedTypes) {
//     		case T.stringof:
//     			result = new T;
//     			break SW;
//     	}
//     	default:
//     		throw new Exception("Unknown object type");
//       case "choco":
//         // TODO: Use mergeWith here
//         Choco.proxy(presetOptions, backupOptions, globalOptions);
//         break;
//       case "vscode":
//         VSCode.proxy(presetOptions, backupOptions, globalOptions);
//         break;
//       default:
//         defaultOperation();
//     }
//   }
// }

void validatePreset(Tag presetTag, Variant[string] globalOptions) {
  // mixin(getPreset(presetTag.getValue!string) ~ ".validate(presetTag.tags, globalOptions)");
  getPreset(presetTag.getValue!string).validate(presetTag.tags, globalOptions);
  // mixin injectDispatch!(presetTag, "validate");
  // operate(presetOptions, backupOptions, globalOptions, delegate {
  //   auto message = format("Invalid preset %s. Choose from list %(%s\n %)", presetType, PRESET_NAMES);
  //   stderr.writeln(message);
  //   throw new ValidationError(message);
  // });
}

void backupPreset(Tag presetTag, Variant[string] options) {
  // mixin injectOperation!(presetTag, () { backup(); });
  // operate(presetOptions, backupOptions, globalOptions);
}

class ValidationError : Exception {
    this(string msg, string file = __FILE__, size_t line = __LINE__) {
        super(msg, file, line);
    }
}
