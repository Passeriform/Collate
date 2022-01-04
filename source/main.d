module main;

import std.stdio		:	writeln;
import std.variant	:	Variant;
import std.conv			:	to;
import commandr			:	ProgramArgs, Program, Flag, Command, Argument, Option, parse;
import backup				:	backup;
import config;

void main(string[] args) {
	auto parsedArgs = new Program("collate", "1.0")
		.summary("System replication and rejuvenation toolkit")
		.author("Utkarsh Bhardwaj (Passeriform) <passeriform.ub@gmail.com>")
		.add(new Flag("v", "verbose", "turns on more verbose output")
			.name("verbose")
			.repeating)
		.add(new Command("backup")
			.add(new Option(null, "dryrun", "flag to dry run package updation (default: true)"))
		)
		.add(new Option("c", "config", "path of config file (default: collate.sdl)"))
		.parse(args);

	Variant[string] globalOptions = parsedArgs.populateGlobalOptions;

	parsedArgs
	  .on("backup", (args) {
			processBackup(
				args.populateBackupOptions,
				globalOptions
			);
	  });
}

Variant[string] populateBackupOptions(ProgramArgs subCommandArgs) {
	Variant[string] backupOptions;

	backupOptions["dryrun"] = subCommandArgs.option("dryrun");

	return backupOptions;
}

Variant[string] populateGlobalOptions(ProgramArgs globalArgs) {
	Variant[string] globalOptions;

	globalOptions["verbose"] = globalArgs.occurencesOf("verbose");
	globalOptions["config"] = globalArgs.option("config", "collate.sdl");

	return globalOptions;
}

void processBackup(Variant[string] args, Variant[string] globalArgs) {
	auto configRoot = fetchConfigRoot(globalArgs["config"].to!string)
		.mergeWith(args)
		.mergeWith(globalArgs);

	auto globalOptions = configRoot.getGlobalOptions;

	// TODO: Accept stages on the basis on occurance in the config file.
	auto backupEntries = configRoot.getStages("backup");

	backup(backupEntries, globalOptions);
}
