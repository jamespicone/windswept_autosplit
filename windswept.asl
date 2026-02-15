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

state("Windswept", "1.1.01 Hotfix 2 (Steam)") {
	int room: "Windswept.exe", 0x1d39c78 ;
	
	// GlobalData's hashmap.
	long globalDataHashMap: "Windswept.exe", 0x1a1d450, 0x48;

	// Variable indices
	long arrayStageClearIndex: "Windswept.exe", 0x19b63f8 ; // array_StageClears
	long timerFullIndex: "Windswept.exe", 0x19b6a28 ; // timer_Full
	long timerStopIndex: "Windswept.exe", 0x19b6708 ; // timer_Stop
	long stageTypeIndex: "Windswept.exe", 0x19b3d38 ; // stageType
	long frameCountRoomIndex: "Windswept.exe", 0x19b6548 ; // frameCount_Room
	long arrayCometCoinIndex: "Windswept.exe", 0x19b6378 ; // array_CometCoins
	long arrayCometShardIndex: "Windswept.exe", 0x19b6918 ; // array_CometShards
	long arrayMoonCoinsIndex: "Windswept.exe", 0x19b7918 ; // array_MoonCoins
	long arrayCloudCoinsIndex: "Windswept.exe", 0x19b7658 ; // array_CloudCoins
}

state("Windswept", "1.1.01 (GOG)") {
	int room: "Windswept.exe", 0x1d42aa8 ;
	
	// GlobalData's hashmap.
	long globalDataHashMap: "Windswept.exe", 0x1a26280 , 0x48;
	
	// Variable indices
	long arrayStageClearIndex: "Windswept.exe", 0x19bf3e8; // array_StageClears
	long timerFullIndex: "Windswept.exe", 0x19bf9f8 ; // timer_Full
	long timerStopIndex: "Windswept.exe", 0x19bf6f8 ; // timer_Stop
	long stageTypeIndex: "Windswept.exe", 0x19bcd38 ; // stageType
	long frameCountRoomIndex: "Windswept.exe", 0x19bf528 ; // frameCount_Room
	long arrayCometCoinIndex: "Windswept.exe", 0x19bf338 ; // array_CometCoins
	long arrayCometShardIndex: "Windswept.exe", 0x19bf8f8 ; // array_CometShards
	long arrayMoonCoinsIndex: "Windswept.exe", 0x19c08d8 ; // array_MoonCoins
	long arrayCloudCoinsIndex: "Windswept.exe", 0x19c0648 ; // array_CloudCoins
}

