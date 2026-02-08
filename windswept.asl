// Gamemaker has a class CInstance that stores variables; the variables are stored in a hashmap at offset 0x48 in the CInstance.
// Globals are stored in a global CInstance - "GlobalData" - a pointer to which is at a fixed offset.
// The indices for each global variable are also stored at fixed offsets, conveniently next to a pointer to a name for the global.
//
// We have a selection of global variables we monitor and we have some code to do the hashmap lookup to actually find them in the global
// CInstance. This should make it relatively easy to find them again on version changes with Ghidra because all of the indices are next to
// a string, leaving just GlobalData (which can be tracked down by looking at uses of the indices), and the room number (easy to find because
// we knows the specific values it takes).
//
// Gamemaker variables are stored as:
// struct RValue
// {
//   union { double doubleVal; uint64_t uint64_val; CInstance* obj_val; /* etc */ }
//   uint32_t flags;
//   uint32_t type;
// }
//
// The variables we look at are:
// - array_StageClear: Array indicating which stage exits have been completed. Each stage has two entries in the array; 0 indicates not done; 1 indicates complete; 2 indicates complete with pinwheel. We use it for splits.
// - timer_Full: Double, in game time in milliseconds.
// - timer_Stop: Double. When > 0, timer is paused; also == 2 during stage clear animations and start-of-game cutscene so could be used for splits.
// - stageType: Double. An enum, 0 == title, 1 == file selection, 2 == arcade, 3 == overworld, > indicates in a level. Used to determine if timer is paused.
// - frameCountRoom: Double; frames since room started. If < 30 the timer is paused to load textures and things.

state("Windswept", "1.1.01 Hotfix (Steam)") {
	int room: "Windswept.exe", 0x1d39c78 ;
	
	// GlobalData's hashmap.
	long globalDataHashMap: "Windswept.exe", 0x1a1d450, 0x48;

	// Variable indices
	long arrayStageClearIndex: "Windswept.exe", 0x19b63f8;
	long timerFullIndex: "Windswept.exe", 0x19b6a38 ; // timer_Full
	long timerStopIndex: "Windswept.exe", 0x19b66f8 ; // timer_Stop
	long stageTypeIndex: "Windswept.exe", 0x19b3d58 ; // stageType
	long frameCountRoomIndex: "Windswept.exe", 0x19b6548 ;
}

state("Windswept", "1.1.01 (Steam)") {
	int room: "Windswept.exe", 0x1d36b88;
	
	// GlobalData's hashmap.
	long globalDataHashMap: "Windswept.exe", 0x1a1a360, 0x48;

	// Variable indices
	long arrayStageClearIndex: "Windswept.exe", 0x19b33a8;
	long timerFullIndex: "Windswept.exe", 0x19b39e8;
	long timerStopIndex: "Windswept.exe", 0x19b36c8;
	long stageTypeIndex: "Windswept.exe", 0x19b0ce8;
	long frameCountRoomIndex: "Windswept.exe", 0x19b3508;
}

state("Windswept", "1.1.0 (Steam)") {
	int room: "Windswept.exe", 0x1d36b48;
	
	// GlobalData's hashmap.
	long globalDataHashMap: "Windswept.exe", 0x1a1a320, 0x48;

	// Variable indices
	long arrayStageClearIndex: "Windswept.exe", 0x19b33a8;
	long timerFullIndex: "Windswept.exe", 0x19b39e8;
	long timerStopIndex: "Windswept.exe", 0x19b36b8;
	long stageTypeIndex: "Windswept.exe", 0x19b0d08;
	long frameCountRoomIndex: "Windswept.exe", 0x19b3508;
}

state("Windswept", "1.0.9.1 (Steam)") {
	int room: "Windswept.exe", 0x1d34b18;
	
	// GlobalData's hashmap.
	long globalDataHashMap: "Windswept.exe", 0x1a182f0, 0x48;

	// Variable indices
	long arrayStageClearIndex: "Windswept.exe", 0x19b1338;
	long timerFullIndex: "Windswept.exe", 0x19b1948;
	long timerStopIndex: "Windswept.exe", 0x19b1638;
	long stageTypeIndex: "Windswept.exe", 0x19aec88;
	long frameCountRoomIndex: "Windswept.exe", 0x19b1468;
}

