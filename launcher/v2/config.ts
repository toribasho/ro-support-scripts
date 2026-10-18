import Gtk from "gi://Gtk?version=3.0";
import Gdk from "gi://Gdk";
import GLib from "gi://GLib";

import App from 'resource:///com/github/Aylurs/ags/app.js';
import { GameLauncherWindow } from './GameLauncher.js';

App.config({
    style: './style.css',
    windows: [
        GameLauncherWindow(),
    ],
});