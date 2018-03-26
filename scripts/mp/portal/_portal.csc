#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;
#using scripts\shared\portal\portal_shared;

#insert scripts\shared\portal\portal_shared.gsh;

#namespace portal_multiplayer;

function autoexec main()
{
	level._portal_gametype_init = &__init__;
}

function __init__()
{
}