state("Windswept", "1.0.9 (Steam)") {
	int room: "Windswept.exe", 0x1d34b18;
	
	// GlobalData's hashmap.
	long globalDataHashMap: "Windswept.exe", 0x1a182f0, 0x48;

	// Variable indices
	long arrayStageClearIndex: "Windswept.exe", 0x19b1338;
	long timerFullIndex: "Windswept.exe", 0x19b1958;
	long timerStopIndex: "Windswept.exe", 0x19b1638;
	long stageTypeIndex: "Windswept.exe", 0x19aec68;
	long frameCountRoomIndex: "Windswept.exe", 0x19b1478;
}

state("Windswept", "1.0.8 (GOG)") {
	int room: "Windswept.exe", 0x1d35758;
	
	// GlobalData's hashmap.
	long globalDataHashMap: "Windswept.exe", 0x1a18f30, 0x48;
	
	// Variable indices
	long arrayStageClearIndex: "Windswept.exe", 0x19b2af8;
	long timerFullIndex: "Windswept.exe", 0x19b28c8;
	long timerStopIndex: "Windswept.exe", 0x19b25b8;
	long stageTypeIndex: "Windswept.exe", 0x19afbf8;
	long frameCountRoomIndex: "Windswept.exe", 0x19b23f8;
}

state("Windswept", "1.0.8.1 (Steam)") {
	int room: "Windswept.exe", 0x1d2a858;
	
	// GlobalData's hashmap.
	long globalDataHashMap: "Windswept.exe", 0x1a0e030, 0x48;
	
	// Variable indices
	long arrayStageClearIndex: "Windswept.exe", 0x19a72c8;
	long timerFullIndex: "Windswept.exe", 0x19a78f8;
	long timerStopIndex: "Windswept.exe", 0x19a75c8;
	long stageTypeIndex: "Windswept.exe", 0x19a4c18;
	long frameCountRoomIndex: "Windswept.exe", 0x19a7418;
}

state("Windswept", "1.0.7 (Steam)") {
	int room: "Windswept.exe", 0x1D21888;
	
	// GlobalData's hashmap.
	long globalDataHashMap: "Windswept.exe", 0x1a05060, 0x48;
	
	// Variable indices
	long arrayStageClearIndex: "Windswept.exe", 0x199e428;
	long timerFullIndex: "Windswept.exe", 0x199ea38;
	long timerStopIndex: "Windswept.exe", 0x199e718;
	long stageTypeIndex: "Windswept.exe", 0x199bd98;
	long frameCountRoomIndex: "Windswept.exe", 0x199e568;
}

