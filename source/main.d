module main;

import commandr				: Command, Flag, Option, parse, Program, ProgramArgs;
import sdlang					: Tag;
import std.algorithm	: filter;
import std.conv				: to;
import std.variant		: Variant;

import backup					: backup;
import config					: fetchConfigRoot, getGlobalOptions, getStages, mergeWith, stageConditions;

void main(string[] args) {
	ProgramArgs parsedArgs = new Program("collate", "1.0")
		.summary("System replication and rejuvenation toolkit")
		.author("Utkarsh Bhardwaj (Passeriform) <passeriform.ub@gmail.com>")
		.add(new Flag("v", "verbose", "turns on more verbose output")
			.name("verbose")
			.repeating)
		.add(new Option("c", "config", "path of config file (default: .\\collate.sdl)"))
		.add(new Command("backup")
			.add(new Option(null, "dryrun", "flag to dry run package updation (default: true)"))
		)
		.parse(args);

	Variant[string] globalOptions = parsedArgs.populateGlobalOptions;

	auto configRoot = fetchConfigRoot(globalOptions["config"].to!string)
		.mergeWith(parsedArgs.populateBackupOptions)
		.mergeWith(globalOptions);

	parsedArgs
	  .on("backup", (args) { processBackup(configRoot); });
}

Variant[string] populateBackupOptions(ProgramArgs subCommandArgs) {
	return [
		"dryrun": Variant(subCommandArgs.option("dryrun", "false").to!bool)
	];
}

Variant[string] populateGlobalOptions(ProgramArgs globalArgs) {
	string defaultConfigPath = (() {
		version(Windows)
			return ".\\collate.sdl";
		else version(posix)
			return "./collate.sdl";
		else
			return "./collate.sdl";
	})();
	return [
		"verbose": Variant(globalArgs.occurencesOf("verbose").to!int),
		"config": Variant(globalArgs.option("config", defaultConfigPath))
	];
}

void processBackup(Tag configRoot) {
	return configRoot
		.getStages("backup")
		.filter!(stageConditions)
		.backup(configRoot.getGlobalOptions);
}
