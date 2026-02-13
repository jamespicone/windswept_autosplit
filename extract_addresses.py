#!/usr/bin/env python3
"""
Windswept Address Extraction Tool

Extracts memory addresses from a Windswept executable for use in the
LiveSplit autosplitter ASL script. Automates finding ~11 addresses that
previously required manual reverse engineering with Ghidra/IDA.

Usage:
    python extract_addresses.py Windswept.exe [--version-name "1.2.0 (Steam)"]
"""

import argparse
import bisect
import hashlib
import struct
import sys
from collections import defaultdict
from pathlib import Path

# Variable names to find and their ASL field names
VARIABLES = [
    ("array_StageClears", "arrayStageClearIndex"),
    ("timer_Full", "timerFullIndex"),
    ("timer_Stop", "timerStopIndex"),
    ("stageType", "stageTypeIndex"),
    ("frameCount_Room", "frameCountRoomIndex"),
    ("array_CometCoins", "arrayCometCoinIndex"),
    ("array_CometShards", "arrayCometShardIndex"),
    ("array_MoonCoins", "arrayMoonCoinsIndex"),
    ("array_CloudCoins", "arrayCloudCoinsIndex"),
]

# Sentinel bytes at the index location in the static binary (uninitialized):
# int32 index = -1 (0xFFFFFFFF) followed by 4 zero bytes.
SENTINEL = b'\xff\xff\xff\xff\x00\x00\x00\x00'

# Fixed offset from GlobalData pointer to room variable.
# Constant across all 10 known versions (1.0.7 through 1.1.01 Hotfix 2).
ROOM_OFFSET = 0x31C828

