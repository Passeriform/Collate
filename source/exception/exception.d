import std.array  : join;
import std.format	: format;
import std.stdio  : stderr;

class SelfDescribingException : Exception {
  this(string what, string why = "", string suggestion = "", string file = __FILE__, size_t line = __LINE__) {
    stderr.writeln(q{
			%s
				>>	%s
				Suggestion:	%s
		}.format(what, why, suggestion));
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

class PresetNotFoundException : SelfDescribingException {
	this(string what, string why = "", string suggestion = "", string file = __FILE__, size_t line = __LINE__) {
    super(what, why, suggestion, file, line);
  }
}

class ValidationError : SelfDescribingException {
	this(string what, string why = "", string suggestion = "", string file = __FILE__, size_t line = __LINE__) {
    super(what, why, suggestion, file, line);
  }
}

class BackupError : SelfDescribingException {
	this(string what, string why = "", string suggestion = "", string file = __FILE__, size_t line = __LINE__) {
    super(what, why, suggestion, file, line);
  }
}
