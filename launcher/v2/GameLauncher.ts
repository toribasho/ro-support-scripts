import Gtk from "gi://Gtk?version=3.0";
import Gdk from "gi://Gdk";
import { PRESETS, ACCOUNTS, selectedState, toggleSelection, launchGame } from "./launcher.js";

// Helper to unpack presets into individual account checks
const expandPresetsInState = () => {
    const current = selectedState.value;
    const expanded = new Set<string>();
    let hadPreset = false;

    current.forEach(item => {
        if (PRESETS[item]) {
            hadPreset = true;
            PRESETS[item].forEach(acc => expanded.add(acc));
        } else {
            expanded.add(item);
        }
    });

    if (hadPreset) {
        selectedState.value = Array.from(expanded);
    }
};

const SelectionRow = (label: string, isPreset: boolean) => {
    const btn = new Gtk.Button();
    const box = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 10 });
    
    const checkIndicator = new Gtk.Box();
    checkIndicator.get_style_context().add_class('checkbox-box');

    const textContainer = new Gtk.Box({ orientation: Gtk.Orientation.VERTICAL, spacing: 2 });

    const textLabel = new Gtk.Label({
        label: label,
        xalign: 0,
    });
    textContainer.pack_start(textLabel, false, false, 0);

    if (isPreset && PRESETS[label]) {
        const subtextLabel = new Gtk.Label({
            label: PRESETS[label].join(", "),
            xalign: 0,
        });
        subtextLabel.get_style_context().add_class('preset-subtext');
        textContainer.pack_start(subtextLabel, false, false, 0);
    }

    box.pack_start(checkIndicator, false, false, 0);
    box.pack_start(textContainer, true, true, 0);
    btn.add(box);

    btn.get_style_context().add_class('launcher-row');

    const updateCheckState = (selected: string[]) => {
        const isChecked = selected.includes(label);
        const checkCtx = checkIndicator.get_style_context();
        const btnCtx = btn.get_style_context();

        if (isChecked) {
            checkCtx.add_class('active');
        } else {
            checkCtx.remove_class('active');
        }

        if (!isPreset) {
            let isIncludedInPreset = false;
            selected.forEach(sel => {
                if (PRESETS[sel] && PRESETS[sel].includes(label)) {
                    isIncludedInPreset = true;
                }
            });

            if (isIncludedInPreset) {
                btnCtx.add_class('preset-highlight');
            } else {
                btnCtx.remove_class('preset-highlight');
            }
        }
    };

    btn.connect("clicked", () => toggleSelection(label, isPreset));

    updateCheckState(selectedState.value);
    selectedState.subscribe(updateCheckState);

    return btn;
};

const PresetsColumn = () => {
    const box = new Gtk.Box({ orientation: Gtk.Orientation.VERTICAL, spacing: 6 });
    box.get_style_context().add_class('column');
    box.get_style_context().add_class('presets-col');

    const header = new Gtk.Label({ label: "Presets", xalign: 0 });
    header.get_style_context().add_class('column-header');
    box.pack_start(header, false, false, 0);

    Object.keys(PRESETS).forEach(preset => {
        box.pack_start(SelectionRow(preset, true), false, false, 0);
    });

    return box;
};

const AccountsColumn = () => {
    const box = new Gtk.Box({ orientation: Gtk.Orientation.VERTICAL, spacing: 6 });
    box.get_style_context().add_class('column');
    box.get_style_context().add_class('accounts-col');

    const header = new Gtk.Label({ label: "Accounts", xalign: 0 });
    header.get_style_context().add_class('column-header');
    box.pack_start(header, false, false, 0);

    ACCOUNTS.forEach(account => {
        box.pack_start(SelectionRow(account, false), false, false, 0);
    });

    return box;
};

export const GameLauncherWindow = () => {
    const win = new Gtk.Window({
        title: "Game Launcher",
        window_position: Gtk.WindowPosition.CENTER,
    });

    win.get_style_context().add_class('game-launcher-window');

    const mainBox = new Gtk.Box({ orientation: Gtk.Orientation.VERTICAL, spacing: 12 });
    mainBox.get_style_context().add_class('window-content');

    const colsBox = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 20 });
    const separator = new Gtk.Separator({ orientation: Gtk.Orientation.VERTICAL });

    colsBox.pack_start(PresetsColumn(), true, true, 0);
    colsBox.pack_start(separator, false, false, 0);
    colsBox.pack_start(AccountsColumn(), true, true, 0);

    const btnBox = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8, halign: Gtk.Align.END });

    const cancelBtn = new Gtk.Button({ label: "Cancel" });
    cancelBtn.get_style_context().add_class('btn');
    cancelBtn.get_style_context().add_class('btn-cancel');
    cancelBtn.connect("clicked", () => win.destroy());

    const confirmBtn = new Gtk.Button({ label: "CONFIRM" });
    confirmBtn.get_style_context().add_class('btn');
    confirmBtn.get_style_context().add_class('btn-confirm');
    confirmBtn.connect("clicked", () => launchGame(win));

    btnBox.pack_start(cancelBtn, false, false, 0);
    btnBox.pack_start(confirmBtn, false, false, 0);

    mainBox.pack_start(colsBox, true, true, 0);
    mainBox.pack_start(btnBox, false, false, 0);

    win.add(mainBox);

    // Double-space timer state
    let lastSpaceTime = 0;

    win.connect("key-press-event", (_, event: Gdk.EventKey) => {
        const keyval = event.get_keyval()[1];
        const state = event.get_state()[1];
        const now = Date.now();

        // 1. Shift + Enter -> Unpack presets into individual accounts
        if ((keyval === Gdk.KEY_Return || keyval === Gdk.KEY_KP_Enter) && (state & Gdk.ModifierType.SHIFT_MASK)) {
            expandPresetsInState();
            return true;
        }

        // 2. Double Space -> Unpack presets into individual accounts
        if (keyval === Gdk.KEY_space) {
            if (now - lastSpaceTime < 300) {
                expandPresetsInState();
                lastSpaceTime = 0;
                return true;
            }
            lastSpaceTime = now;
        }

        // 3. Regular Enter -> Confirm & Launch
        if ((keyval === Gdk.KEY_Return || keyval === Gdk.KEY_KP_Enter) && !(state & Gdk.ModifierType.SHIFT_MASK)) {
            launchGame(win);
            return true;
        }

        // 4. Escape -> Cancel
        if (keyval === Gdk.KEY_Escape) {
            win.destroy();
            return true;
        }

        return false;
    });

    win.show_all();
    return win;
};