# Known versions: MD5 hash -> expected addresses (for validation).
KNOWN_VERSIONS = {
    "D288C9A5FFD5C01F125AD0695CDD6649": {
        "name": "1.0.7 (Steam)", "moduleSize": 31907840,
        "room": 0x1D21888, "globalData": 0x1a05060,
        "arrayStageClearIndex": 0x199e428, "timerFullIndex": 0x199ea38,
        "timerStopIndex": 0x199e718, "stageTypeIndex": 0x199bd98,
        "frameCountRoomIndex": 0x199e568,
    },
    "B96CCEF3B9DA79580B06A455400F2B49": {
        "name": "1.0.8.1 (Steam)", "moduleSize": 31944704,
        "room": 0x1d2a858, "globalData": 0x1a0e030,
        "arrayStageClearIndex": 0x19a72c8, "timerFullIndex": 0x19a78f8,
        "timerStopIndex": 0x19a75c8, "stageTypeIndex": 0x19a4c18,
        "frameCountRoomIndex": 0x19a7418,
    },
    "1BA68D3A6C05582FB327362D8B251BE3": {
        "name": "1.0.8 (GOG)", "moduleSize": 31993856,
        "room": 0x1d35758, "globalData": 0x1a18f30,
        "arrayStageClearIndex": 0x19b2af8, "timerFullIndex": 0x19b28c8,
        "timerStopIndex": 0x19b25b8, "stageTypeIndex": 0x19afbf8,
        "frameCountRoomIndex": 0x19b23f8,
    },
    "38D299CEC8B8BF3B7E828D76267A1078": {
        "name": "1.0.9 (Steam)", "moduleSize": 31985664,
        "room": 0x1d34b18, "globalData": 0x1a182f0,
        "arrayStageClearIndex": 0x19b1338, "timerFullIndex": 0x19b1958,
        "timerStopIndex": 0x19b1638, "stageTypeIndex": 0x19aec68,
        "frameCountRoomIndex": 0x19b1478,
    },
    "9A440B441E75C3082047D5E126F251BD": {
        "name": "1.0.9.1 (Steam)", "moduleSize": 31985664,
        "room": 0x1d34b18, "globalData": 0x1a182f0,
        "arrayStageClearIndex": 0x19b1338, "timerFullIndex": 0x19b1948,
        "timerStopIndex": 0x19b1638, "stageTypeIndex": 0x19aec88,
        "frameCountRoomIndex": 0x19b1468,
        "arrayCometCoinIndex": 0x19b1298, "arrayCometShardIndex": 0x19b1858,
        "arrayMoonCoinsIndex": 0x19b2858, "arrayCloudCoinsIndex": 0x19b25b8,
    },
    "A0A9013416485F54959D2BF6C406B6D8": {
        "name": "1.1.0 (Steam)", "moduleSize": 31993856,
        "room": 0x1d36b48, "globalData": 0x1a1a320,
        "arrayStageClearIndex": 0x19b33a8, "timerFullIndex": 0x19b39e8,
        "timerStopIndex": 0x19b36b8, "stageTypeIndex": 0x19b0d08,
        "frameCountRoomIndex": 0x19b3508,
    },
    "C5E1EB36AA48FDE22AE9A6783C77EA54": {
        "name": "1.1.01 (Steam)", "moduleSize": 31993856,
        "room": 0x1d36b88, "globalData": 0x1a1a360,
        "arrayStageClearIndex": 0x19b33a8, "timerFullIndex": 0x19b39e8,
        "timerStopIndex": 0x19b36c8, "stageTypeIndex": 0x19b0ce8,
        "frameCountRoomIndex": 0x19b3508,
    },
    "564C13E0FC184AB0E4C5D57A3915E324": {
        "name": "1.1.01 Hotfix (Steam)", "moduleSize": 32006144,
        "room": 0x1d39c78, "globalData": 0x1a1d450,
        "arrayStageClearIndex": 0x19b63f8, "timerFullIndex": 0x19b6a38,
        "timerStopIndex": 0x19b66f8, "stageTypeIndex": 0x19b3d58,
        "frameCountRoomIndex": 0x19b6548,
        "arrayCometCoinIndex": 0x19b6358, "arrayCometShardIndex": 0x19b6938,
        "arrayMoonCoinsIndex": 0x19b7908, "arrayCloudCoinsIndex": 0x19b7648,
    },
    "FDDD0EC04F07986361FE370E5C028B9A": {
        "name": "1.1.01 (GOG)", "moduleSize": 32047104,
        "room": 0x1d42aa8,
        "globalData": 0x1a26280,
        "arrayStageClearIndex": 0x19bf3e8, "timerFullIndex": 0x19bf9f8,
        "timerStopIndex": 0x19bf6f8, "stageTypeIndex": 0x19bcd38,
        "frameCountRoomIndex": 0x19bf528,
        "arrayCometCoinIndex": 0x19bf338, "arrayCometShardIndex": 0x19bf8f8,
        "arrayMoonCoinsIndex": 0x19c08d8, "arrayCloudCoinsIndex": 0x19c0648,
    },
    "1AFB64D60DECF8F5AA57F0BF3CE82F0B": {
        "name": "1.1.01 Hotfix 2 (Steam)", "moduleSize": 32006144,
        "room": 0x1d39c78, "globalData": 0x1a1d450,
        "arrayStageClearIndex": 0x19b63f8, "timerFullIndex": 0x19b6a28,
        "timerStopIndex": 0x19b6708, "stageTypeIndex": 0x19b3d38,
        "frameCountRoomIndex": 0x19b6548,
        "arrayCometCoinIndex": 0x19b6378, "arrayCometShardIndex": 0x19b6918,
        "arrayMoonCoinsIndex": 0x19b7918, "arrayCloudCoinsIndex": 0x19b7658,
    },
}


class PEFile:
    """Minimal PE64 parser for section mapping and RVA conversion."""

    def __init__(self, path):
        self.data = Path(path).read_bytes()
        self._parse()

    def _parse(self):
        if self.data[:2] != b'MZ':
            raise ValueError("Not a valid PE file (missing MZ signature)")
        e_lfanew = struct.unpack_from('<I', self.data, 0x3C)[0]
        if self.data[e_lfanew:e_lfanew + 4] != b'PE\x00\x00':
            raise ValueError("Not a valid PE file (missing PE signature)")

        coff = e_lfanew + 4
        machine, num_sections = struct.unpack_from('<HH', self.data, coff)
        opt_size = struct.unpack_from('<H', self.data, coff + 16)[0]
        if machine != 0x8664:
            raise ValueError(f"Not a 64-bit PE (machine=0x{machine:04x})")

        opt = coff + 20
        if struct.unpack_from('<H', self.data, opt)[0] != 0x20B:
            raise ValueError("Not a PE32+ optional header")

        self.image_base = struct.unpack_from('<Q', self.data, opt + 24)[0]
        self.size_of_image = struct.unpack_from('<I', self.data, opt + 56)[0]

        self.sections = []
        sec_off = opt + opt_size
        for i in range(num_sections):
            o = sec_off + i * 40
            name = self.data[o:o + 8].split(b'\x00')[0].decode('ascii', errors='replace')
            vsize, vaddr, rsize, roff = struct.unpack_from('<IIII', self.data, o + 8)
            self.sections.append({
                'name': name, 'virtual_size': vsize, 'virtual_address': vaddr,
                'raw_size': rsize, 'raw_offset': roff,
            })

    def get_section(self, name):
        for s in self.sections:
            if s['name'] == name:
                return s
        return None

    def section_data(self, section):
        o, sz = section['raw_offset'], section['raw_size']
        return self.data[o:o + sz]

    def rva_in_section(self, rva, section):
        return (section['virtual_address'] <= rva <
                section['virtual_address'] + section['virtual_size'])

    def md5(self):
        return hashlib.md5(self.data).hexdigest().upper()

    def file_size(self):
        return len(self.data)


