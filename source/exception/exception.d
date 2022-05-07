import std.array  : join;
import std.stdio  : stderr, writeln;

class SelfDescribingException : Exception {
  this(string what, string why = "", string suggestion = "", string file = __FILE__, size_t line = __LINE__) {
    stderr.writeln(what);
    stderr.writeln("\t>>" ~ why);
    stderr.writeln("\tSuggestion:" ~ suggestion);
    super([what, why, suggestion].join("\n"), file, line);
  }
}

class BackupException : SelfDescribingException {
  this(string what, string why = "", string suggestion = "", string file = __FILE__, size_t line = __LINE__) {
    super(what, why, suggestion, file, line);
  }
}

class InvalidConfigException : SelfDescribingException {
  this(string what, string why = "", string suggestion = "", string file = __FILE__, size_t line = __LINE__) {
    super(what, why, suggestion, file, line);
  }
}
