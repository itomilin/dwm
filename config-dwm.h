/* See LICENSE file for copyright and license details. */
#include <X11/XF86keysym.h>

/* appearance */
static const unsigned int borderpx       = 1;  /* border pixel of windows */
static const unsigned int snap           = 32; /* snap pixel */
static const unsigned int gappx          = 0; /* gaps between windows */

static const int focusonwheel            = 0;  /* focusonwheel patch nil is disable */

static const unsigned int systraypinning = 0;  /* 0: sloppy systray follows selected monitor, >0: pin systray to monitor X */
static const unsigned int systrayonleft  = 0;  /* 0: systray in the right corner, >0: systray on left of status text */
static const unsigned int systrayspacing = 2;  /* systray spacing */
static const int systraypinningfailfirst = 1;  /* 1: if pinning fails, display systray on the first monitor, False: display systray on the last monitor*/
static const int showsystray             = 1;  /* 0 means no systray */
static const int showbar                 = 1;  /* 0 means no bar */
static const int topbar                  = 1;  /* 0 means bottom bar */

// fonts: ttf-ubuntu-mono-nerd ttf-roboto ttf-dejavu ttf-libetation
// Liberation Mono:style=Bold:size=14:antialias=true
static const char *fonts[]      = { "DejaVu Sans Mono:size=12:bold:antialias=true" };
static const char dmenufont[]   = "DejaVu Sans Mono: size=13:bold:antialias=true";
static const char col_gray1[]   = "#222222";
static const char col_gray2[]   = "#444444";
static const char col_gray3[]   = "#bbbbbb";
static const char col_gray4[]   = "#eeeeee";
static const char col_cyan[]    = "#005577";
static const char col_fuchsia[] = "#FF00FF";
static const char *colors[][3]  = {
    /*               fg         bg         border   */
    [SchemeNorm] = { col_gray3, col_gray1, col_gray2   },
    [SchemeSel]  = { col_gray4, col_cyan,  col_fuchsia },
};

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" };

// get WM_CLASS with cmd (second): xprop WM_CLASS
static const Rule rules[] = {
    // { "Gimp",             NULL,       NULL,       0,            False,     -1 },
    { "pavucontrol",      NULL,       NULL,       0,            True,      -1 },
    { "st-256color",      NULL,       NULL,       1 << 0,       False,     -1 },

    { "firefox",          NULL,       NULL,       1 << 1,       False,     -1 },
    // { "Firefox-esr",      NULL,       NULL,       1 << 1,       False,     -1 },

    { "TelegramDesktop",  NULL,       NULL,       1 << 3,       False,     -1 },
    // { "discord",          NULL,       NULL,       1 << 3,       False,     -1 },

    { "Thunar",           NULL,       NULL,       1 << 4,       False,     -1 },
    { "FileZilla",        NULL,       NULL,       1 << 4,       False,     -1 },
    { "Nsxiv",            NULL,       NULL,       0,            True,      -1 },

    { "Geany",            NULL,       NULL,       1 << 2,       False,     -1 },
    { "Code",             NULL,       NULL,       1 << 2,       False,     -1 },
    { "libreoffice-writer", NULL,     NULL,       1 << 2,       False,     -1 },
    { "libreoffice-calc", NULL,       NULL,       1 << 2,       False,     -1 },
    { "libreoffice-draw", NULL,       NULL,       1 << 2,       False,     -1 },
    { "libreoffice-impress", NULL,    NULL,       1 << 2,       False,     -1 },

    { "steam",            NULL,       NULL,       1 << 5,       False,     -1 },
    { "obs",              NULL,       NULL,       1 << 5,       False,     -1 },
    { "Rustdesk",         NULL,       NULL,       1 << 5,       False,     -1 },

    { "KeePassXC",        NULL,       NULL,       1 << 8,       False,     -1 },
    { "Virt-viewer",      NULL,       NULL,       1 << 7,       False,     -1 },
    { "VirtualBox Manager", NULL,     NULL,       1 << 7,       False,     -1 },
};

/* layout(s) */
static const float mfact        = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster        = 1;    /* number of clients in master area */
static const int resizehints    = 0;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1;    /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
    /* symbol arrange_function */
    { "[]=T", tile    }, /* first entry is default */
    { "><>F", NULL    }, /* no layout function means floating behavior */
    { "[M]",  monocle },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }
#define HOME(rel_path) ("/home/tomilin/"  rel_path)

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-fn", dmenufont, "-nb", col_gray1, "-nf", col_gray3, "-sb", col_cyan, "-sf", col_gray4, NULL };
static const char *termcmd[]  = { HOME(".dwm/st"), NULL };