def find_all_rip_refs(text_data, text_rva):
    """Extract all RIP-relative MOV/LEA references from .text.

    Scans for two instruction forms:
    - 6-byte (no REX): opcode ModRM disp32  (for 32-bit operands like indices)
    - 7-byte (REX.W):  REX opcode ModRM disp32  (for 64-bit operands like pointers)

    ModRM must have mod=00, rm=101 for RIP-relative addressing.
    Returns list of (instruction_rva, target_rva).
    """
    refs = []
    # ModRM bytes with mod=00, rm=101: 0x05, 0x0D, 0x15, ..., 0x3D
    valid_modrm = frozenset(range(0x05, 0x40, 8))

    # 7-byte REX-prefixed: (48|4C) (8B|8D) ModRM disp32
    limit7 = len(text_data) - 6
    for rex in (0x48, 0x4C):
        for opcode in (0x8B, 0x8D):
            prefix = bytes([rex, opcode])
            pos = 0
            while True:
                pos = text_data.find(prefix, pos)
                if pos == -1 or pos > limit7:
                    break
                if text_data[pos + 2] in valid_modrm:
                    disp = struct.unpack_from('<i', text_data, pos + 3)[0]
                    inst_rva = text_rva + pos
                    target = inst_rva + 7 + disp
                    if target > 0:
                        refs.append((inst_rva, target))
                pos += 1

    # 6-byte non-REX: (8B|8D) ModRM disp32 (32-bit operand, used for indices)
    limit6 = len(text_data) - 5
    for opcode in (0x8B, 0x8D):
        pos = 0
        while True:
            pos = text_data.find(bytes([opcode]), pos)
            if pos == -1 or pos > limit6:
                break
            if text_data[pos + 1] in valid_modrm:
                # Skip if preceded by a REX byte (already handled above)
                if pos > 0 and 0x40 <= text_data[pos - 1] <= 0x4F:
                    pos += 1
                    continue
                disp = struct.unpack_from('<i', text_data, pos + 2)[0]
                inst_rva = text_rva + pos
                target = inst_rva + 6 + disp
                if target > 0:
                    refs.append((inst_rva, target))
            pos += 1

    return refs


def find_variable_indices(pe):
    """Find variable index RVAs via string cross-references in .rdata/.data."""
    rdata = pe.get_section('.rdata')
    data_sec = pe.get_section('.data')
    if not rdata or not data_sec:
        print("  ERROR: Missing .rdata or .data section")
        return {}

    rdata_bytes = pe.section_data(rdata)
    data_bytes = pe.section_data(data_sec)
    results = {}

    for var_name, asl_name in VARIABLES:
        # Find the null-terminated string in .rdata
        needle_str = var_name.encode('ascii') + b'\x00'
        str_pos = rdata_bytes.find(needle_str)
        if str_pos == -1:
            print(f"  WARNING: '{var_name}' not found in .rdata")
            continue

        # Compute VA of the string (as stored in on-disk pointers)
        string_va = pe.image_base + rdata['virtual_address'] + str_pos
        ptr_needle = struct.pack('<Q', string_va)

        # Search .data for 8-byte pointer to this string VA
        found = False
        search_pos = 0
        while True:
            match = data_bytes.find(ptr_needle, search_pos)
            if match == -1:
                break
            # Validate: next 8 bytes should be the uninitialized sentinel
            sentinel_off = match + 8
            if (sentinel_off + 8 <= len(data_bytes) and
                    data_bytes[sentinel_off:sentinel_off + 8] == SENTINEL):
                index_rva = data_sec['virtual_address'] + match + 8
                results[asl_name] = index_rva
                print(f"  {var_name:25s} -> 0x{index_rva:x}")
                found = True
                break
            search_pos = match + 1

        if not found:
            print(f"  WARNING: No index address found for '{var_name}'")

    return results


