import App from 'resource:///com/github/Aylurs/ags/app.js';
import Utils from 'resource:///com/github/Aylurs/ags/utils.js';
import Variable from 'resource:///com/github/Aylurs/ags/variable.js';

// Configuration
const CACHE_FILE = `${Utils.HOME}/.cache/start-trio-selection`;

export const PRESETS: Record<string, string[]> = {
    "Trio": ["Linker", "Bragi", "Prof"],
    "All-about-zeny": ["Dancer", "Alcaster", "Kimichuri"],
    "Shekvitelli": ["Linker", "Dancer", "Prof"],
};

export const ACCOUNTS: string[] = [
    "Linker", "Bragi", "Prof", "Dancer", "Alcaster", "Kimichuri"
];

// Load initial selection from cache file or default to ["Trio"]
function loadSelection(): string[] {
    try {
        if (Utils.readFile(CACHE_FILE).trim()) {
            return Utils.readFile(CACHE_FILE).trim().split('\n').filter(Boolean);
        }
    } catch (_) {
        // Cache file does not exist yet
    }
    return ["Trio"];
}

export const selectedState = Variable<string[]>(loadSelection());

export function toggleSelection(item: string, isPreset: boolean) {
    let current = [...selectedState.value];

    if (isPreset) {
        // Mutual exclusivity for presets
        if (current.includes(item)) {
            selectedState.value = [];
        } else {
            selectedState.value = [item];
        }
    } else {
        // Clear preset keys when manually selecting individual accounts
        current = current.filter(s => !(s in PRESETS));

        if (current.includes(item)) {
            current = current.filter(s => s !== item);
        } else {
            current.push(item);
        }
        selectedState.value = current;
    }
}

export function launchGame() {
    const selected = selectedState.value;
    
    // Save state to disk
    Utils.writeFile(selected.join('\n'), CACHE_FILE);

    // Resolve presets into full account list
    const finalAccounts = new Set<string>();
    selected.forEach(item => {
        if (PRESETS[item]) {
            PRESETS[item].forEach(acc => finalAccounts.add(acc));
        } else {
            finalAccounts.add(item);
        }
    });

    const launchArgs = Array.from(finalAccounts).join(' ');
    const hostname = Utils.exec('cat /etc/hostname').trim();

    if (hostname === "arch-legion") {
        Utils.execAsync(`ssh tiny-arch "~/Games/launcher/start-trio.sh ${launchArgs}"`);
    } else if (hostname === "tiny-arch") {
        Utils.execAsync(`${Utils.HOME}/Games/launcher/start-trio.sh ${launchArgs}`);
    }

    App.closeWindow("game-launcher");
}