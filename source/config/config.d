module config;

import std.stdio                : writeln, stderr;
import std.algorithm            : each, filter, map, find, joiner, canFind;
import std.array;
import std.variant              : Variant;
import std.range                : chain;
import std.uni                  : toLower;
import std.typecons             : tuple;
import std.file                 : readText;
import std.path                 : baseName, asAbsolutePath;
import sdlang                   : Tag, parseSource, ParseException;

Tag fetchConfigRoot(string configPath) {
  Tag root;

  try {
    // SDLang-D doesn't work properly with windows paths. Hence the extra readText
    root = parseSource(configPath.readText, baseName(configPath));
  } catch(ParseException e) {
		stderr.writeln(e.msg);
		throw e;
	}

  return root;
}

auto getGlobalOptions(Tag root) {
  auto reservedEntries = [
    "stage",
    "env",
  ];

  return root.tags
    .filter!((tagElem) => !reservedEntries.canFind(tagElem.name)).array
    // Change getValue template to proper type
    .map!((tagElem) => tuple(tagElem.name, cast(Variant) tagElem.getValue!string()))
    .assocArray;
}

auto getStages(Tag root) {
  return root.tags.filter!((tagElem) => tagElem.name.toLower == "stage").array;
}

auto getStages(Tag root, string stageName) {
  return root.getStages
    .filter!((tagElem) => tagElem.getValue!string() == stageName).array;
}

auto getPresets(Tag root) {
  return root.tags.filter!((tagElem) => tagElem.name.toLower == "preset").array;
}

auto getPresets(Tag root, string presetName) {
  return root.getStages
    .filter!((tagElem) => tagElem.getValue!string() == presetName).array;
}

Tag mergeWith(Tag existingConfig, Variant[string] overloadMap) {
  // Tag newConfig = existingConfig.map!(
  //   (configKey)
  // );
  return existingConfig;
}