/* custom */
// control volume (laptop)
static const char *up_volume[]     = { "/usr/bin/amixer", "-c", "0", "--", "sset", "Master", "playback", "2%+", NULL };
static const char *down_volume[]   = { "/usr/bin/amixer", "-c", "0", "--", "sset", "Master", "playback", "2%-", NULL };
static const char *mute_speakers[] = { HOME(".dwm/custom_scripts/amixer_sound.sh"), NULL };
static const char *mute_mic[]      = { "/usr/bin/amixer", "set", "Capture", "toggle", NULL };

// control brightness (laptop)
static const char *inc_light[] = { "/usr/bin/light", "-A", "5", NULL };
static const char *dec_light[] = { "/usr/bin/light", "-U", "5", NULL };

// screenshots
static const char *maim_full[] = { HOME(".dwm/custom_scripts/maim_helper.sh"), "full", NULL };
static const char *maim_area[] = { HOME(".dwm/custom_scripts/maim_helper.sh"), "area", NULL };

// osd time
static const char *osd_time[] = { HOME(".dwm/custom_scripts/osd_time.sh"), NULL };

static const Key keys[] = {
    /* modifier                     key        function        argument */
    { MODKEY|ShiftMask,   XK_c,      killclient,     {0} },
    { MODKEY|ShiftMask,   XK_q,      quit,           {0} },
    { MODKEY,             XK_b,      togglebar,      {0} },

    { Mod1Mask,           XK_grave,  focusstack,    {.i = +1 } },
    { Mod1Mask|ShiftMask, XK_grave,  focusstack,    {.i = -1 } },

    { MODKEY,             XK_p,      spawn,          {.v = dmenucmd } },
    { MODKEY|ShiftMask,   XK_Return, spawn,          {.v = termcmd } },

    { MODKEY,             XK_j,      rotatestack,     {.i = +1 } },
    { MODKEY,             XK_k,      rotatestack,     {.i = -1 } },

    { MODKEY,             XK_h,      setmfact,       {.f = -0.05} },
    { MODKEY,             XK_l,      setmfact,       {.f = +0.05} },

    { MODKEY,             XK_t,      setlayout,      {.v = &layouts[0]} },
    { MODKEY|ShiftMask,   XK_f,      setlayout,      {.v = &layouts[1]} },
    { MODKEY,             XK_m,      setlayout,      {.v = &layouts[2]} },
    { MODKEY,             XK_f,      fullscreen,     {0} },

    { MODKEY|ShiftMask,   XK_comma,  tagmon,         {.i = -1 } },
    { MODKEY|ShiftMask,   XK_period, tagmon,         {.i = +1 } },
    { MODKEY,             XK_comma,  focusmon,       {.i = -1 } },
    { MODKEY,             XK_period, focusmon,       {.i = +1 } },

    { 0,                  XF86XK_AudioLowerVolume,  spawn, {.v = down_volume   } },
    { 0,                  XF86XK_AudioRaiseVolume,  spawn, {.v = up_volume     } },
    { 0,                  XF86XK_AudioMute,         spawn, {.v = mute_speakers } },
    { 0,                  XF86XK_AudioMicMute,      spawn, {.v = mute_mic      } },

    { 0,                  XF86XK_MonBrightnessUp,   spawn, {.v = inc_light     } },
    { 0,                  XF86XK_MonBrightnessDown, spawn, {.v = dec_light     } },

    { Mod1Mask|ShiftMask, XK_4,                     spawn, {.v = maim_full     } },
    { Mod1Mask|ShiftMask, XK_3,                     spawn, {.v = maim_area     } },

    { Mod1Mask|ShiftMask, XK_t,                     spawn, {.v = osd_time      } },

    { Mod4Mask|ShiftMask, XK_space,  togglefloating, {0} },

    TAGKEYS(                        XK_1,                      0)
    TAGKEYS(                        XK_2,                      1)
    TAGKEYS(                        XK_3,                      2)
    TAGKEYS(                        XK_4,                      3)
    TAGKEYS(                        XK_5,                      4)
    TAGKEYS(                        XK_6,                      5)
    TAGKEYS(                        XK_7,                      6)
    TAGKEYS(                        XK_8,                      7)
    TAGKEYS(                        XK_9,                      8)
    TAGKEYS(                        XK_0,                      9)
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
    /* click                event mask      button          function        argument */
    { ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
    { ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
    { ClkWinTitle,          0,              Button2,        zoom,           {0} },
    { ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
    { ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
    // { ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
    { ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
    { ClkTagBar,            0,              Button1,        view,           {0} },
    { ClkTagBar,            0,              Button3,        toggleview,     {0} },
    { ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
    { ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

