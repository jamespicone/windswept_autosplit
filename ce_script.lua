-- Windswept Collectable Array Editor
-- Generic tool for finding and editing global arrays via hashmap lookup
-- Now with support for nested arrays!

-- Configuration for different game versions
local versions = {
    ["1.0.9.1 (Steam)"] = {
        globalDataHashMap = 0x1A182F0,
        arrayStageClearIndex = 0x19B1338,
        arrayCometCoinIndex = 0x19b1298,
        arrayCometShardIndex = 0x19b1858,
        arrayMoonCoinsIndex = 0x19b2858,
        arrayCloudCoinsIndex = 0x19b25b8
    },
    ["1.0.9 (Steam)"] = {
        globalDataHashMap = 0x1A182F0,
        arrayStageClearIndex = 0x19B1338
    },
    ["1.0.8 (GOG)"] = {
        globalDataHashMap = 0x1A18F30,
        arrayStageClearIndex = 0x19B2AF8
    },
    ["1.0.8.1 (Steam)"] = {
        globalDataHashMap = 0x1A0E030,
        arrayStageClearIndex = 0x19A72C8
    },
    ["1.0.7 (Steam)"] = {
        globalDataHashMap = 0x1A05060,
        arrayStageClearIndex = 0x199E428
    }
}

-- RValue type constants
local RVALUE_TYPE_REAL = 0
local RVALUE_TYPE_STRING = 1
local RVALUE_TYPE_ARRAY = 2
local RVALUE_TYPE_OBJECT = 6

-- Array type configurations
local arrayTypes = {
    {
        name = "Stage Clear Array",
        indexKey = "arrayStageClearIndex",
        isNested = false,
        descriptionFormat = function(i)
            local stageNum = math.floor(i / 2)
            local exitNum = i % 2
            local desc = string.format("Stage %d Exit %d", stageNum, exitNum)
            if stageNum == 60 then
                desc = string.format("Stage %d (Home) Exit %d", stageNum, exitNum)
            end
            return desc
        end,
        valueType = vtDouble,
        tooltip = "0=not done, 1=complete, 2=complete with pinwheel"
    },
    {
        name = "Comet Coin Array",
        indexKey = "arrayCometCoinIndex",
        isNested = false,
        descriptionFormat = function(i)
            return string.format("Stage %d Comet Coin", i)
        end,
        valueType = vtDouble,
        tooltip = "0=not collected, 1=collected"
    },
    {
        name = "Comet Shard Array",
        indexKey = "arrayCometShardIndex",
        isNested = true,  -- This is a 2D array!
        descriptionFormat = function(levelIdx, shardIdx)
            if shardIdx == nil then
                return string.format("Stage %d Shards", levelIdx)
            else
                return string.format("  Shard %d", shardIdx)
            end
        end,
        valueType = vtDouble,
        tooltip = "0=not collected, 1=collected"
    },
    {
        name = "Moon Coins Array",
        indexKey = "arrayMoonCoinsIndex",
        isNested = true,  -- This is also 2D!
        descriptionFormat = function(levelIdx, coinIdx)
            if coinIdx == nil then
                return string.format("Stage %d Moon Coins", levelIdx)
            else
                return string.format("  Coin %d", coinIdx)
            end
        end,
        valueType = vtDouble,
        tooltip = "0=not collected, 1=collected"
    },
    {
        name = "Cloud Coins Array",
        indexKey = "arrayCloudCoinsIndex",
        isNested = false,
        descriptionFormat = function(i)
            return string.format("Stage %d Cloud Coin", i)
        end,
        valueType = vtDouble,
        tooltip = "0=not collected, 1=collected"
    }
}

-- Select version (change this to match your game version)
local selectedVersion = "1.0.9.1 (Steam)"
local config = versions[selectedVersion]

-- Robin Hood hashmap lookup function
function hashmapLookup(process, hashmapPtr, key)
    if hashmapPtr == 0 or hashmapPtr == nil then
        return nil
    end
    
    local capacity = readInteger(hashmapPtr + 0x00)
    local mask = readInteger(hashmapPtr + 0x08)
    local data = readPointer(hashmapPtr + 0x10)
    
    if data == 0 or data == nil then
        return nil
    end
    
    -- Compute hash: (key + 1) & 0x7fffffff
    local hash = bAnd((key + 1), 0x7fffffff)
    local bucketIndex = bAnd(hash, mask)
    local psl = 0
    
    for i = 0, capacity - 1 do
        local bucketPtr = data + (bucketIndex * 0x10)
        
        local value = readQword(bucketPtr + 0x00)
        local bucketHash = readInteger(bucketPtr + 0x0c)
        
        -- Found it
        if bucketHash == hash then
            return value
        end
        
        -- Empty bucket means not found
        if bucketHash == 0 then
            return nil
        end
        
        -- Robin Hood PSL check
        local bucketPSL = bAnd(((capacity - bAnd(mask, bucketHash)) + bucketIndex), mask)
        
        if psl > bucketPSL then
            return nil
        end
        
        psl = psl + 1
        bucketIndex = bAnd((bucketIndex + 1), mask)
    end
    
    return nil
