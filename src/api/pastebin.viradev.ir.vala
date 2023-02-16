/* pastebin.viradev.ir.vala
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

namespace Pastor {
    public class PastebinViradevIr : GLib.Object {
        string get_raw_link (Soup.Message request_message) {
            try {
                string pastebin_id = "";

                for (int64 i = request_message.response_body.length; i > 0; i--) {
                    if (request_message.response_body.data[i] == '/')
                        break;
                    else
                        pastebin_id += (((char) request_message.response_body.data[i]).to_string());
                }

                pastebin_id = pastebin_id.reverse().slice(0, -1);
                return @"http://pastebin.viradev.ir/pastebin/view/raw/$pastebin_id";
            } catch (Error err) {
                return err.message;
            }
        }

        public async void send_request (string paste_text) {
            try {
                Soup.Session session = new Soup.Session ();
                Soup.Message message = new Soup.Message("POST", "http://pastebin.viradev.ir/pastebin/api/create");
                message.set_request("application/x-www-form-urlencoded", Soup.MemoryUse.COPY, @"text=$paste_text".data);

                session.queue_message (message,  (sess, mess) => {
                    if (mess.status_code != 200) {
                        error ("error"); // TODO: send dialog for error
                    } else {
                        string raw_link = get_raw_link (message);
                        if ("http" in raw_link)
                            print (raw_link); // TODO: show raw_link for user
                        else
                            error ("error: %s", raw_link); // TODO: send dialog for error
                    }
                });

                Idle.add (send_request.callback);
                yield;
            } catch (Error err) {
                error ("error: %s", err.message); // TODO: send dialog for error
            }
        }
    }
}