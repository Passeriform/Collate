/+ dub.sdl:
	name "dependencyResolver"
	targetPath "../target"
+/
import std.algorithm		:	all, each, filter, endsWith;
import std.file					:	copy, dirEntries, DirEntry, exists, isDir, isFile, mkdirRecurse, rmdirRecurse, SpanMode;
import std.net.curl			:	download;
import std.path					:	baseName, buildNormalizedPath, extension, stripExtension;
import std.process			: spawnProcess, wait;
import std.stdio				:	stdin, stdout, stderr;

auto resolveDependencyUrl(string[string] osMap) {
	version(Windows) {
		return osMap["windows"];
	} else version(linux) {
		return osMap["linux"];
	} else version(macos) {
		return osMap["osx"];
	}
}

string depsArchivePath = "vendor/archives";
string depsBinPath = "vendor/bin";

enum dependencyMap = [
	"powershell" : resolveDependencyUrl([
		"windows": "https://github.com/PowerShell/PowerShell/releases/download/v7.2.3/PowerShell-7.2.3-win-x64.zip",
		"linux": "https://github.com/PowerShell/PowerShell/releases/download/v7.2.3/powershell-7.2.3-linux-x64.tar.gz",
		"osx": "https://github.com/PowerShell/PowerShell/releases/download/v7.2.3/powershell-7.2.3-osx-x64.tar.gz",
	]),
	"7z": resolveDependencyUrl([
		"windows": "https://www.7-zip.org/a/7z2107.zip",
		"linux": "https://www.7-zip.org/a/7z2107-linux-x86.tar.xz",
		"osx": "https://www.7-zip.org/a/7z2107-mac.tar.xz",
	])
];

bool refreshRequired() {
	return dependencyMap.keys.all!(
		(string dependencyName) {
			const dependencyExtractedPath = "vendor/" ~ dependencyName;
			return !dependencyExtractedPath.exists || !dependencyExtractedPath.isDir;
		}
	);
}

void downloadDependencies() {
	depsArchivePath.mkdirRecurse;

	dependencyMap.keys.each!(
		(string dependencyName) {
			const archiveDownloadPath = buildNormalizedPath(depsArchivePath, dependencyName ~ dependencyMap[dependencyName].extension);

			if (archiveDownloadPath.exists) {
				assert(!archiveDownloadPath.isDir);
				return;
			}

			download(
				dependencyMap[dependencyName],
				archiveDownloadPath
			);
		}
	);
}

void extractArchives() {
	foreach (DirEntry archive; dirEntries(depsArchivePath, SpanMode.shallow).filter!((DirEntry entry) => entry.name.endsWith(".gz", ".xz", ".tar", ".zip"))) {
		const extractionDir = "vendor/" ~ archive.name.baseName.stripExtension;

		extractionDir.mkdirRecurse;

		if (archive.name.extension == ".zip") {
			auto pid = spawnProcess(
				[
					"unzip",
					"-d", extractionDir,
					archive.name,
				],
				stdin,
				stdout,
				stderr
			);
			scope(exit) wait(pid);
		} else {
			auto pid = spawnProcess(
				[
					"tar",
					"-xf",
					archive.name,
					"--directory", extractionDir,
				],
				stdin,
				stdout,
				stderr
			);
			scope(exit) wait(pid);
		}

		linkBinary(extractionDir);
	}
}

void linkBinary(string dependencyDir) {
	depsBinPath.mkdirRecurse;
	foreach (DirEntry dependencyExec; dirEntries(dependencyDir, SpanMode.shallow).filter!((DirEntry entry) => entry.name.exists && entry.name.isFile)) {
		dependencyExec.name.copy(buildNormalizedPath(depsBinPath, dependencyExec.name.baseName));
	}
}

void deleteArchives() {
	depsArchivePath.rmdirRecurse;
}

void main(string[] args) {
	if (!refreshRequired()) {
		return;
	}

	downloadDependencies();
	extractArchives();
	deleteArchives();
}
