local wezterm = require 'wezterm';

-- SSH Domains
local ssh_domains = {}
for host, config in pairs(wezterm.enumerate_ssh_hosts()) do
    table.insert(ssh_domains, {
        name = host,
        remote_address = config["hostname"],
        username = config["user"],
        ssh_option = { identityfile = config["identityfile"] },
    })
end

-- デフォルト(ほぼLinux)はbash
local default_prog = { 'bash', '-l' }

-- OS環境差分吸収
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  default_prog = { 'pwsh.exe', '-NoLogo' }
end
if wezterm.target_triple == "x86_64-apple-darwin" then 
  default_prog = { 'zsh', '-l' }
end
if wezterm.target_triple == "aarch64-apple-darwin" then 
  default_prog = { 'zsh', '-l' }
end

-- Equivalent to POSIX basename(3)
-- Given "/foo/bar" returns "bar"
-- Given "c:\\foo\\bar" returns "bar"
local function basename(s)
	return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

-- タブのカスタマイズ
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)

    -- プロセスに合わせてアイコン表示
	local nerd_icons = {
		nvim = wezterm.nerdfonts.custom_vim,
		vim = wezterm.nerdfonts.custom_vim,
		bash = wezterm.nerdfonts.dev_terminal,
		zsh = wezterm.nerdfonts.dev_terminal,
		ssh = wezterm.nerdfonts.mdi_server,
		top = wezterm.nerdfonts.mdi_monitor,
        docker = wezterm.nerdfonts.dev_docker,
        node = wezterm.nerdfonts.dev_nodejs_small,
	}
    local zoomed = ""
    if tab.active_pane.is_zoomed then
      zoomed = "[Z] "
    end
	local pane = tab.active_pane
	local process_name = basename(pane.foreground_process_name)
	local icon = nerd_icons[process_name]
	local index = tab.tab_index + 1
	local cwd = basename(pane.current_working_dir)
    
    -- 例) 1:project_dir | zsh
	local title = index .. ": " .. cwd .. "  | " .. process_name
	if icon ~= nil then
		title = icon .. "  " .. zoomed .. title
	end
	return {
		{ Text = " " .. title .. " " },
	}
end)

-- 左

local DEFAULT_FG = { Color = '#9a9eab' }
local DEFAULT_BG = { Color = '#333333' }

local SPACE_1 = ' '
local SPACE_3 = '   '

local HEADER_KEY_NORMAL = { Foreground = DEFAULT_FG, Text = '' }
local HEADER_LEADER = { Foreground = { Color = '#ffffff' }, Text = '' }
local HEADER_IME = { Foreground = DEFAULT_FG, Text = 'あ' }

local HEADER_HOST = { Foreground = { Color = '#75b1a9' }, Text = '' }
local HEADER_CWD = { Foreground = { Color = '#92aac7' }, Text = '' }
local HEADER_DATE = { Foreground = { Color = '#ffccac' }, Text = '󱪺' }
local HEADER_TIME = { Foreground = { Color = '#bcbabe' }, Text = '' }
local HEADER_BATTERY = { Foreground = { Color = '#dfe166' }, Text = '' }

local function AddElement(elems, header, str)
  table.insert(elems, { Foreground = header.Foreground })
  table.insert(elems, { Background = DEFAULT_BG })
  table.insert(elems, { Text = header.Text .. SPACE_1 })

  table.insert(elems, { Foreground = DEFAULT_FG })
  table.insert(elems, { Background = DEFAULT_BG })
  table.insert(elems, { Text = str .. SPACE_3 })
end

local function AddIcon(elems, icon)
  table.insert(elems, { Foreground = icon.Foreground })
  table.insert(elems, { Background = DEFAULT_BG })
  table.insert(elems, { Text = SPACE_1 .. icon.Text .. SPACE_3 })
end

local function GetKeyboard(elems, window)
  if window:leader_is_active() then
    AddIcon(elems, HEADER_LEADER)
    return
  end

  AddIcon(elems, window:composition_status() and HEADER_IME or HEADER_KEY_NORMAL)
end

local function LeftUpdate(window, pane)
  local elems = {}

  GetKeyboard(elems, window)

  window:set_left_status(wezterm.format(elems))
end

local function GetHostAndCwd(elems, pane)
  local uri = pane:get_current_working_dir()

  if not uri then
    return
  end

  local cwd_uri = uri:sub(8)
  local slash = cwd_uri:find '/'

  if not slash then
    return
  end

  local host = cwd_uri:sub(1, slash - 1)
  local dot = host:find '[.]'

  AddElement(elems, HEADER_HOST, dot and host:sub(1, dot - 1) or host)
  AddElement(elems, HEADER_CWD, cwd_uri:sub(slash))
end

local function GetDate(elems)
  AddElement(elems, HEADER_DATE, wezterm.strftime '%a %b %-d')
end

local function GetTime(elems)
  AddElement(elems, HEADER_TIME, wezterm.strftime '%H:%M')
end

local function GetBattery(elems, window)
  if not window:get_dimensions().is_full_screen then
    return
  end

  for _, b in ipairs(wezterm.battery_info()) do
    AddElement(elems, HEADER_BATTERY, string.format('%.0f%%', b.state_of_charge * 100))
  end
end

local function RightUpdate(window, pane)
  local elems = {}

  GetHostAndCwd(elems, pane)
  GetDate(elems)
  GetBattery(elems, window)
  GetTime(elems)

  window:set_right_status(wezterm.format(elems))
end

wezterm.on('update-status', function(window, pane)
  LeftUpdate(window, pane)
  RightUpdate(window, pane)
end)

return {
    -- https://wezfurlong.org/wezterm/colorschemes/v/index.html?highlight=VibrantInk#vibrantink
    color_scheme = 'VibrantInk',
    -- 背景透過
    window_background_opacity = 0.91,
    adjust_window_size_when_changing_font_size = false,
    window_close_confirmation = 'AlwaysPrompt',
    animation_fps = 1,
    default_cursor_style = 'BlinkingBlock',
    enable_scroll_bar = true,
    default_prog = default_prog,
    ssh_domains = ssh_domains,
    status_update_interval = 1000,
    visual_bell = {
        fade_in_function = 'EaseIn',
        fade_in_duration_ms = 105,
        fade_out_function = 'EaseOut',
        fade_out_duration_ms = 150,
      },
      colors = {
        visual_bell = '#0A0A0A',
      },
    launch_menu = {
        {
            label = "Zsh",
            args = {"zsh"},
          },
        {
          label = "PowerShell 7",
          args = {"pwsh"},
        },
      },
  };