def find_global_data(pe, index_rvas, rip_refs):
    """Find GlobalData RVA by scoring .data references near variable index xrefs.

    Code that uses a variable index also loads GlobalData nearby. We find
    instructions referencing variable index addresses, then look at nearby
    instructions for .data references. The address appearing near the most
    distinct variable indices is GlobalData.
    """
    data_sec = pe.get_section('.data')
    if not data_sec or not index_rvas:
        return None

    # Map target RVAs to variable names (both index addr and struct base)
    index_targets = {}
    for name, rva in index_rvas.items():
        index_targets[rva] = name
        index_targets[rva - 8] = name  # struct base (string pointer location)

    # Find code xrefs to variable index addresses
    xrefs = []  # (inst_rva, var_name)
    for inst_rva, target in rip_refs:
        if target in index_targets:
            xrefs.append((inst_rva, index_targets[target]))

    if not xrefs:
        print("  WARNING: No code references to variable indices found")
        return None
    print(f"  Found {len(xrefs)} code references to variable indices")

    # Sort all refs for efficient range queries
    sorted_refs = sorted(rip_refs, key=lambda x: x[0])
    sorted_rvas = [r[0] for r in sorted_refs]

    # Score candidates: for each xref, find nearby .data references
    candidates = defaultdict(set)  # target_rva -> set of variable names

    for xref_rva, var_name in xrefs:
        left = bisect.bisect_left(sorted_rvas, xref_rva - 64)
        right = bisect.bisect_right(sorted_rvas, xref_rva + 64)
        for i in range(left, right):
            _, nearby_target = sorted_refs[i]
            if nearby_target in index_targets:
                continue
            if pe.rva_in_section(nearby_target, data_sec):
                candidates[nearby_target].add(var_name)

    if not candidates:
        print("  WARNING: No GlobalData candidates found")
        return None

    ranked = sorted(candidates.items(), key=lambda x: len(x[1]), reverse=True)
    best_rva, best_vars = ranked[0]

    print(f"  GlobalData -> 0x{best_rva:x} "
          f"(near {len(best_vars)}/{len(index_rvas)} variables)")
    if len(ranked) > 1:
        r2_rva, r2_vars = ranked[1]
        print(f"  Runner-up:    0x{r2_rva:x} (near {len(r2_vars)} variables)")

    # Extra info: check if it's in BSS region (beyond raw data)
    bss_start = data_sec['virtual_address'] + data_sec['raw_size']
    if best_rva >= bss_start:
        print(f"  (In BSS region - expected for runtime-initialized pointer)")

    return best_rva


def compute_room(global_data_rva, pe):
    """Compute room RVA as GlobalData + fixed offset."""
    room_rva = global_data_rva + ROOM_OFFSET
    data_sec = pe.get_section('.data')

    if data_sec and pe.rva_in_section(room_rva, data_sec):
        print(f"  room -> 0x{room_rva:x} (GlobalData + 0x{ROOM_OFFSET:X})")
    else:
        print(f"  WARNING: room 0x{room_rva:x} outside .data section!")
        print(f"  The fixed offset 0x{ROOM_OFFSET:X} may have changed.")

    return room_rva


def format_asl_state(version_name, addresses):
    """Generate a ready-to-paste ASL state() block."""
    lines = [f'state("Windswept", "{version_name}") {{']

    if 'room' in addresses:
        lines.append(f'\tint room: "Windswept.exe", 0x{addresses["room"]:x} ;')
    lines.append('\t')

    if 'globalData' in addresses:
        lines.append('\t// GlobalData\'s hashmap.')
        lines.append(
            f'\tlong globalDataHashMap: "Windswept.exe",'
            f' 0x{addresses["globalData"]:x}, 0x48;')

    found_vars = [(vn, an) for vn, an in VARIABLES if an in addresses]
    if found_vars:
        lines.append('')
        lines.append('\t// Variable indices')
        for var_name, asl_name in found_vars:
            lines.append(
                f'\tlong {asl_name}: "Windswept.exe",'
                f' 0x{addresses[asl_name]:x}; // {var_name}')

    lines.append('}')
    return '\n'.join(lines)


