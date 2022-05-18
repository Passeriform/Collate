module utility;

import sdlang         : Tag, Value;
import std.algorithm  : map;
import std.array      : array, join;
import std.ascii      : letters;
import std.conv       : to;
import std.random     : uniform;
import std.range      : iota;
import std.traits     : isArray, isAssociativeArray, isSomeString;

T getOrElse(T)(T maybeValue, T defaultValue) {
  bool shouldDefault = maybeValue == null;

  if (isArray!(T) || isAssociativeArray!(T)) {
    shouldDefault = maybeValue.length == 0;
  }

  return shouldDefault ? defaultValue : maybeValue;
}

C getCoerced(C, K, V)(
  V[K] aa,
  K key,
  lazy inout(C) defaultValue
) {
  return aa.get(key, V(defaultValue)).coerce!(C);
}

T[] getCoercedTagValues(T)(Tag tag, string label, lazy Value[] defaultValues) {
  return tag.getTagValues(label, defaultValues).map!(_ => _.coerce!(T)).array;
}

string prepareScriptArg(T : T[])(T[] argArray)
  if (!isSomeString!(T[])) {
  return argArray
    .to!(string[])
    .map!(quoteSanitize)
    .join(", ")
    .getOrElse("@()");
}

string prepareScriptArg(T)(T arg) {
  return arg
    .to!(string)
    .quoteSanitize
    .getOrElse("");
}

string quoteSanitize(T)(T value) {
  return "\"" ~ value.to!string ~ "\"";
}

string generateRandomString(int length) {
  return iota(length).map!(_ => letters[uniform(0, $)]).array;
}
string cmdletNounCase(string inString) {
	return inString.split("-").map!((part) => part.capitalize).join;
}
