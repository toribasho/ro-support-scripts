import Gtk from "gi://Gtk?version=3.0";
import Gdk from "gi://Gdk";
import GLib from "gi://GLib";
import Gio from "gi://Gio";

import { GameLauncherWindow } from "./GameLauncher.js";

Gtk.init(null);

// Apply custom CSS
const provider = new Gtk.CssProvider();
const cssPath = `${GLib.get_current_dir()}/style.css`;
const cssFile = Gio.File.new_for_path(cssPath);

if (cssFile.query_exists(null)) {
    provider.load_from_file(cssFile);
    Gtk.StyleContext.add_provider_for_screen(
        Gdk.Screen.get_default()!,
        provider,
        Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
    );
}

const win = GameLauncherWindow();

win.connect("destroy", () => {
    Gtk.main_quit();
});

Gtk.main();