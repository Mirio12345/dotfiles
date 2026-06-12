-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
hl.on("hyprland.start", function ()
--   hl.exec_cmd("nm-applet")
hl.exec_cmd("waybar & hyprpaper & swaync & hypridle")
hl.exec_cmd("blueman-applet")
hl.exec_cmd("systemctl --user start hyprpolkitagent")
hl.exec_cmd("hyprctl setcursor Bibata-Modern-Classic 18")
hl.exec_cmd("wl-paste --type text --watch cliphist store")
hl.exec_cmd("wl-paste --type image --watch cliphist store")

end)

