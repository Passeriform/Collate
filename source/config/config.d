module config;

import sdlang         : ParseException, parseSource, Tag, Value;
import std.algorithm  : filter, map, canFind;
import std.array      : array, assocArray;
import std.file       : readText;
import std.path       : baseName;
import std.typecons   : tuple;
import std.uni        : toLower;
import std.variant    : Variant;

import exception      : InvalidConfigException;

Tag fetchConfigRoot(string configPath) {
  Tag root;

  try {
    // SDLang-D doesn't work properly with windows paths. Hence the extra readText
    root = parseSource(configPath.readText, baseName(configPath));
  } catch(ParseException e) {
    throw new InvalidConfigException(
      "Config was found to be invalid\n\t" ~ e.msg,
      "Error occurred while parsing the config file",
      "Try fixing the issues in config file and try again"
    );
  }

  return root;
}

Variant[string] getGlobalOptions(Tag root) {
  string[] reservedEntries = [
    "stage",
    "env",
  ];

  return root.tags
    .filter!((tagElem) => !reservedEntries.canFind(tagElem.name)).array
    // HACK: Mandatory type erasure.
    .map!((tagElem) => tuple(tagElem.name, Variant(tagElem.getValue!string())))
    .assocArray;
}

Tag[] getStages(Tag root) {
  return root.tags.filter!((tagElem) => tagElem.name.toLower == "stage").array;
}

Tag[] getStages(Tag root, string stageName) {
  return root.getStages
    .filter!((tagElem) => tagElem.getValue!string() == stageName).array;
}

Tag[] getPresets(Tag root) {
  return root.tags.filter!((tagElem) => tagElem.name.toLower == "preset").array;
}

Tag[] getPresets(Tag root, string presetName) {
  return root.getStages
    .filter!((tagElem) => tagElem.getValue!string() == presetName).array;
}

Tag mergeWith(Tag existingConfig, Variant[string] overloadMap) {
  for (int i = 0; i < existingConfig.tags.length; i++) {
    string tagName = existingConfig.tags[i].getFullName.toString;
    if (tagName in overloadMap) {
      // HACK: Mandatory type erasure.
      Value[] newValues= array([Value(overloadMap[tagName].coerce!string)]);
      existingConfig.tags[i].values = newValues;
    }
  }
  return existingConfig;
}
