import Gtk from "gi://Gtk?version=3.0";
import Gdk from "gi://Gdk";
import { PRESETS, ACCOUNTS, selectedState, toggleSelection, launchGame } from "./launcher.js";

const SelectionRow = (label: string, isPreset: boolean) => {
    const btn = new Gtk.Button();
    const box = new Gtk.Box({ orientation: Gtk.Orientation.HORIZONTAL, spacing: 8 });
    
    const checkLabel = new Gtk.Label({
        label: selectedState.value.includes(label) ? "[x]" : "[ ]",
    });
    
    const textLabel = new Gtk.Label({
        label: label,
        xalign: 0,
    });

    box.pack_start(checkLabel, false, false, 0);
    box.pack_start(textLabel, true, true, 0);
    btn.add(box);

    btn.get_style_context().add_class('launcher-row');

    btn.connect("clicked", () => toggleSelection(label, isPreset));

    selectedState.subscribe(selected => {
        checkLabel.set_label(selected.includes(label) ? "[x]" : "[ ]");
    });

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

    // Add Escape and Return keyboard shortcuts
    win.connect("key-press-event", (_, event: Gdk.EventKey) => {
        const keyval = event.get_keyval()[1];
        if (keyval === Gdk.KEY_Escape) {
            win.destroy();
            return true;
        } else if (keyval === Gdk.KEY_Return || keyval === Gdk.KEY_KP_Enter) {
            launchGame(win);
            return true;
        }
        return false;
    });

    win.show_all();
    return win;
};