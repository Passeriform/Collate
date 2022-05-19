module runner;

import std.path     : absolutePath;
import std.process  : spawnProcess, wait, environment;
import std.stdio    : stderr, stdin, stdout;

import download		:	getScript;

void run(string scriptPath, string[] args) {
	auto pid = spawnProcess(
		[
			"vendor/powershell/pwsh",
			"-Command",
			scriptPath,
		] ~ args,
		stdin,
		stdout,
		stderr,
		[ "PATH": absolutePath("vendor/bin") ~ ":" ~ environment.get("PATH") ],
	);
	scope(exit) wait(pid);
}
