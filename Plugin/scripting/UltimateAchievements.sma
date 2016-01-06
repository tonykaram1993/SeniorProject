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
#include < sqlx >

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
	This is where you stop. Editing anything below this point
	might lead to some serious errors, and you will not get any
	support if you do.
	
	SAFETY ZONE ENDS HERE
*/

/* Constants */
new const g_strPluginName[ ]		= "UltimateAchievements";
new const g_strPluginVersion[ ]		= PLUGIN_VERSION;
new const g_strPluginAuthor[ ]		= "tonykaram1993";

new const g_strSQLHost[ ]		= "192.168.1.1";
new const g_strSQLUsername[ ]		= "senior_project";
new const g_strSQLPassword[ ]		= "testing123";
new const g_strSQLDatabase[ ]		= "sp_";

/* Strings */
new g_strErrorMessage[ 512 ];

/* SQL Handles */
new Handle:g_sqlTuple;

/* Plugin Natives */
public plugin_init( ) {
	register_plugin( g_strPluginName, g_strPluginVersion, g_strPluginAuthor );
	register_cvar( g_strPluginName, g_strPluginVersion, FCVAR_SERVER | FCVAR_EXTDLL | FCVAR_UNLOGGED | FCVAR_SPONLY );
	
	/* Config Execution */
	ExecConfig( );
	
	register_clcmd( "ENTER_PASSWORD", "ClCmd_PasswordEntry" );
}

public plugin_end( ) {
	SQL_FreeHandle( g_sqlTuple );
}

/* Client Natives */
public client_authorized( iPlayerID ) {
	MySQL_PlayerConnected( iPlayerID );
}

/* ClCmds */
public ClCmd_PasswordEntry( iPlayerID ) {
	new strPassword[ 64 ];
	read_args( strPassword, charsmax( strPassword ) );
	remove_quotes( strPassword );
	
	// TODO: check password validity
	
	ShowPasswordConfirmationMenu( iPlayerID, strPassword );
}

/* MySQL Functions */
MySQL_InitializeConnection( ) {
	// Gather info first, attept to connect to the database and in case of any errors, stop plugin with a fatal error
	g_sqlTuple = SQL_MakeDbTuple( g_strSQLHost, g_strSQLUsername, g_strSQLPassword, g_strSQLDatabase );
	
	new iErrorCode;
	new Handle:sqlConnection = SQL_Connect( g_sqlTuple, iErrorCode, g_strErrorMessage, charsmax( g_strErrorMessage ) );
	
	if( sqlConnection == Empty_Handle ) {
		set_fail_Stats( g_strErrorMessage );
	}
	
	// Free handle so it can be used later on
	SQL_FreeHandle( sqlConnection );
}

MySQL_PlayerConnected( iPlayerID ) {
	// In order to pass the iPlayerID to the query function, we must first change it to
	// a string because to pass an argument for the function, it must be a string
	new strPlayerID[ 1 ];
	strPlayerID[ 0 ] = iPlayerID;
	
	new strPlayerAuthID[ 18 ];
	get_user_authid( iPlayerID, strPlayerAuthID, charsmax( strPlayerAuthID ) );
	
	// Building the query to retreive all info about a the player's steam id
	new strQuery[ 512 ];
	formatex( strQuery, charsmax( strQuery ), "SELECT * FROM `Player` WHERE (`Player`.`SteamID` = '%s')", strPlayerAuthID );
	SQL_ThreadQuery( g_sqlTuple, "PlayerConnected", strQuery, strPlayerID, charsmax( strPlayerID ) );
}

PlayerConnected( iFailState, Handle:hQuery, strErrorMessage[ ], iErrorCode, strData[ ], iDataSize ) {
	// Check for any fail states and display appropriate information in the logs
	if( iFailState == TQUERY_CONNECT_FAILED ) {
		log_amx( "Could not connect to the MySQL Database." );
		log_amx( "[%d] %s", iErrorCode, strErrorMessage );
	} else if( iFailState == TQUERY_QUERY_FAILED ) {
		log_amx( "Query failed." );
		log_amx( "[%d] %s", iErrorCode, strErrorMessage );
	}
	
	// Changing the string playerid to an integer.
	new iPlayerID = strData[ 0 ];
	
	// The following if statement checks if we received any results, if we didn't that means this is the player's first time connecting to a server so we should register him
	// If we did receive a result that means the player has already registered
	// There is no need for the user to enter the password on the server since the steam id is unique and cannot be faked - the password is used only to login on the website
	if( SQL_NumResults( hQuery ) < 1 ) {
		ShowPlayerRegistrationMenu( iPlayerID );
	}
}

/* Other Functions */
ExecConfig( ) {
	// Config file execution, this will execute all the settings/cvars the server admins choose
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

ShowPlayerRegistrationMenu( iPlayerID ) {
	static menuPlayerRegistration;
	
	if( !menuPlayerRegistration ) {
		new strMenuTitle[ 128 ] = "\yAchievement Registration Menu:^n^n\yNote: \wIf you want to access your profile on www.website.com,^nyou must create a password first.^nYou can access this menu later by typing \r/register\w." );
		
		menuPlayerRegistration = menu_create( strMenuTitle, "Handle_PlayerRegistrationMenu" );
		
		menu_additem( menuPlayerRegistration, "\wEnter Password" );
		menu_additem( menuPlayerRegistration, "\wRegister Later" );
		
		menu_setprop( menuPlayerRegistration, MPROP_NUMBER_COLOR, "\y" );
		menu_setprop( menuPlayerRegistration, MPROP_EXIT, MEXIT_NEVER );
	}
	
	menu_display( iPlayerID, menuPlayerRegistration, 0 );
}

public Handle_PlayerRegistrationMenu( iPlayerID, iMenu, iKey ) {
	switch( iKey ) {
		// 0 means the player chose to enter a password
		case 0: {
			client_cmd( iPlayerID, "messagemode ENTER_PASSWORD" );
		}
		
		// 1 means the player chose to enter password later
		case 1: {
			client_print( iPlayerID, print_chat, "[ Achievements ] You have chosen to enter password later. Please type /register later to enter your password." );
		}
	}
}

ShowPasswordConfirmationMenu( iPlayerID, strPassword ) {
	new strMenuTitle[ 128 ];
	formatex( strMenuTitle, charsmax( strMenuTitle ), "\yPassword Confirmation Menu:^n^n\yIs this your password?^n\r%s", strPassword );
	
	new menuPasswordConfirmation = menu_create( strMenuTitle, "Handle_PasswordConfirmationMenu" );
	
	// Add the password as info to the item so we can retrieve the actual password in menu handler
	menu_additem( menuPasswordConfirmation, "\wYes", strPassword );
	menu_additem( menuPasswordConfirmation, "\wNo" );
	
	menu_setprop( menuPasswordConfirmation, MPROP_NUMBER_COLOR, "\y" );
	menu_setprop( menuPasswordConfirmation, MPROP_EXIT, MEXIT_NEVER );
	
	menu_display( iPlayerID, menuPasswordConfirmation, 0 );
}

public Handle_PasswordConfirmationMenu( iPlayerID, iMenu, iKey ) {
	switch( iKey ) {
		// Player has pressed Yes
		case 0: {
			// TODO: save password
		}
		
		// Player has pressed No
		case 1: {
			ShowPlayerRegistrationMenu( iPlayerID );
		}
	}
}