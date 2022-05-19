module config;

import sdlang         : ParseException, parseSource, Tag, Value, Attribute;
import std.algorithm  : canFind, filter, find, map, fold;
import std.array      : array, assocArray;
import std.file       : readText;
import std.path       : baseName;
import std.range			: empty;
import std.typecons   : tuple;
import std.uni        : toLower, sicmp;
import std.variant    : Variant;

import exception      : InvalidConfigException;
import utility        : getTargetOSString;

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
    .map!((tagElem) => tuple(tagElem.name, tagElem.resolveGlobalValue))
    .assocArray;
}

Variant resolveGlobalValue(Tag variable) {
	switch(variable.name) {
		case "target":
			return Variant(variable.values.filter!(
				(value) {
					version(Windows)
						return !value.toString.find("\\").empty;
					else version(posix)
						return value.toString.find("\\").empty;
					else
						return value.toString.find("\\").empty;
				}
			).front);
		default:
			return Variant(variable.getValue!string());
	}
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

// TODO: Make more functional
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

auto stageConditions(T = Tag, U = Variant)(T entry) {
	immutable (bool function(U))[string] attrFilters = [
		"os": function bool(U attrValue) { return attrValue.toString.sicmp(getTargetOSString) == 0; },
	];

	auto validConditionalAttrs = entry.attributes.filter!((Attribute attr) => attrFilters.keys.canFind(attr.name)).array;
	return validConditionalAttrs.fold!((acc, attr) => acc && attrFilters[attr.name](cast(Variant)attr.value))(true);
}
