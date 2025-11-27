state("Windswept", "1.0.7 (Steam)") {
    double gameTime: "Windswept.exe", 0x1A0B398, 0x60, 0x730;
	int room: "Windswept.exe", 0x1D21888;
}

startup {
	Action<string> DebugOutput = (text) => {
		print("[Windswept Autosplitter] "+text);
	};
	vars.DebugOutput = DebugOutput;
	
	vars.DebugOutput("Windswept autosplitter starting");

	// Based on: https://github.com/NoTeefy/LiveSnips/blob/master/src/snippets/checksum(hashing)/checksum.asl
	Func<ProcessModuleWow64Safe, string> CalcModuleHash = (module) => {
		vars.DebugOutput("Calcuating hash of "+module.FileName);
		byte[] exeHashBytes = new byte[0];
		using (var sha = System.Security.Cryptography.MD5.Create())
		{
			using (var s = File.Open(module.FileName, FileMode.Open, FileAccess.Read, FileShare.ReadWrite))
			{
				exeHashBytes = sha.ComputeHash(s);
			}
		}
		var hash = exeHashBytes.Select(x => x.ToString("X2")).Aggregate((a, b) => a + b);
		vars.DebugOutput("Hash: " + hash);
		return hash;
	};
	vars.CalcModuleHash = CalcModuleHash;
	
	settings.Add("autotimer", false, "Automatically start/stop timer?");
	settings.SetToolTip("autotimer", "Automatically starts the timer during the egg break scene and resets it if you return to the title screen");

	vars.lastGoodTime = 0;
}

init {
	var module = modules.Single(x => String.Equals(x.ModuleName, "Windswept.exe", StringComparison.OrdinalIgnoreCase));
	var moduleSize = module.ModuleMemorySize;
	vars.DebugOutput("Module Size: " + moduleSize + " " + module.ModuleName);
	var hash = vars.CalcModuleHash(module);
	
	if (moduleSize == 31907840 && hash == "D288C9A5FFD5C01F125AD0695CDD6649") {
		version = "1.0.7 (Steam)";
	}
}

update {
	//vars.DebugOutput("Current room: " + current.room);
	if (version == "")
		return false;
}

gameTime {
    // Return the in-game time in seconds
	if (current.gameTime == 0)
		return TimeSpan.FromMilliseconds(vars.lastGoodTime);
	vars.lastGoodTime = current.gameTime;

    return TimeSpan.FromMilliseconds(current.gameTime);
}

exit {
	timer.IsGameTimePaused = true;
}

start {
	if (! settings["autotimer"])
		return false;
		
	return current.room == 204;	
}

reset {
	if (! settings["autotimer"])
		return false;
		
	return current.room == 0 || current.room == 1;
}

isLoading {
	return current.room == 0 || // Loading screen
		current.room == 1 || // Title screen
		current.room == 124 || // World 1
		current.room == 145 || // World 2
		current.room == 144 || // World 3
		current.room == 146 || // World 4
		current.room == 147 || // World 5
		current.room == 179 || // Clouds
		current.room == 162 || // High clouds
		current.room == 163;   // Space
}