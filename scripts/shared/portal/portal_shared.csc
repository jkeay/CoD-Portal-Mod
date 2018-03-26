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

#insert scripts\shared\portal\portal_shared.gsh;

#namespace portal_core;

function autoexec main()
{
	callback::add_callback(#"on_pre_initialization", &__pre_init__);
	callback::on_finalize_initialization(&__init__);
	callback::on_start_gametype(&__post_init__);
	callback::on_localclient_connect(&__player_connect__);
	callback::on_localplayer_spawned(&__player_spawn__);

	util::register_system(PORTAL_CLIENT_SYSTEM_NAME, &__receive_compat_gsc_messages__);
}

function private __pre_init__()
{
	if(isdefined(level._portal_gametype_pre_init))
		util::single_thread(level, level._portal_gametype_pre_init);
}

function private __init__()
{
	if(isdefined(level._portal_gametype_init))
		util::single_thread(level, level._portal_gametype_init);
}

function private __post_init__()
{
	if(isdefined(level._portal_gametype_post_init))
		util::single_thread(level, level._portal_gametype_post_init);
}

function private __player_connect__(clientnum)
{
}

function private __player_spawn__(clientnum)
{
}

function private __receive_compat_gsc_messages__(clientnum, state, oldState)
{
}
