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

#namespace portal_weapon;

#define PORTAL_FIRED_EVENT_NAME #"on_portal_fired"

// Events
function onPlayerConnect()
{
	self._portal_weapon_fire_state = undefined;

	self thread watchPortalFired();

	// Special logic for firing right portal
	self thread watchPortalFiredRight();
}

function onPlayerDisconnect()
{
	// TODO: Remove any existing portals for this player
}

function onPlayerFiredPortal_Pre(portal_type)
{
	self._portal_weapon_fire_state = portal_type;
	self notify("portal_fired_pre", portal_type);
	self notify("portal_fired_pre_" + portal_type);
	self notify("portal_fired", portal_type);
	self notify("portal_fired_" + portal_type);

	IPrintLnBold("Fired Portal: " + portal_type);
}

function onPlayerFiredPortal_Post(portal_type)
{
	waittillframeend;
	self notify("portal_fired_post", portal_type);
	self notify("portal_fired_post_" + portal_type);
	self._portal_weapon_fire_state = undefined;
}

// Logic
function private watchPortalFired()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("weapon_fired");

		IPrintLnBold("Fire Left -> Attempt");

		if(!isdefined(self._portal_weapon_fire_state) || self._portal_weapon_fire_state != PORTAL_TYPE_LEFT)
			continue;

		IPrintLnBold("Fire Left -> Success");

		self fire_event(&onPlayerFiredPortal_Pre, &onPlayerFiredPortal_Post, PORTAL_FIRED_EVENT_NAME, PORTAL_TYPE_LEFT);
	}
}

function private watchPortalFiredRight()
{
	self endon("disconnect");

	for(;;)
	{
		do
		{
			WAIT_SERVER_FRAME

			IPrintLnBold("Fire Right -> Wait");
		}
		while(self AdsButtonPressed() && !self AttackButtonPressed());

		IPrintLnBold("Fire Right -> Attempt");

		if(!isdefined(self._portal_weapon_fire_state) || self._portal_weapon_fire_state != PORTAL_TYPE_RIGHT)
			continue;

		IPrintLnBold("Fire Right -> Success");

		self fire_event(&onPlayerFiredPortal_Pre, &onPlayerFiredPortal_Post, PORTAL_FIRED_EVENT_NAME, PORTAL_TYPE_RIGHT);

		WAIT_SERVER_FRAME
	}
}

// Util
// TODO: Move to common utility script
function fire_event(core_event_pre, core_event_post, event_name, arg1, arg2, arg3, arg4, arg5, arg6)
{
	// Ensure the core logic executes first
	util::single_func(self, core_event_pre, arg1, arg2, arg3, arg4, arg5, arg6);

	params = SpawnStruct();
	params.arg1 = arg1;
	params.arg2 = arg2;
	params.arg3 = arg3;
	params.arg4 = arg4;
	params.arg5 = arg5;
	params.arg6 = arg6;

	// Allow other scripts to hook into this event
	self callback::callback(event_name, params);

	if(isdefined(core_event_post))
		util::single_func(self, core_event_post, arg1, arg2, arg3, arg4, arg5, arg6);
}

// Callbacks
function on_portal_fired(func, obj)
{
	callback::add_callback(PORTAL_FIRED_EVENT_NAME, func, obj);
}

function remove_on_portal_fired(func, obj)
{
	callback::remove_callback(PORTAL_FIRED_EVENT_NAME, func, obj);
}
