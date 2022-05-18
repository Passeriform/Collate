module download;

import std.path				: buildNormalizedPath;
import std.file				: exists, isFile, mkdirRecurse, tempDir;
import std.format			:	format;
import std.net.curl		:	download;

import utility				:	cmdletNounCase;

string downloadScript(string scriptType, string scriptName, string scriptPath) {
	string scriptUrl = "https://raw.githubusercontent.com/Passeriform/Collate/master/registry/%s-%s.ps1".format(
		scriptType,
		scriptName
	);

	download(scriptUrl, scriptPath);

	return scriptPath;
}

auto getScript(string scriptType, string scriptName) {
	scriptType = scriptType.cmdletNounCase;
	scriptName = scriptName.cmdletNounCase;

	version(LocalRegistry) {
		return buildNormalizedPath("registry", "%s-%s.ps1".format(scriptType, scriptName));
	} else {
		string cacheDir = buildNormalizedPath(tempDir ~ ".collate");

		cacheDir.mkdirRecurse;

		string scriptPath = buildNormalizedPath(cacheDir, "%s-%s.ps1".format(scriptType, scriptName));

		if (!scriptPath.exists) {
			downloadScript(scriptType, scriptName, scriptPath);
		}

		assert(scriptPath.exists && scriptPath.isFile);

		return scriptPath;
	}
}
