{ ... }:
{

  services.dunst = {
    enable = true;
    settings = {
      global = {
        font = "Iosevka Term 11";
        markup = "yes";
        format = "<span size='large' >%a</span>\n<b>%s</b>: <span size='small' >%b</span>";
        sort = "no";
        indicate_hidden = "yes";
        alignment = "center";
        show_age_threshold = 60;
        word_wrap = "yes";
        ignore_newline = "no";
        stack_duplicates = "yes";
        hide_duplicate_count = "yes";
        width = 400;
        height = 150;
        origin = "bottom-right";
        offset = "5x10";
        shrink = "no";
        transparency = 5;
        idle_threshold = 120;
        monitor = 0;
        follow = "keyboard";
        sticky_history = "yes";
        history_length = 15;
        show_indicators = "yes";
        line_height = 3;
        separator_height = 2;
        padding = 6;
        horizontal_padding = 6;
        separator_color = "auto";
        dmenu = "/usr/bin/dmenu -p dunst:";
        browser = "/usr/bin/firefox -new-tab";
        icon_position = "off";
        max_icon_size = 80;
        icon_path = "/usr/share/icons/Paper/16x16/mimetypes/:/usr/share/icons/Paper/48x48/status/:/usr/share/icons/Paper/16x16/devices/:/usr/share/icons/Paper/48x48/notifications/:/usr/share/icons/Paper/48x48/emblems/";
        frame_width = 2;
      };
      base16_low = {
          frame_color = "#5e81ac77";
          msg_urgency = "low";
          background = "#3b4252";
          foreground = "#e5e9f0";
      };

      base16_normal = {
          frame_color = "#a3be8c77";
          msg_urgency = "normal";
          background = "#3b4252";
          foreground = "#e5e9f0";
      };

      base16_critical = {
          frame_color = "#bf616a77";
          msg_urgency = "critical";
          background = "#3b4252";
          foreground = "#e5e9f0";
      };
    };
  };
}