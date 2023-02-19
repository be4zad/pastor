/* window.vala
*
* Copyright 2023 Behzad Asbahi
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <http://www.gnu.org/licenses/>.
*
* SPDX-License-Identifier: GPL-3.0-or-later
*/

using Gtk;

namespace Pastor {
    [GtkTemplate (ui = "/org/pastor/Pastor/ui/window.ui")]
    public class Window : Adw.ApplicationWindow {
        [GtkChild]
        private unowned TextView text_input;
        [GtkChild]
        private unowned Overlay text_input_overlay;
        [GtkChild]
        private unowned Button get_link_button;
        [GtkChild]
        public unowned Stack main_stack;
        [GtkChild]
        private unowned StackPage main_clamp_result_page;
        [GtkChild]
        private unowned Adw.ActionRow result_action_row;
        [GtkChild]
        private unowned Adw.ToastOverlay toast_overlay;

        private Label text_input_overlay_label;
        private TextBuffer text_input_buffer;

        public Window (Gtk.Application app) {
            Object (application: app);
            add_text_input_overlay ();
            add_text_input_buffer ();
            get_link_button.clicked.connect (() => {
                new Request ("pastebin.viradev.ir", text_input_buffer.text, this);
            });
        }

        protected void add_text_input_buffer () {
            text_input_buffer = new TextBuffer (null);
            text_input.buffer = text_input_buffer;
            text_input_buffer.changed.connect (() => {
                if (text_input_buffer.text != "") {
                    text_input_overlay_label.visible = false;
                    get_link_button.sensitive = true;
                } else {
                    text_input_overlay_label.visible = true;
                    get_link_button.sensitive = false;
                }
            });
        }

        protected void add_text_input_overlay () {
            text_input_overlay_label = new Label (_("Type or paste your text here…")) {
                valign = Align.START,
                halign = Align.START,
                justify = Justification.FILL,
                margin_top = 9,
                margin_start = 9,
                sensitive = false
            };
            text_input_overlay.add_overlay (text_input_overlay_label);
        }

        public void set_result (string pastebin_link) {
            if (pastebin_link != "")
                result_action_row.title = pastebin_link;
        }

        public void show_toast (string title) {
            var toast = new Adw.Toast (title);
            toast_overlay.add_toast (toast);
        }
    }
}