state("Windswept", "1.1.01 Hotfix (Steam)") {
	int room: "Windswept.exe", 0x1d39c78 ;
	
	// GlobalData's hashmap.
	long globalDataHashMap: "Windswept.exe", 0x1a1d450, 0x48;

	// Variable indices
	long arrayStageClearIndex: "Windswept.exe", 0x19b63f8; // array_StageClears
	long timerFullIndex: "Windswept.exe", 0x19b6a38 ; // timer_Full
	long timerStopIndex: "Windswept.exe", 0x19b66f8 ; // timer_Stop
	long stageTypeIndex: "Windswept.exe", 0x19b3d58 ; // stageType
	long frameCountRoomIndex: "Windswept.exe", 0x19b6548 ; // frameCount_Room
	long arrayCometCoinIndex: "Windswept.exe", 0x19b6358 ; // array_CometCoins
	long arrayCometShardIndex: "Windswept.exe", 0x19b6938 ; // array_CometShards
	long arrayMoonCoinsIndex: "Windswept.exe", 0x19b7908 ; // array_MoonCoins
	long arrayCloudCoinsIndex: "Windswept.exe", 0x19b7648 ; // array_CloudCoins
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
	long arrayCometCoinIndex: "Windswept.exe", 0x19b1298;
	long arrayCometShardIndex: "Windswept.exe", 0x19b1858;
	long arrayMoonCoinsIndex: "Windswept.exe", 0x19b2858;
	long arrayCloudCoinsIndex: "Windswept.exe", 0x19b25b8;
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

	// Read a value from a simple (1D) GameMaker array at a given stage index.
	// Returns the double value, or -1 on failure.
	Func<Process, IntPtr, long, int, double> ReadSimpleArrayValue = (proc, hashmapPtr, arrayIndexVar, stageIndex) => {
		IntPtr ptr = vars.HashmapLookup(proc, hashmapPtr, arrayIndexVar);
		if (ptr == IntPtr.Zero)
			return -1;

		IntPtr metadata = proc.ReadPointer(ptr);
		IntPtr data = proc.ReadPointer(metadata + 0x8);
		int length = proc.ReadValue<int>(metadata + 0x24);

		if (stageIndex >= length || stageIndex < 0)
			return -1;

		return proc.ReadValue<double>(data + (stageIndex * 16));
	};
	vars.ReadSimpleArrayValue = ReadSimpleArrayValue;

	// Check if items in a nested (2D) GameMaker array at a given stage index have value >= 1.
	// Used for comet shards and moon coins, where the outer array is indexed by stage and
	// each inner array contains the per-item collected status.
	// expectedCount: if > 0, only check this many elements (inner arrays may be padded beyond
	// the actual item count, e.g. moon coins always have 5 slots regardless of stage).
	// If <= 0, check all elements in the inner array.
	Func<Process, IntPtr, long, int, int, bool> CheckNestedArrayAllCollected = (proc, hashmapPtr, arrayIndexVar, stageIndex, expectedCount) => {
		IntPtr ptr = vars.HashmapLookup(proc, hashmapPtr, arrayIndexVar);
		if (ptr == IntPtr.Zero)
			return false;

		IntPtr outerMeta = proc.ReadPointer(ptr);
		IntPtr outerData = proc.ReadPointer(outerMeta + 0x8);
		int outerLen = proc.ReadValue<int>(outerMeta + 0x24);

		if (stageIndex >= outerLen || stageIndex < 0)
			return false;

		// Read the outer RValue for this stage; type must be 2 (array)
		IntPtr stageRValueAddr = outerData + (stageIndex * 16);
		int rvalueType = proc.ReadValue<int>(stageRValueAddr + 0x0C);
		if (rvalueType != 2)
			return false;

		// Dereference to inner ArrayMetadata
		IntPtr innerMetaPtr = proc.ReadPointer(stageRValueAddr);
		IntPtr innerData = proc.ReadPointer(innerMetaPtr + 0x8);
		int innerLen = proc.ReadValue<int>(innerMetaPtr + 0x24);

		if (innerLen <= 0)
			return false;

		int checkCount = (expectedCount > 0) ? expectedCount : innerLen;
		if (checkCount > innerLen)
			checkCount = innerLen;

		byte[] innerBytes = proc.ReadBytes(innerData, checkCount * 16);
		for (int j = 0; j < checkCount; j++) {
			double val = BitConverter.ToDouble(innerBytes, j * 16);
			if (val < 1)
				return false;
		}

		return true;
	};
	vars.CheckNestedArrayAllCollected = CheckNestedArrayAllCollected;

	settings.Add("split_on_hitting_spring", false, "Split when hitting a Goal Spring.");
	settings.SetToolTip("split_on_hitting_spring", "If on, will split when landing on a goal spring, regardless of whether it's completing a level or not. You probably don't want the other split types on with this.");
	
	settings.Add("split_on_finish_level", true, "Split when you complete a new level.");
	settings.SetToolTip("split_on_finish_level", "This will split when you complete a level exit for the first time; the difference between this and 'Split when hitting a Goal Spring' is that it won't split if you go back in and complete the level from the same exit.");
		
	settings.Add("split_pinwheel", false, "Only Split On Pinwheels.", "split_on_finish_level");
	settings.SetToolTip("split_pinwheel", "If on, only count split on an exit if you got the pinwheel.");
	
	settings.Add("split_akc", false, "Only Split on All Key Collectables.", "split_pinwheel");
	settings.SetToolTip("split_akc", "If on, only split on a level if you got all key collectables and all exits.");
	
	
	// Idea borrowed from the undertale autosplitter to store complex data when we can't define
	// structs. The object[] array is a replacement for a struct; specific values are stored at specific
	// indices, and these levelindex variables indicate what index == what data.
	vars.levelindex_name = 0; // string
	vars.levelindex_number_exits = 1; // int
	vars.levelindex_has_comet = 2; // bool
	vars.levelindex_has_cloud = 3; // bool
	vars.levelindex_num_moons = 4; // int
	
	vars.level_data = new Dictionary<int, object[]>() {
		{ 0, new object[] { "Guiding Glade", 2, true, true, 3 } },
		{ 1, new object[] { "Hoppet Heights", 1, true, true, 3 } },
		{ 2, new object[] { "Bridge-Wheel Waterway", 1, true, true, 3 } },
		{ 3, new object[] { "Bluppo's Barge", 1, true, true, 2 } },
		{ 4, new object[] { "Salamancer's Sanctum", 1, true, true, 3 } },
		{ 5, new object[] { "Hue's Shade", 1, true, true, 2 } },
		{ 6, new object[] { "Brambles in the Breeze", 1, true, true, 2 } },
		{ 7, new object[] { "Octulent's Onslaught", 1, false, true, 0 } },
		{ 8, new object[] { "Thornado", 1, true, true, 1 } },
		{ 9, new object[] { "Cawbie Cliffs", 1, true, true, 2 } },
		{ 10, new object[] { "Nippa's Nook", 1, true, true, 2 } },
		{ 11, new object[] { "Pips and Pits", 1, true, true, 2 } },
		{ 12, new object[] { "Honey Hop Hollow", 2, true, true, 2 } },
		{ 13, new object[] { "Over the Raybow", 1, true, true, 3 } },
		{ 14, new object[] { "Grabba's Grotto", 1, true, true, 3 } },
		{ 15, new object[] { "Skree's Spire", 1, true, true, 3 } },
		{ 16, new object[] { "Beevy Battlefield", 1, true, true, 2 } },
		{ 17, new object[] { "The Pip Ship", 1, false, true, 0 } },
		{ 18, new object[] { "Calamitous Chasm", 1, true, true, 1 } },
		{ 19, new object[] { "Nugget's Snowy Sprint", 1, true, true, 2 } },
		{ 20, new object[] { "Temporal Railroad", 1, true, true, 1 } },
		{ 21, new object[] { "Aucora's Abyss", 1, true, true, 3 } },
		{ 22, new object[] { "Slicko Slide", 2, true, true, 3 } },
		{ 23, new object[] { "End of the Raybow", 1, true, true, 2 } },
		{ 24, new object[] { "Lunosa's Library", 1, true, true, 5 } },
		{ 25, new object[] { "Dizzying Descent", 1, true, true, 1 } },
		{ 26, new object[] { "Spicy Ice Speedway", 1, true, true, 2 } },
		{ 27, new object[] { "Magmaw Well", 1, true, true, 3 } },
		{ 28, new object[] { "Lava Pike Polder", 1, true, true, 2 } },
		{ 29, new object[] { "Honey Buzz Boiler", 1, true, true, 2 } },
		{ 30, new object[] { "Vexatious Vents", 2, true, true, 2 } },
		{ 31, new object[] { "Rusty Reservoir", 1, true, true, 2 } },
		{ 32, new object[] { "Smoky Squall", 1, true, true, 2 } },
		{ 33, new object[] { "B.V. Broadcast Tower", 1, false, true, 0 } },
		{ 34, new object[] { "Sawmill Thrill", 1, true, true, 1 } },
		{ 35, new object[] { "Bell's End", 1, true, true, 3 } },
		{ 36, new object[] { "Thrillhex Thicket", 2, true, true, 2 } },
		{ 37, new object[] { "Shrine of the Salamancer", 1, true, true, 2 } },
		{ 38, new object[] { "Prickly Peril", 1, true, true, 2 } },
		{ 39, new object[] { "Toxic Tunnel", 1, true, true, 2 } },
		{ 40, new object[] { "Cirra's Strife", 1, false, true, 0 } },
		{ 41, new object[] { "Baneful Briar", 1, true, true, 1 } },
		{ 42, new object[] { "Cirra Superstorm", 1, false, true, 0 } },
		{ 43, new object[] { "Cloudy Clamber", 1, true, true, 1 } },
		{ 44, new object[] { "Wingbeat Wharf", 1, true, true, 1 } },
		{ 45, new object[] { "Turbulent Torrent", 1, true, true, 1 } },
		{ 46, new object[] { "Shiver-Sling Spring", 1, true, true, 1 } },
		{ 47, new object[] { "Ashen Dash", 1, true, true, 1 } },
		{ 48, new object[] { "Sunset Scuttle", 1, true, true, 1 } },
		{ 49, new object[] { "Skyward Horde", 1, true, true, 1 } },
		{ 50, new object[] { "Pip Pop to the Top", 1, true, true, 1 } },
		{ 51, new object[] { "Frigid Flurry", 1, true, true, 1 } },
		{ 52, new object[] { "Grabba's Gauntlet", 1, true, true, 1 } },
		{ 53, new object[] { "Honey-Side Up", 1, true, true, 1 } },
		{ 54, new object[] { "Dire Dire Ducts", 1, true, true, 1 } },
		{ 55, new object[] { "Dropdash Chaparral", 1, true, true, 1 } },
		{ 56, new object[] { "Dreadmaw's Dwelling", 1, true, true, 1 } },
		{ 57, new object[] { "Cyclonic Skyway", 1, true, true, 1 } },
		{ 58, new object[] { "Windswept", 1, true, true, 0 } },
		{ 59, new object[] { "Windswept EX", 1, true, true, 0 } },
		{ 60, new object[] { "Home", 1, false, false, 1 } }
	};
	
	foreach (var level in vars.level_data.Keys) {
		var key = "split_level_" + level;
		var text = "Split for " + vars.level_data[level][vars.levelindex_name];

		settings.Add(key, true, text, "split_on_finish_level");

		if (vars.level_data[level][vars.levelindex_number_exits] > 1) {
			key += "_alt";
			text += " (alternate exit)";
			settings.Add(key, true, text, "split_on_finish_level");
		}
	}

	// Collectable split settings — organised per-level, then per-collectable-type.
	settings.Add("split_on_collectables", false, "Split on collecting individual collectables.");
	settings.SetToolTip("split_on_collectables", "Split when picking up comet coins, comet shards, moon coins, or cloud coins individually. Requires game version 1.0.9.1+.");

	vars.shardLetters = new string[] { "C", "O", "M", "E", "T" };

	foreach (var level in vars.level_data.Keys) {
		var data = vars.level_data[level];
		bool hasComet = (bool)data[vars.levelindex_has_comet];
		bool hasCloud = (bool)data[vars.levelindex_has_cloud];
		int numMoons = (int)data[vars.levelindex_num_moons];

		if (!hasComet && !hasCloud && numMoons <= 0) continue;

		var levelKey = "split_collectables_level_" + level;
		settings.Add(levelKey, false, (string)data[vars.levelindex_name], "split_on_collectables");

		// Comet shards (C, O, M, E, T)
		if (hasComet) {
			var shardLevelKey = "split_comet_shards_" + level;
			settings.Add(shardLevelKey, false, "Comet Shards", levelKey);
			foreach (var letter in vars.shardLetters) {
				settings.Add("split_comet_shard_" + letter + "_" + level, false,
					letter, shardLevelKey);
			}
		}

		// Comet coin
		if (hasComet) {
			settings.Add("split_comet_coin_" + level, false, "Comet Coin", levelKey);
		}

		// Cloud coin
		if (hasCloud) {
			settings.Add("split_cloud_coin_" + level, false, "Cloud Coin", levelKey);
		}

		// Moon coins
		if (numMoons > 0) {
			settings.Add("split_moons_" + level, false, "Moon Coins", levelKey);
			for (int mi = 0; mi < numMoons; mi++) {
				settings.Add("split_moon_" + level + "_" + mi, false,
					"Moon " + (mi + 1), "split_moons_" + level);
			}
		}
	}

	vars.clearedExits = new bool[200];
	vars.clearedStagesAKC = new bool[100];
	vars.seenCometCoins = new bool[100];
	vars.seenCometShards = new bool[500]; // stage * 5 + shardIndex
	vars.seenMoonCoins = new bool[500];   // stage * 5 + moonIndex
	vars.seenCloudCoins = new bool[100];
	vars.firstUpdate = true;
	vars.akcSupported = false;

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
		vars.akcSupported = true;
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
		vars.akcSupported = true;
		return;
	}
	
	if (moduleSize == 32047104 && hash == "FDDD0EC04F07986361FE370E5C028B9A")
	{
		version = "1.1.01 (GOG)";
		vars.akcSupported = true;
		return;
	}

	if (moduleSize == 32006144 && hash == "1AFB64D60DECF8F5AA57F0BF3CE82F0B")
	{
		version = "1.1.01 Hotfix 2 (Steam)";
		vars.akcSupported = true;
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
		vars.clearedStagesAKC = new bool[100];
		vars.seenCometCoins = new bool[100];
		vars.seenCometShards = new bool[500];
		vars.seenMoonCoins = new bool[500];
		vars.seenCloudCoins = new bool[100];

		// Snapshot current collectable state so we don't false-split on already-collected items
		if (vars.akcSupported && settings["split_on_collectables"]) {
			IntPtr hm = new IntPtr(current.globalDataHashMap);

			foreach (var level in vars.level_data.Keys) {
				var data = vars.level_data[level];
				bool hasComet = (bool)data[vars.levelindex_has_comet];
				bool hasCloud = (bool)data[vars.levelindex_has_cloud];
				int numMoons = (int)data[vars.levelindex_num_moons];

				if (hasComet) {
					// Snapshot comet coin
					if (vars.ReadSimpleArrayValue(memory, hm, current.arrayCometCoinIndex, level) >= 1)
						vars.seenCometCoins[level] = true;

					// Snapshot comet shards
					IntPtr shardPtr = vars.HashmapLookup(memory, hm, current.arrayCometShardIndex);
					if (shardPtr != IntPtr.Zero) {
						IntPtr outerMeta = memory.ReadPointer(shardPtr);
						IntPtr outerData = memory.ReadPointer(outerMeta + 0x8);
						int outerLen = memory.ReadValue<int>(outerMeta + 0x24);
						if (level < outerLen) {
							IntPtr stageRValue = outerData + (level * 16);
							int rtype = memory.ReadValue<int>(stageRValue + 0x0C);
							if (rtype == 2) {
								IntPtr innerMeta = memory.ReadPointer(stageRValue);
								IntPtr innerData = memory.ReadPointer(innerMeta + 0x8);
								int innerLen = memory.ReadValue<int>(innerMeta + 0x24);
								int checkCount = 5 < innerLen ? 5 : innerLen;
								byte[] innerBytes = memory.ReadBytes(innerData, checkCount * 16);
								for (int si = 0; si < checkCount; si++) {
									if (BitConverter.ToDouble(innerBytes, si * 16) >= 1)
										vars.seenCometShards[level * 5 + si] = true;
								}
							}
						}
					}
				}

				if (numMoons > 0) {
					// Snapshot moon coins
					IntPtr moonPtr = vars.HashmapLookup(memory, hm, current.arrayMoonCoinsIndex);
					if (moonPtr != IntPtr.Zero) {
						IntPtr outerMeta = memory.ReadPointer(moonPtr);
						IntPtr outerData = memory.ReadPointer(outerMeta + 0x8);
						int outerLen = memory.ReadValue<int>(outerMeta + 0x24);
						if (level < outerLen) {
							IntPtr stageRValue = outerData + (level * 16);
							int rtype = memory.ReadValue<int>(stageRValue + 0x0C);
							if (rtype == 2) {
								IntPtr innerMeta = memory.ReadPointer(stageRValue);
								IntPtr innerData = memory.ReadPointer(innerMeta + 0x8);
								int innerLen = memory.ReadValue<int>(innerMeta + 0x24);
								int checkCount = numMoons < innerLen ? numMoons : innerLen;
								byte[] innerBytes = memory.ReadBytes(innerData, checkCount * 16);
								for (int mi = 0; mi < checkCount; mi++) {
									if (BitConverter.ToDouble(innerBytes, mi * 16) >= 1)
										vars.seenMoonCoins[level * 5 + mi] = true;
								}
							}
						}
					}
				}

				if (hasCloud) {
					// Snapshot cloud coin
					if (vars.ReadSimpleArrayValue(memory, hm, current.arrayCloudCoinsIndex, level) >= 1)
						vars.seenCloudCoins[level] = true;
				}
			}
		}
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

	bool shouldSplit = false;

	// Mode 1: Split on any goal spring hit, regardless of whether it's a new completion.
	if (settings["split_on_hitting_spring"])
	{
		// timerStop is set to 2 between landing on a goal and walking off the screen,
		// and also during the opening cutscene.
		//
		// If room is 204 we're in the opening cutscene and don't want to split. Otherwise,
		// we split when the value is set to 2.
		if (current.room != 204 && current.timerStop == 2 && old.timerStop == 0)
			shouldSplit = true;
	}

	// Mode 2: Split on collecting individual collectables (comet coins, shards, moon coins).
	if (settings["split_on_collectables"] && vars.akcSupported)
	{
		IntPtr hm = new IntPtr(current.globalDataHashMap);

		// Comet coins
		IntPtr cometCoinPtr = vars.HashmapLookup(memory, hm, current.arrayCometCoinIndex);
		if (cometCoinPtr != IntPtr.Zero) {
			IntPtr ccMeta = memory.ReadPointer(cometCoinPtr);
			IntPtr ccData = memory.ReadPointer(ccMeta + 0x8);
			int ccLen = memory.ReadValue<int>(ccMeta + 0x24);
			int readLen = ccLen < 100 ? ccLen : 100;
			byte[] ccBytes = memory.ReadBytes(ccData, readLen * 16);

			foreach (var level in vars.level_data.Keys) {
				if (level >= readLen) continue;
				if (!((bool)vars.level_data[level][vars.levelindex_has_comet])) continue;
				if (vars.seenCometCoins[level]) continue;
				if (!settings["split_comet_coin_" + level]) continue;

				double val = BitConverter.ToDouble(ccBytes, level * 16);
				if (val >= 1) {
					vars.seenCometCoins[level] = true;
					vars.DebugOutput("Collected comet coin in stage " + level + " (" + vars.level_data[level][vars.levelindex_name] + ")");
					shouldSplit = true;
				}
			}
		}

		// Cloud coins
		IntPtr cloudCoinPtr = vars.HashmapLookup(memory, hm, current.arrayCloudCoinsIndex);
		if (cloudCoinPtr != IntPtr.Zero) {
			IntPtr clMeta = memory.ReadPointer(cloudCoinPtr);
			IntPtr clData = memory.ReadPointer(clMeta + 0x8);
			int clLen = memory.ReadValue<int>(clMeta + 0x24);
			int readLen = clLen < 100 ? clLen : 100;
			byte[] clBytes = memory.ReadBytes(clData, readLen * 16);

			foreach (var level in vars.level_data.Keys) {
				if (level >= readLen) continue;
				if (!((bool)vars.level_data[level][vars.levelindex_has_cloud])) continue;
				if (vars.seenCloudCoins[level]) continue;
				if (!settings["split_cloud_coin_" + level]) continue;

				double val = BitConverter.ToDouble(clBytes, level * 16);
				if (val >= 1) {
					vars.seenCloudCoins[level] = true;
					vars.DebugOutput("Collected cloud coin in stage " + level + " (" + vars.level_data[level][vars.levelindex_name] + ")");
					shouldSplit = true;
				}
			}
		}

		// Comet shards
		IntPtr shardPtr = vars.HashmapLookup(memory, hm, current.arrayCometShardIndex);
		if (shardPtr != IntPtr.Zero) {
			IntPtr outerMeta = memory.ReadPointer(shardPtr);
			IntPtr outerData = memory.ReadPointer(outerMeta + 0x8);
			int outerLen = memory.ReadValue<int>(outerMeta + 0x24);

			foreach (var level in vars.level_data.Keys) {
				if (level >= outerLen) continue;
				if (!((bool)vars.level_data[level][vars.levelindex_has_comet])) continue;

				// Check if all shards for this stage are already seen
				bool allSeen = true;
				for (int si = 0; si < 5; si++) {
					if (!vars.seenCometShards[level * 5 + si]) { allSeen = false; break; }
				}
				if (allSeen) continue;

				// Dereference inner array for this stage
				IntPtr stageRValue = outerData + (level * 16);
				int rtype = memory.ReadValue<int>(stageRValue + 0x0C);
				if (rtype != 2) continue;

				IntPtr innerMeta = memory.ReadPointer(stageRValue);
				IntPtr innerData = memory.ReadPointer(innerMeta + 0x8);
				int innerLen = memory.ReadValue<int>(innerMeta + 0x24);
				int checkCount = 5 < innerLen ? 5 : innerLen;
				byte[] innerBytes = memory.ReadBytes(innerData, checkCount * 16);

				for (int si = 0; si < checkCount; si++) {
					if (vars.seenCometShards[level * 5 + si]) continue;
					if (!settings["split_comet_shard_" + vars.shardLetters[si] + "_" + level]) continue;

					double val = BitConverter.ToDouble(innerBytes, si * 16);
					if (val >= 1) {
						vars.seenCometShards[level * 5 + si] = true;
						vars.DebugOutput("Collected comet shard " + vars.shardLetters[si] + " in stage " + level + " (" + vars.level_data[level][vars.levelindex_name] + ")");
						shouldSplit = true;
					}
				}
			}
		}

		// Moon coins
		IntPtr moonPtr = vars.HashmapLookup(memory, hm, current.arrayMoonCoinsIndex);
		if (moonPtr != IntPtr.Zero) {
			IntPtr outerMeta = memory.ReadPointer(moonPtr);
			IntPtr outerData = memory.ReadPointer(outerMeta + 0x8);
			int outerLen = memory.ReadValue<int>(outerMeta + 0x24);

			foreach (var level in vars.level_data.Keys) {
				if (level >= outerLen) continue;
				int numMoons = (int)vars.level_data[level][vars.levelindex_num_moons];
				if (numMoons <= 0) continue;
				if (!settings["split_moons_" + level]) continue;

				// Check if all moons for this stage are already seen
				bool allSeen = true;
				for (int mi = 0; mi < numMoons; mi++) {
					if (!vars.seenMoonCoins[level * 5 + mi]) { allSeen = false; break; }
				}
				if (allSeen) continue;

				// Dereference inner array for this stage
				IntPtr stageRValue = outerData + (level * 16);
				int rtype = memory.ReadValue<int>(stageRValue + 0x0C);
				if (rtype != 2) continue;

				IntPtr innerMeta = memory.ReadPointer(stageRValue);
				IntPtr innerData = memory.ReadPointer(innerMeta + 0x8);
				int innerLen = memory.ReadValue<int>(innerMeta + 0x24);
				int checkCount = numMoons < innerLen ? numMoons : innerLen;
				byte[] innerBytes = memory.ReadBytes(innerData, checkCount * 16);

				for (int mi = 0; mi < checkCount; mi++) {
					if (vars.seenMoonCoins[level * 5 + mi]) continue;
					if (!settings["split_moon_" + level + "_" + mi]) continue;

					double val = BitConverter.ToDouble(innerBytes, mi * 16);
					if (val >= 1) {
						vars.seenMoonCoins[level * 5 + mi] = true;
						vars.DebugOutput("Collected moon " + mi + " in stage " + level + " (" + vars.level_data[level][vars.levelindex_name] + ")");
						shouldSplit = true;
					}
				}
			}
		}
	}

	// Mode 3: Split when completing a level exit for the first time, with per-level filtering.
	if (settings["split_on_finish_level"])
	{
		vars.currentStageClearArrayPtr = vars.HashmapLookup(memory, new IntPtr(current.globalDataHashMap), current.arrayStageClearIndex);

		if (vars.currentStageClearArrayPtr != IntPtr.Zero)
		{
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
			byte[] stageClearArray = memory.ReadBytes(arrayData, numElements * 16);
			for (int i = 0; i < numElements; ++i) {
				int stage = i / 2;
				int exit = i % 2;

				// Skip stages we don't have data for
				if (! vars.level_data.ContainsKey(stage))
					continue;

				// Check per-level setting
				string levelKey = "split_level_" + stage;
				if (exit == 1) {
					if ((int)vars.level_data[stage][vars.levelindex_number_exits] > 1)
						levelKey += "_alt";
					else
						continue; // Single-exit stage; skip exit 1
				}

				if (! settings[levelKey])
					continue;

				double value = BitConverter.ToDouble(stageClearArray, i * 16);
				double threshold = 1;
				if (settings["split_pinwheel"])
					threshold = 2;

				// Home (stage 60) always uses threshold 1 (no pinwheel), and only
				// triggers when we're not currently in a level (stageType <= 3).
				if (stage == 60) {
					threshold = 1;
					if (current.stageType > 3)
						continue;
				}

				if (! vars.clearedExits[i] && value >= threshold) {
					// AKC gate: if enabled, require all key collectables before splitting.
					// If conditions aren't met yet, skip without marking cleared so we recheck next tick.
					// With AKC we split once per stage (not per exit) to avoid double-splits on
					// multi-exit levels.
					if (settings["split_akc"] && vars.akcSupported && stage != 60) {
						if (vars.clearedStagesAKC[stage]) {
							vars.clearedExits[i] = true;
							continue;
						}

						var data = vars.level_data[stage];
						bool hasComet = (bool)data[vars.levelindex_has_comet];
						bool hasCloud = (bool)data[vars.levelindex_has_cloud];
						int numMoons = (int)data[vars.levelindex_num_moons];
						IntPtr hm = new IntPtr(current.globalDataHashMap);

						// Comet coin + all comet shards
						if (hasComet) {
							if (vars.ReadSimpleArrayValue(memory, hm, current.arrayCometCoinIndex, stage) < 1) continue;
							if (!vars.CheckNestedArrayAllCollected(memory, hm, current.arrayCometShardIndex, stage, 5)) continue;
						}

						// All moon coins
						if (numMoons > 0) {
							if (!vars.CheckNestedArrayAllCollected(memory, hm, current.arrayMoonCoinsIndex, stage, numMoons)) continue;
						}

						// Cloud coin
						if (hasCloud) {
							if (vars.ReadSimpleArrayValue(memory, hm, current.arrayCloudCoinsIndex, stage) < 1) continue;
						}

						vars.clearedStagesAKC[stage] = true;
					}

					vars.DebugOutput("Completed stage " + stage + " (" + vars.level_data[stage][vars.levelindex_name] + ") exit " + exit + " with value " + value);
					vars.clearedExits[i] = true;
					shouldSplit = true;
				}
			}
		}
	}

	return shouldSplit;
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