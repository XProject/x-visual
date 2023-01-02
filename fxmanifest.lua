fx_version "cerulean"
use_experimental_fxv2_oal "yes"
lua54 "yes"
game "gta5"

description "x-visual"
version "1.1.0"

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