def format_asl_init(version_name, md5_hash, module_size, akc_supported):
    """Generate a ready-to-paste ASL init() block."""
    lines = [
        f'\tif (moduleSize == {module_size} && hash == "{md5_hash}")',
        '\t{',
        f'\t\tversion = "{version_name}";',
    ]
    if akc_supported:
        lines.append('\t\tvars.akcSupported = true;')
    lines.append('\t\treturn;')
    lines.append('\t}')
    return '\n'.join(lines)


def validate(md5_hash, addresses):
    """Compare extracted addresses against known version data."""
    known = KNOWN_VERSIONS[md5_hash]
    print(f"  Known version: {known['name']}")
    print(f"  Expected ModuleMemorySize: {known['moduleSize']}")

    all_ok = True
    checks = [('room', 'room'), ('globalData', 'globalData')]
    checks += [(an, an) for _, an in VARIABLES]

    for addr_key, known_key in checks:
        if known_key not in known:
            continue
        expected = known[known_key]
        actual = addresses.get(addr_key)

        if actual is None:
            print(f"  MISS  {addr_key}: expected 0x{expected:x}, not found")
            all_ok = False
        elif actual == expected:
            print(f"  OK    {addr_key}: 0x{actual:x}")
        else:
            print(f"  DIFF  {addr_key}: got 0x{actual:x},"
                  f" expected 0x{expected:x}")
            all_ok = False

    if all_ok:
        print("  All addresses match!")
    else:
        print("  Some addresses differ - review above.")

    return all_ok


def main():
    parser = argparse.ArgumentParser(
        description="Extract Windswept autosplitter addresses from an exe")
    parser.add_argument('exe', help='Path to Windswept.exe')
    parser.add_argument('--version-name',
                        help='Version name for ASL output (auto-detected'
                             ' for known versions)')
    args = parser.parse_args()

    path = Path(args.exe)
    if not path.exists():
        print(f"ERROR: {path} not found")
        sys.exit(1)

    print(f"Loading {path.name}...")
    pe = PEFile(path)

    md5 = pe.md5()
    file_size = pe.file_size()
    print(f"  MD5:         {md5}")
    print(f"  File size:   {file_size}")
    print(f"  SizeOfImage: {pe.size_of_image} (ModuleMemorySize)")
    print()

    # Step 1: Find variable indices
    print("Finding variable indices...")
    indices = find_variable_indices(pe)
    print(f"  Found {len(indices)}/{len(VARIABLES)} variable indices")
    print()

    # Step 2: Find GlobalData
    print("Finding GlobalData...")
    text_sec = pe.get_section('.text')
    global_data = None
    if text_sec:
        text_data = pe.section_data(text_sec)
        print(f"  Scanning .text ({len(text_data):,} bytes)...")
        rip_refs = find_all_rip_refs(text_data, text_sec['virtual_address'])
        print(f"  Found {len(rip_refs):,} RIP-relative references")
        global_data = find_global_data(pe, indices, rip_refs)
    else:
        print("  ERROR: No .text section found")
    print()

    # Step 3: Compute room address
    print("Computing room address...")
    room = compute_room(global_data, pe) if global_data else None
    print()

    # Collect results
    addresses = dict(indices)
    if global_data:
        addresses['globalData'] = global_data
    if room:
        addresses['room'] = room

    # Determine version name and AKC support
    version_name = args.version_name
    if not version_name and md5 in KNOWN_VERSIONS:
        version_name = KNOWN_VERSIONS[md5]['name']
    if not version_name:
        version_name = "Unknown"

    akc_supported = all(
        an in addresses for _, an in VARIABLES[5:])  # collectable arrays

    # Print results
    print("=" * 60)
    print(f"Version: {version_name}")
    print(f"MD5:     {md5}")
    print(f"Size:    {file_size}")
    print(f"Module:  {pe.size_of_image} (ModuleMemorySize)")
    print()

    print("Addresses:")
    if room:
        print(f"  {'room':30s} 0x{room:x}")
    if global_data:
        print(f"  {'globalData':30s} 0x{global_data:x}")
    for var_name, asl_name in VARIABLES:
        if asl_name in indices:
            print(f"  {asl_name:30s} 0x{indices[asl_name]:x}")
    print()

    print("--- ASL state() block ---")
    print(format_asl_state(version_name, addresses))
    print()

    print("--- ASL init() block ---")
    print(format_asl_init(version_name, md5, pe.size_of_image, akc_supported))
    print()

    # Validation against known versions
    if md5 in KNOWN_VERSIONS:
        print("--- Validation ---")
        validate(md5, addresses)


if __name__ == '__main__':
    main()
