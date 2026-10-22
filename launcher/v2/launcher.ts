import GLib from "gi://GLib";
import { execAsync } from "ags/process";
import { readFile, writeFile } from "ags/file";

const homeDir = GLib.get_home_dir();
const CACHE_FILE = `${homeDir}/.cache/start-trio-selection`;

export const PRESETS: Record<string, string[]> = {
    "Trio": ["Linker", "Bragi", "Prof"],
    "Thana": ["Bragi", "Prof", "Dancer"],
    "LinkBS": ["Shekvitelli", "Ushguli", "Minadze"],
};

export const ACCOUNTS: string[] = [
    "Linker", "Bragi", "Prof", "Dancer", "Alcaster", "All-about-zeny", "Kimichuri", "Shekvitelli", "Minadze", "Ushguli"
];

function loadSelection(): string[] {
    try {
        const content = readFile(CACHE_FILE).trim();
        if (content) {
            // Restore only lines that match defined PRESETS
            const savedPresets = content.split('\n').filter(p => p in PRESETS);
            if (savedPresets.length > 0) return savedPresets;
        }
    } catch (_) {
        // Default if no cache exists
    }
    return ["Trio"];
}

class State<T> {
    private _value: T;
    private _listeners: Array<(val: T) => void> = [];

    constructor(initial: T) {
        this._value = initial;
    }

    get value(): T {
        return this._value;
    }

    set value(val: T) {
        this._value = val;
        this._listeners.forEach(cb => cb(val));
    }

    subscribe(cb: (val: T) => void) {
        this._listeners.push(cb);
        cb(this._value);
    }
}

export const selectedState = new State<string[]>(loadSelection());

export function toggleSelection(item: string, isPreset: boolean) {
    let current = [...selectedState.value];

    if (isPreset) {
        if (current.includes(item)) {
            selectedState.value = [];
        } else {
            selectedState.value = [item];
        }
    } else {
        current = current.filter(s => !(s in PRESETS));

        if (current.includes(item)) {
            current = current.filter(s => s !== item);
        } else {
            current.push(item);
        }
        selectedState.value = current;
    }
}

export function launchGame(windowInstance?: any) {
    const selected = selectedState.value;

    const savedPresets = selected.filter(item => item in PRESETS);
    writeFile(CACHE_FILE, savedPresets.join('\n'));

    const finalAccounts = new Set<string>();
    selected.forEach(item => {
        if (PRESETS[item]) {
            PRESETS[item].forEach(acc => finalAccounts.add(acc));
        } else {
            finalAccounts.add(item);
        }
    });

    const launchArgs = Array.from(finalAccounts).join(' ');

    let hostname = '';
    try {
        hostname = readFile('/etc/hostname').trim();
    } catch (_) {}

    // Ensure WAYLAND_DISPLAY and DISPLAY are passed so remote GUI/automation tools work
    const envPrefix = 'WAYLAND_DISPLAY=wayland-1 DISPLAY=:0';
    const logPath = `${homeDir}/.cache/start-trio.log`;

    let targetCommand = "";
    if (hostname === "arch-legion") {
        // Log on tiny-arch directly inside ~/.cache/start-trio.log
        targetCommand = `ssh tiny-arch "${envPrefix} ~/Games/launcher/start-trio.sh ${launchArgs} > ~/.cache/start-trio.log 2>&1"`;
    } else if (hostname === "tiny-arch") {
        targetCommand = `${envPrefix} ${homeDir}/Games/launcher/start-trio.sh ${launchArgs} > ${logPath} 2>&1`;
    }

    console.log(`[DEBUG] Executing: ${targetCommand}`);

    // execAsync callback captures stdout/stderr returned by SSH
    execAsync(targetCommand)
        .then(output => {
            console.log("================ SSH STDOUT ================");
            console.log(output || "(No stdout returned)");
            console.log("============================================");
        })
        .catch(err => {
            console.error("================ SSH STDERR / ERROR ================");
            console.error(err);
            console.error("====================================================");
        });

    if (windowInstance) {
        windowInstance.destroy();
    }
}