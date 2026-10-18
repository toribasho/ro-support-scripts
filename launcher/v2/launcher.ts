import GLib from "gi://GLib";
import { execAsync } from "ags/process";
import { readFile, writeFile } from "ags/file";

const homeDir = GLib.get_home_dir();
const CACHE_FILE = `${homeDir}/.cache/start-trio-selection`;

export const PRESETS: Record<string, string[]> = {
    "Trio": ["Linker", "Bragi", "Prof"],
    "ProfWithSongs": ["Bragi", "Prof", "Dancer"],
    "LinkBS": ["Linker", "Minadze"],
};

export const ACCOUNTS: string[] = [
    "Linker", "Bragi", "Prof", "Dancer", "Alcaster", "All-about-zeny", "Kimichuri", "Shekvitelli", "Minadze"
];

function loadSelection(): string[] {
    try {
        const content = readFile(CACHE_FILE).trim();
        if (content) return content.split('\n').filter(Boolean);
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

    writeFile(selected.join('\n'), CACHE_FILE);

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

    if (hostname === "arch-legion") {
        execAsync(`ssh tiny-arch "~/Games/launcher/start-trio.sh ${launchArgs}"`);
    } else if (hostname === "tiny-arch") {
        execAsync(`${homeDir}/Games/launcher/start-trio.sh ${launchArgs}`);
    }

    if (windowInstance) {
        windowInstance.destroy();
    }
}