startup {
	Action<string> DebugOutput = (text) => {
		print("[Windswept Autosplitter] " + text);
	};
	vars.DebugOutput = DebugOutput;
	
	vars.DebugOutput("Windswept autosplitter starting");
	
	// Function to do the hashmap linear probe using Robin Hood hashing
	// Returns the RValue* (the value pointer), or IntPtr.Zero if not found
	Func<Process, IntPtr, long, IntPtr> HashmapLookup = (process, hashmapPtr, key) => {
		if (hashmapPtr == IntPtr.Zero)
			return IntPtr.Zero;
		
		// Read hashmap structure (GMVarHashmap)
		// +0x00: int32_t capacity
		// +0x04: int32_t count
		// +0x08: int32_t mask
		// +0x0c: int32_t loadThreshold
		// +0x10: HashMapBucket* data
		
		int capacity = process.ReadValue<int>(hashmapPtr + 0x00);
		int count = process.ReadValue<int>(hashmapPtr + 0x04);
		int mask = process.ReadValue<int>(hashmapPtr + 0x08);
		int loadThreshold = process.ReadValue<int>(hashmapPtr + 0x0c);
		IntPtr data = process.ReadPointer(hashmapPtr + 0x10);
	   
		if (data == IntPtr.Zero)
			return IntPtr.Zero;
		
		// Compute hash: (key + 1) & 0x7fffffff
		uint hash = (uint)((key + 1) & 0x7fffffff);
		
		// Initial bucket index
		uint bucketIndex = hash & (uint)mask;
		int psl = 0; // Probe sequence length
		   
		// HashMapBucket is 0x10 bytes:
		// +0x00: void* value (8 bytes)
		// +0x08: int32_t key (4 bytes)
		// +0x0c: uint32_t hash (4 bytes)
		
		int maxProbes = capacity; // Safety limit
		for (int i = 0; i < maxProbes; i++) {
			IntPtr bucketPtr = data + ((int)bucketIndex * 0x10);
			
			long value = process.ReadValue<long>(bucketPtr + 0x00);
			int bucketKey = process.ReadValue<int>(bucketPtr + 0x08);
			uint bucketHash = process.ReadValue<uint>(bucketPtr + 0x0c);
				
			// If hash matches, we found it
			if (bucketHash == hash)
				return (IntPtr)value;
			
			// Empty bucket (hash == 0) means not found
			if (bucketHash == 0)
				return IntPtr.Zero;
			
			// Robin Hood hashing: check PSL
			// PSL = (capacity - (mask & bucketHash)) + bucketIndex & mask
			int bucketPSL = ((capacity - (int)(mask & bucketHash)) + (int)bucketIndex) & mask;
			
			// If our PSL is greater than the bucket's PSL, the key doesn't exist
			// (Robin Hood invariant: entries are sorted by PSL)
			if (psl > bucketPSL)
				return IntPtr.Zero;
			
			// Move to next bucket
			psl++;
			bucketIndex = ((bucketIndex + 1) & (uint)mask);
		}
		
		// max probes exceeded; not found
		return IntPtr.Zero;
	};
	vars.HashmapLookup = HashmapLookup;

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
	
	settings.Add("split_once_per_spring", true, "Split Once per Goal Spring.");
	settings.SetToolTip("split_once_per_spring", "If on, split only the first time a spring is hit. If off, split every time a goal spring is hit");
	
	settings.Add("split_pinwheel", false, "Only Split On Pinwheels.", "split_once_per_spring");
	settings.SetToolTip("split_pinwheel", "If on, only count a goal spring as complete if you got the pinwheel.");
	
	vars.clearedExits = new bool[200];
	vars.firstUpdate = true;
	
	vars.currentStageClearArrayPtr = IntPtr.Zero;
}

init {
	var module = modules.Single(x => String.Equals(x.ModuleName, "Windswept.exe", StringComparison.OrdinalIgnoreCase));
	var moduleSize = module.ModuleMemorySize;
	vars.DebugOutput("Module Size: " + moduleSize + " " + module.ModuleName);
	var hash = vars.CalcModuleHash(module);
	
	if (moduleSize == 31907840 && hash == "D288C9A5FFD5C01F125AD0695CDD6649")
	{
		version = "1.0.7 (Steam)";
		return;
	}
	
	if (moduleSize == 31944704 && hash == "B96CCEF3B9DA79580B06A455400F2B49")
	{
		version = "1.0.8.1 (Steam)";
		return;
	}

	if (moduleSize == 31993856 && hash == "1BA68D3A6C05582FB327362D8B251BE3")
	{
		version = "1.0.8 (GOG)";
		return;
	}
	
	if (moduleSize == 31985664 && hash == "38D299CEC8B8BF3B7E828D76267A1078")
	{
		version = "1.0.9 (Steam)";
		return;
	}
	
	if (moduleSize == 31985664 && hash == "9A440B441E75C3082047D5E126F251BD")
	{
		version = "1.0.9.1 (Steam)";
		return;
	}
	
	if (moduleSize == 31993856 && hash == "A0A9013416485F54959D2BF6C406B6D8")
	{
		version = "1.1.0 (Steam)";
		return;
	}
	
	if (moduleSize == 31993856 && hash == "C5E1EB36AA48FDE22AE9A6783C77EA54")
	{
		version = "1.1.01 (Steam)";
		return;
	}
	
	if (moduleSize == 32006144 && hash == "564C13E0FC184AB0E4C5D57A3915E324")
	{
		version = "1.1.01 Hotfix (Steam)";
		return;
	}
	
	version = "Unrecognised!";
}