end

-- Read array metadata and return data pointer and length
function readArrayMetadata(arrayMetadataPtr)
    if arrayMetadataPtr == 0 or arrayMetadataPtr == nil then
        return nil, nil
    end
    
    local arrayDataPtr = readPointer(arrayMetadataPtr + 0x8)
    local arrayLength = readInteger(arrayMetadataPtr + 0x24)
    
    return arrayDataPtr, arrayLength
end

-- Generic function to find any global array
function findGlobalArray(arrayIndexOffset)
    local process = getOpenedProcessID()
    if process == 0 then
        return nil, "No process opened!"
    end
    
    -- Get base address of Windswept.exe
    local baseAddress = getAddress("Windswept.exe")
    if baseAddress == nil then
        return nil, "Could not find Windswept.exe module!"
    end
    
    -- Read the hashmap pointer (with pointer dereference at +0x48)
    local globalDataPtr = readPointer(baseAddress + config.globalDataHashMap)
    if globalDataPtr == 0 or globalDataPtr == nil then
        return nil, "Could not read GlobalData pointer!"
    end
    
    local hashmapPtr = readPointer(globalDataPtr + 0x48)
    if hashmapPtr == 0 or hashmapPtr == nil then
        return nil, "Could not read hashmap pointer!"
    end
    
    -- Read the array index
    local arrayIndexValue = readQword(baseAddress + arrayIndexOffset)
    
    -- Look up the array in the hashmap
    local arrayMetadataPtr = hashmapLookup(process, hashmapPtr, arrayIndexValue)
    
    if arrayMetadataPtr == nil or arrayMetadataPtr == 0 then
        return nil, "Could not find array in hashmap!"
    end
    
    -- The RValue contains a pointer to ArrayMetadata at offset 0
    local actualArrayPtr = readPointer(arrayMetadataPtr)
    if actualArrayPtr == 0 or actualArrayPtr == nil then
        return nil, "Could not read array metadata pointer!"
    end
    
    -- Read array info from ArrayMetadata structure
    local arrayDataPtr, arrayLength = readArrayMetadata(actualArrayPtr)
    
    return arrayDataPtr, arrayLength
end

-- Generic function to add a simple (non-nested) array to the address list
function addSimpleArrayToList(arrayConfig, parentRecord, al)
    local arrayDataPtr, arrayLength = findGlobalArray(config[arrayConfig.indexKey])
    
    if arrayDataPtr == nil then
        print("Failed to find " .. arrayConfig.name .. ": " .. (arrayLength or "unknown error"))
        return false
    end
    
    print(string.format("%s found: %d elements at 0x%X", arrayConfig.name, arrayLength, arrayDataPtr))
    
    -- Add entries for each element
    for i = 0, arrayLength - 1 do
        -- Each RValue is 16 bytes, value is at offset 0
        local elementAddress = arrayDataPtr + (i * 16)
        
        local record = al.createMemoryRecord()
        record.Description = arrayConfig.descriptionFormat(i)
        record.Address = string.format("%X", elementAddress)
        record.Type = arrayConfig.valueType
        
        record.appendToEntry(parentRecord)
    end
    
    print("  Added " .. arrayLength .. " entries")
    return true
end

-- Generic function to add a nested array to the address list
function addNestedArrayToList(arrayConfig, parentRecord, al)
    local arrayDataPtr, arrayLength = findGlobalArray(config[arrayConfig.indexKey])
    
    if arrayDataPtr == nil then
        print("Failed to find " .. arrayConfig.name .. ": " .. (arrayLength or "unknown error"))
        return false
    end
    
    print(string.format("%s found: %d levels at 0x%X", arrayConfig.name, arrayLength, arrayDataPtr))
    
    local totalItems = 0
    
    -- Each element in the outer array is an RValue pointing to a nested array
    for levelIdx = 0, arrayLength - 1 do
        local rvalueAddress = arrayDataPtr + (levelIdx * 16)
        
        -- Read the RValue type
        local rvalueType = readInteger(rvalueAddress + 12)
        
        -- Check if this is an array type
        if rvalueType == RVALUE_TYPE_ARRAY then
            -- Read the pointer to the nested array metadata
            local nestedArrayMetadataPtr = readPointer(rvalueAddress)
            
            if nestedArrayMetadataPtr ~= 0 and nestedArrayMetadataPtr ~= nil then
                local nestedDataPtr, nestedLength = readArrayMetadata(nestedArrayMetadataPtr)
                
                if nestedDataPtr ~= nil and nestedLength > 0 then
                    -- Create a group for this level
                    local levelGroup = al.createMemoryRecord()
                    levelGroup.Description = arrayConfig.descriptionFormat(levelIdx, nil)
                    levelGroup.Type = vtGroupHeader
                    levelGroup.IsGroupHeader = true
                    levelGroup.Options = "[moAllowManualCollapseAndExpand,moManualExpandCollapse]"
                    levelGroup.appendToEntry(parentRecord)
                    
                    -- Add each item in the nested array
                    for itemIdx = 0, nestedLength - 1 do
                        local itemAddress = nestedDataPtr + (itemIdx * 16)
                        
                        local record = al.createMemoryRecord()
                        record.Description = arrayConfig.descriptionFormat(levelIdx, itemIdx)
                        record.Address = string.format("%X", itemAddress)
                        record.Type = arrayConfig.valueType
                        
                        record.appendToEntry(levelGroup)
                        totalItems = totalItems + 1
                    end
                end
            end
        end
    end
    
    print("  Added " .. totalItems .. " total items across " .. arrayLength .. " levels")
    return true
