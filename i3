# i3 config file (v4)
#
# Please see http://i3wm.org/docs/userguide.html for a complete reference!

set $mod Mod4
workspace_auto_back_and_forth yes
focus_follows_mouse no

# Font for window titles. Will also be used by the bar unless a different font
# is used in the bar {} block below.
font pango:monospace 8
font pango:DejaVu Sans Mono 8
font pango:Noto Mono for Powerline Regular 12

# Use Mouse+$mod to drag floating windows to their wanted position
floating_modifier $mod

# share other screen
bindsym $mod+shift+w move workspace to output right
bindsym $mod+shift+p move container to output right

# use scratch pad
bindsym $mod+shift+U move scratchpad
bindsym $mod+u scratchpad show


# start a terminal
bindsym $mod+Return exec i3-sensible-terminal

# kill focused window
bindsym $mod+Shift+Q kill

# start dmenu (a program launcher)
bindsym $mod+d exec rofi -show run
bindsym $mod+semicolon exec ~/.splatmoji/splatmoji type

# change focus
bindsym $mod+j focus down
bindsym $mod+k focus up
bindsym $mod+l focus right

# alternatively, you can use the cursor keys:
bindsym $mod+Left focus left
bindsym $mod+Down focus down
bindsym $mod+Up focus up
bindsym $mod+Right focus right

# move focused window
bindsym $mod+Shift+J move down
bindsym $mod+Shift+K move up
bindsym $mod+Shift+L move right

# alternatively, you can use the cursor keys:
bindsym $mod+Shift+Left move left
bindsym $mod+Shift+Down move down
bindsym $mod+Shift+Up move up
bindsym $mod+Shift+Right move right

# split in horizontal orientation
bindsym $mod+h split h

# split in vertical orientation
bindsym $mod+v split v

# enter fullscreen mode for the focused container
bindsym $mod+f fullscreen toggle

# change container layout (stacked, tabbed, toggle split)
bindsym $mod+s layout stacking
bindsym $mod+w layout tabbed
bindsym $mod+e layout toggle split

# toggle tiling / floating
bindsym $mod+Shift+space floating toggle

# change focus between tiling / floating windows
bindsym $mod+space focus mode_toggle

# focus the parent container
bindsym $mod+a focus parent

# focus the child container
bindsym $mod+q focus child

# switch to workspace
bindsym $mod+ampersand workspace 1
bindsym $mod+eacute workspace 2
bindsym $mod+quotedbl workspace 3
bindsym $mod+apostrophe workspace 4
bindsym $mod+parenleft workspace 5
bindsym $mod+minus workspace 6
bindsym $mod+egrave workspace 7
bindsym $mod+underscore workspace 8
bindsym $mod+ccedilla workspace 9
bindsym $mod+agrave workspace 10

# move focused container to workspace
bindsym $mod+Shift+ampersand move container to workspace 1
bindsym $mod+Shift+2 move container to workspace 2
bindsym $mod+Shift+3 move container to workspace 3
bindsym $mod+Shift+4 move container to workspace 4
bindsym $mod+Shift+5 move container to workspace 5
bindsym $mod+Shift+6 move container to workspace 6
bindsym $mod+Shift+7 move container to workspace 7
bindsym $mod+Shift+underscore move container to workspace 8
bindsym $mod+Shift+9 move container to workspace 9
bindsym $mod+Shift+0 move container to workspace 10

# reload the configuration file
bindsym $mod+Shift+C reload
# restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
bindsym $mod+Shift+R restart
# exit i3 (logs you out of your X session)
bindsym $mod+Shift+E exec xfce4-session-logout

# resize window (you can also use the mouse for that)
bindsym $mod+r mode "resize"
mode "resize" {
        # These bindings trigger as soon as you enter the resize mode
        bindsym Left resize shrink width 10 px or 10 ppt
        bindsym Down resize grow height 10 px or 10 ppt
        bindsym Up resize shrink height 10 px or 10 ppt
        bindsym Right resize grow width 10 px or 10 ppt

        # back to normal: Enter or Escape
        bindsym Return mode "default"
        bindsym Escape mode "default"
}

default_border pixel 3
exec --no-startup-id ~/.fehbg

# Theming
client.focused          #333333 #81A2BE #FFFFFF #81A2BE   #81A2BE
client.focused_inactive #333333 #5F676A #B0C4BB #484E50   #3B3F6A
client.unfocused        #333333 #5F676A #B0C4BB #688486   #688486
client.urgent           #333333 #900000 #909090 #900000   #900000
client.placeholder      #333333 #0C0C0C #FFFFFF #000000   #0C0C0C

# Set floating window for some apps
for_window [class="zoom" instance="zoom"] floating enable
for_window [class="gnome-pomodoro"] floating enable