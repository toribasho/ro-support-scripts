import Widget from 'resource:///com/github/Aylurs/ags/widget.js';
import App from 'resource:///com/github/Aylurs/ags/app.js';
import { PRESETS, ACCOUNTS, selectedState, toggleSelection, launchGame } from './launcher';

// Checkbox item row component
const SelectionRow = (label: string, isPreset: boolean) => Widget.Button({
    class_name: 'launcher-row',
    on_clicked: () => toggleSelection(label, isPreset),
    child: Widget.Box({
        spacing: 8,
        children: [
            Widget.Label({
                class_name: 'checkbox',
                label: selectedState.bind().transform(selected => 
                    selected.includes(label) ? "[x]" : "[ ]"
                ),
            }),
            Widget.Label({
                label: label,
                xalign: 0,
            }),
        ],
    }),
});

// Left Column: Presets
const PresetsColumn = () => Widget.Box({
    vertical: true,
    spacing: 6,
    class_name: 'column presets-col',
    children: [
        Widget.Label({ label: "Presets", class_name: "column-header", xalign: 0 }),
        ...Object.keys(PRESETS).map(preset => SelectionRow(preset, true)),
    ],
});

// Right Column: Individual Accounts
const AccountsColumn = () => Widget.Box({
    vertical: true,
    spacing: 6,
    class_name: 'column accounts-col',
    children: [
        Widget.Label({ label: "Accounts", class_name: "column-header", xalign: 0 }),
        ...ACCOUNTS.map(account => SelectionRow(account, false)),
    ],
});

// Main Window Container
export const GameLauncherWindow = () => Widget.Window({
    name: 'game-launcher',
    class_name: 'game-launcher-window',
    anchor: ['center'],
    keymode: 'exclusive',
    visible: false,
    child: Widget.Box({
        vertical: true,
        spacing: 12,
        class_name: 'window-content',
        children: [
            // Two-Column Grid Layout
            Widget.Box({
                spacing: 20,
                children: [
                    PresetsColumn(),
                    Widget.Separator({ vertical: true }),
                    AccountsColumn(),
                ],
            }),
            // Action Buttons
            Widget.Box({
                spacing: 8,
                halign: 'end',
                children: [
                    Widget.Button({
                        class_name: 'btn btn-cancel',
                        on_clicked: () => App.closeWindow('game-launcher'),
                        child: Widget.Label('Cancel'),
                    }),
                    Widget.Button({
                        class_name: 'btn btn-confirm',
                        on_clicked: () => launchGame(),
                        child: Widget.Label('CONFIRM'),
                    }),
                ],
            }),
        ],
    }),
});