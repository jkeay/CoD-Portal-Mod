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

#using scripts\shared\portal\portal_weapon;

#insert scripts\shared\portal\portal_shared.gsh;

#namespace portal_core;

function autoexec main()
{
	callback::add_callback(#"on_pre_initialization", &__pre_init__);
	callback::add_callback(#"on_finalize_initialization", &__init__);
	callback::add_callback(#"on_start_gametype", &__post_init__);
	callback::on_connect(&__player_connect__);
	callback::on_spawned(&__player_spawn__);
	callback::on_disconnect(&__player_disconnect__);

	util::registerClientSys(PORTAL_CLIENT_SYSTEM_NAME);
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

function private __player_connect__()
{
	self portal_weapon::onPlayerConnect();
}

function private __player_spawn__()
{
}

function private __player_disconnect__()
{
	self portal_weapon::onPlayerDisconnect();
}