end

-- Generic function to add an array to the address list
function addArrayToList(arrayConfig)
    -- Check if this array type is available in the current version
    if config[arrayConfig.indexKey] == nil then
        print("Array '" .. arrayConfig.name .. "' not available in version " .. selectedVersion)
        return false
    end
    
    -- Get the address list
    local al = getAddressList()
    
    -- Clear any existing group with this name
    local existingGroup = al.getMemoryRecordByDescription(arrayConfig.name)
    if existingGroup ~= nil then
        existingGroup.destroy()
    end
    
    -- Create parent group
    local parentRecord = al.createMemoryRecord()
    parentRecord.Description = arrayConfig.name
    parentRecord.Type = vtGroupHeader
    parentRecord.IsGroupHeader = true
    parentRecord.Options = "[moAllowManualCollapseAndExpand,moManualExpandCollapse,moActivateChildrenAsWell,moDeactivateChildrenAsWell]"
    
    local success
    if arrayConfig.isNested then
        success = addNestedArrayToList(arrayConfig, parentRecord, al)
    else
        success = addSimpleArrayToList(arrayConfig, parentRecord, al)
    end
    
    if success then
        print("  " .. arrayConfig.tooltip)
    end
    
    print("")
    return success
end

-- Helper function to reset a simple array to zero
function resetSimpleArray(arrayConfig)
    local arrayDataPtr, arrayLength = findGlobalArray(config[arrayConfig.indexKey])
    
    if arrayDataPtr == nil then
        print("Failed to find " .. arrayConfig.name)
        return false
    end
    
    for i = 0, arrayLength - 1 do
        local elementAddress = arrayDataPtr + (i * 16)
        writeDouble(elementAddress, 0)
    end
    
    print("Reset " .. arrayLength .. " entries in " .. arrayConfig.name .. " to 0!")
    return true
end

-- Helper function to reset a nested array to zero
function resetNestedArray(arrayConfig)
    local arrayDataPtr, arrayLength = findGlobalArray(config[arrayConfig.indexKey])
    
    if arrayDataPtr == nil then
        print("Failed to find " .. arrayConfig.name)
        return false
    end
    
    local totalItems = 0
    
    for levelIdx = 0, arrayLength - 1 do
        local rvalueAddress = arrayDataPtr + (levelIdx * 16)
        local rvalueType = readInteger(rvalueAddress + 12)
        
        if rvalueType == RVALUE_TYPE_ARRAY then
            local nestedArrayMetadataPtr = readPointer(rvalueAddress)
            
            if nestedArrayMetadataPtr ~= 0 and nestedArrayMetadataPtr ~= nil then
                local nestedDataPtr, nestedLength = readArrayMetadata(nestedArrayMetadataPtr)
                
                if nestedDataPtr ~= nil and nestedLength > 0 then
                    for itemIdx = 0, nestedLength - 1 do
                        local itemAddress = nestedDataPtr + (itemIdx * 16)
                        writeDouble(itemAddress, 0)
                        totalItems = totalItems + 1
                    end
                end
            end
        end
    end
    
    print("Reset " .. totalItems .. " entries in " .. arrayConfig.name .. " to 0!")
    return true
end

-- Generic reset function
function resetArray(arrayConfig)
    if config[arrayConfig.indexKey] == nil then
        print("Array '" .. arrayConfig.name .. "' not available in version " .. selectedVersion)
        return false
    end
    
    if arrayConfig.isNested then
        return resetNestedArray(arrayConfig)
    else
        return resetSimpleArray(arrayConfig)
    end
end

-- Convenience functions for specific arrays
function resetAllStages()
    resetArray(arrayTypes[1])
end

function resetAllCometCoins()
    resetArray(arrayTypes[2])
end

function resetAllCometShards()
    resetArray(arrayTypes[3])
end

function resetAllMoonCoins()
    resetArray(arrayTypes[4])
end

function resetAllCloudCoins()
    resetArray(arrayTypes[5])
end

function resetAllCollectables()
    for _, arrayConfig in ipairs(arrayTypes) do
        resetArray(arrayConfig)
    end
end

-- Main execution
print("=== Windswept Collectable Array Editor ===")
print("Version: " .. selectedVersion)
print("")

-- Add all available arrays to the address list
for _, arrayConfig in ipairs(arrayTypes) do
    addArrayToList(arrayConfig)
end

print("Available reset functions:")
print("  resetAllStages()")
print("  resetAllCometCoins()")
print("  resetAllCometShards()")
print("  resetAllMoonCoins()")
print("  resetAllCloudCoins()")
print("  resetAllCollectables() -- resets everything")