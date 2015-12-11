/*
	AMX Mod X script.

	This plugin is free software; you can redistribute it and/or modify it
	under the terms of the GNU General Public License as published by the
	Free Software Foundation; either version 2 of the License, or (at
	your option) any later version. 
	
	This plugin is distributed in the hope that it will be useful, but
	WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
	General Public License for more details.
	
	You should have received a copy of the GNU General Public License
	along with this plugin; if not, write to the Free Software Foundation,
	Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
*/

/*
	Senior Achievements
	by tonykaram1993
	
	This plugin is an achievements plugin were players can play on the server
	or servers and earn achievements in the process. The player will be asked 
	when he first connects to the server the first to set up a password for his
	account. After that, he can then check the website and login using his 
	steam id and password to check his progress. He can also check out new 
	possible achievements and his ranking among all other players.
	
	All info will be stored in a databse that is both accessed by this plugin
	and the website.
	
	This plugin is a part of a Senior Project created by tonykaram1993 to Notre
	Dame University.
*/

/*
	Change Log:
	
	+ something added/new
	- something removed
	* important note
	x bug fix or improvement
	
	v0.0.1	beta:	* plugin written in beta stage
*/

#define PLUGIN_VERSION		"0.0.1b"

/* Includes */
#include < amxmodx >
#include < amxmisc >

#pragma semicolon 1

/* Defines */
#define SetBit(%1,%2)      		(%1 |= (1<<(%2&31)))
#define ClearBit(%1,%2)    		(%1 &= ~(1 <<(%2&31)))
#define CheckBit(%1,%2)    		(%1 & (1<<(%2&31)))

#define is_user(%1)			(1 <= %1 <= MAX_PLAYERS)

/*
	Below is the section where normal people can safely edit
	its values.
	Please if you don't know how to code, refrain from editing
	anything outside the safety zone.
	
	Experienced coders are free to edit what they want, but I
	will not reply to any private messages nor emails about hel-
	ping you with it.
	
	SAFETY ZONE STARTS HERE
*/

/*
	Set this to your maximum number of players your server can
	hold.
	
	Note: this is not needed in amxmodx 1.8.3 and above.
*/
#if AMXX_VERSION_NUM < 183
	#define MAX_PLAYERS		32
#endif

/*
	This will control whether green messages are shown. Comment
	to disable the colored messages
	Note: prefix is always colored in green
*/
#define COLOR_CHAT		1

/*
	This is where you stop. Editing anything below this point
	might lead to some serious errors, and you will not get any
	support if you do.
	
	SAFETY ZONE ENDS HERE
*/

#if AMXX_VERSION_NUM < 183
enum ( ) {
	print_team_default	= 0,
	print_team_grey		= 33,
	print_team_red,
	print_team_blue
};
#endif

/* Constants */
new const g_strPluginName[ ]		= "UltimateAchievements";
new const g_strPluginVersion[ ]		= PLUGIN_VERSION;
new const g_strPluginAuthor[ ]		= "tonykaram1993";

/* Plugin Natives */
public plugin_init( ) {
	register_plugin( g_strPluginName, g_strPluginVersion, g_strPluginAuthor );
	register_cvar( g_strPluginName, g_strPluginVersion, FCVAR_SERVER | FCVAR_EXTDLL | FCVAR_UNLOGGED | FCVAR_SPONLY );
	
	/* PCVARs */
	
	/* CVAR Pointers */
	
	/* Config Execution */
	ExecConfig( );
	
	/* Load CVARs for the first time */
	ReloadCVARs( );
}

ReloadCVARs( ) {
	/*
		In my opinion, its better to refresh all the cvars on demand and
		caching them instead of getting its value everytime we want it.
		And that way we do not waste useful CPU power.
	*/
}

ExecConfig( ) {
	/* Config File Execution */
	new strConfigDir[ 128 ];
	get_localinfo( "amxx_configsdir", strConfigDir, 127 );
	format( strConfigDir, 127, "%s/%s.cfg", strConfigDir, g_strPluginName );
	
	if( file_exists( strConfigDir ) ) {
		server_cmd( "exec %s", strConfigDir );
		log_amx( "%s configuration file successfully loaded!", g_strPluginName );
		server_exec( );
	} else {
		log_amx( "%s configuration file not found.", g_strPluginName );
		server_exec( );
	}
}