update {
	if (version == "" || version == "Unrecognised!")
		return false;
	
	current.phase = timer.CurrentPhase;
	if (vars.firstUpdate)
	{
		vars.firstUpdate = false;
		return true;
	}
	
	if (current.phase == TimerPhase.Running && old.phase == TimerPhase.NotRunning) {
		vars.DebugOutput("Resetting splits");
		vars.clearedExits = new bool[200];
	}
	
	IntPtr stageTypePtr = vars.HashmapLookup(memory, new IntPtr(current.globalDataHashMap), current.stageTypeIndex);
	current.stageType = memory.ReadValue<double>(stageTypePtr);
	
	IntPtr frameCountRoomPtr = vars.HashmapLookup(memory, new IntPtr(current.globalDataHashMap), current.frameCountRoomIndex);
	current.roomFrameCount = memory.ReadValue<double>(frameCountRoomPtr);
		
	IntPtr timerStopPtr = vars.HashmapLookup(memory, new IntPtr(current.globalDataHashMap), current.timerStopIndex);
	current.timerStop = memory.ReadValue<double>(timerStopPtr);
	
	return true;
}

gameTime {
	IntPtr timerFullPtr = vars.HashmapLookup(memory, new IntPtr(current.globalDataHashMap), current.timerFullIndex);
	current.gameTime = memory.ReadValue<double>(timerFullPtr);
	
	return TimeSpan.FromMilliseconds(current.gameTime);
}

exit {
	timer.IsGameTimePaused = true;
}

start {
	if (! settings.StartEnabled)
		return false;
		
	// 204 is the Home level used for the opening cutscene.
	return current.room == 204;	
}

reset {
	if (! settings.ResetEnabled)
		return false;
		
	// 0 == title screen, 1 == file select.
	return current.room == 0 || current.room == 1;
}

split {
	if (! settings.SplitEnabled)
		return false;
	
	if (settings["split_once_per_spring"])
	{
		vars.currentStageClearArrayPtr = vars.HashmapLookup(memory, new IntPtr(current.globalDataHashMap), current.arrayStageClearIndex);
		
		if (vars.currentStageClearArrayPtr == IntPtr.Zero)
			return false;
			
		// Read the stage complete array:
		// - The value we read off of GlobalData is a pointer to an ArrayMetadata structure:
		//
		// +0x0 parent pointer
		// +0x8 array data
		// +0x18 array refcount (expect 1)
		// +0x24 array length (expect 200)
		IntPtr actualArray = memory.ReadPointer((IntPtr)vars.currentStageClearArrayPtr);
		
		IntPtr arrayData = memory.ReadPointer(actualArray + 0x8);
		int numElements = memory.ReadValue<int>(actualArray + 0x24);
		
		// Read the bytes in the array. It's an array of RValues, so each element is 16 bytes long,
		// and the first 8 bytes are the value we're looking for.
		//
		// If any value has become > 0 and we haven't previously seen it be > 0 we should split.
		//
		// We split if *any* value has become > 0 but we remember *every* value that became > 0 so that if multiple
		// exits are completed at the same time we only split once. This happens with Home and with some other stages
		// that have two exits coming off of them.
		bool anyCompletions = false;
		byte[] stageClearArray = memory.ReadBytes(arrayData, numElements * 16);
		for (int i = 0; i < numElements; ++i) {		
			double value = BitConverter.ToDouble(stageClearArray, i * 16);
			double threshold = 1;
			if (settings["split_pinwheel"])
				threshold = 2;
				
			if (i / 2 == 60) { // Home
				threshold = 1;
						
				if (current.stageType > 3)
					continue;
			}
			
			if (! vars.clearedExits[i] && value >= threshold) {
				vars.DebugOutput("Completed stage " + (i/2) + " exit " + (i%2) + " element " + i + " with value " + value);
				vars.clearedExits[i] = true;
				anyCompletions = true;
			}
		}

		return anyCompletions;
	}
	else
	{
		// timerStop is set to 2 between landing on a goal and walking off the screen,
		// and also during the opening cutscene.
		//
		// If room is 204 we're in the opening cutscene and don't want to split. Otherwise,
		// we split when the value is set to 2.
		if (current.room == 204)
			return false;
		
		if (current.timerStop == 2 && old.timerStop == 0)
			return true;

		return false;
	}

	return false;
}

isLoading {
	// The timer is disabled if:
	// - The "stage type" is <= 3 (== overworld) OR
	// - We're in the first 30 frames of a level OR
	// - timerStop is > 0
	
	if (current.stageType <= 3)
		return true;
	
	if (current.roomFrameCount < 30)
		return true;
	
	if (current.timerStop > 0)
		return true;
	
	return false;
}