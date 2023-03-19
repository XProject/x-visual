fx_version  "cerulean"
use_experimental_fxv2_oal   "yes"
lua54       "yes"
game        "gta5"

name        "x-visual"
version     "1.1.5"
repository  "https://github.com/XProject/x-visual"
description "Project-X Visual: Resource to Modify Visuals & Vehicle Lights' Intensity In-Game & on Runtime"

files {
    "files/*"
}

shared_scripts {
    "shared/*.lua"
}

server_scripts {
    "server/*.lua"
}

client_scripts {
    "shared/config.lua",
    "client/main/main.lua",
    "client/**/*.lua",
    "client/*.lua",
}

escrow_ignore {
    "files/*",
    "shared/*.lua",
    "server/*.lua",
    "client/**/*.lua",
    "client/*.lua",
}