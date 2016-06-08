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

/* Includes */
#include < amxmodx >
#include < amxmisc >
#include < sqlx >
#include < string >
#include < hamsandwich >

#pragma semicolon 1

/* Defines */
#define SetBit(%1,%2)      		(%1 |= (1<<(%2&31)))
#define ClearBit(%1,%2)    		(%1 &= ~(1 <<(%2&31)))
#define CheckBit(%1,%2)    		(%1 & (1<<(%2&31)))

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

#define MAX_PLAYERS			32

/*
	This is where you stop. Editing anything below this point
	might lead to some serious errors, and you will not get any
	support if you do.
	
	SAFETY ZONE ENDS HERE
*/

/* Enumerations */
enum _:ACHIEVEMENT_MAX( ) {
	ACHIEVEMENT_AWARDIST		= 1,	ACHIEVEMENT_PROMOTED,
	ACHIEVEMENT_BOMB_EXPERT,		ACHIEVEMENT_DEFUSAL_EXPERT,
	ACHIEVEMENT_CLUTCH_MASTER,		ACHIEVEMENT_WAR_BONDS,			ACHIEVEMENT_SPENDING_SPREE,		ACHIEVEMENT_ACE_MASTER,			ACHIEVEMENT_BODY_BAGUER,		ACHIEVEMENT_BATTLE_SIGHT_ZERO,		ACHIEVEMENT_POINTS_IN_YOUR_FAVOR,	ACHIEVEMENT_MAKE_THE_CUT,		ACHIEVEMENT_SOMEONE_SET_US_BOMB,	ACHIEVEMENT_RITE_OF_FIRST_DEFUSAL,	ACHIEVEMENT_GIVE_PIECE_A_CHANCE
};

enum _:ACHIEVEMENT_COLUMN_MAX( ) {
	ACHIEVEMENT_COLUMN_ID		= 0,
	ACHIEVEMENT_COLUMN_NAME,
	ACHIEVEMENT_COLUMN_DESCRIPTION,
	ACHIEVEMENT_COLUMN_GOAL
};

enum _:PLAYER_COLUMN_MAX( ) {
	PLAYER_COLUMN_STEAMID		= 0,
	PLAYER_COLUMN_FIRST_NAME,
	PLAYER_COLUMN_LAST_NAME,
	PLAYER_COLUMN_PASSWORD,
	PLAYER_COLUMN_SALT
};

enum _:ACHIEVES_COLUMN_MAX( ) {
	ACHIEVES_COLUMN_STEAMID		= 0,
	ACHIEVES_COLUMN_ID,
	ACHIEVES_COLUMN_PROGRESS,
	ACHIEVES_COLUMN_ACQUIRED
};

/* Constants */
new const g_strPluginName[ ]		= "UltimateAchievements";
new const g_strPluginVersion[ ]		= "0.0.1b";
new const g_strPluginAuthor[ ]		= "tonykaram1993";

new const g_strSQLHost[ ]		= "127.0.0.1";
new const g_strSQLUsername[ ]		= "admin";
new const g_strSQLPassword[ ]		= "password";
new const g_strSQLDatabase[ ]		= "ultimateachievements";

/* Arrays */
new g_strPlayerPassword[ MAX_PLAYERS ][ 64 ];
new g_strPlayerFirstName[ MAX_PLAYERS ][ 64 ];
new g_strPlayerLastName[ MAX_PLAYERS ][ 64 ];
new g_strPlayerSalt[ MAX_PLAYERS ][ 16 ];

new g_iPlayerAchievementProgress[ MAX_PLAYERS ][ ACHIEVEMENT_MAX ];
new g_iAchievementGoal[ ACHIEVEMENT_MAX ];

new bool:g_bPlayerAchievementAcquired[ MAX_PLAYERS ][ ACHIEVEMENT_MAX ];

/* Strings */
new g_strErrorMessage[ 512 ];

/* Bitsums */
new g_bitIsLoggedIn;
new g_bitIsRegistered;

new Handle:g_sqlTuple;

/* Plugin Natives */
public plugin_init( ) {
	register_plugin( g_strPluginName, g_strPluginVersion, g_strPluginAuthor );
	register_cvar( g_strPluginName, g_strPluginVersion, FCVAR_SERVER | FCVAR_EXTDLL | FCVAR_UNLOGGED | FCVAR_SPONLY );
	
	register_clcmd( "REGISTER_PASSWORD", "ClCmd_RegisterPassword" );
	register_clcmd( "LOGIN_PASSWORD", "ClCmd_LoginPassword" );
	register_clcmd( "FIRST_NAME", "ClCmd_FirstName" );
	register_clcmd( "LAST_NAME", "ClCmd_LastName" );
	
	register_clcmd( "say /register", "ClCmd_RegisterMenu" );
	register_clcmd( "say /login", "ClCmd_LoginMenu" );
	register_clcmd( "say /logout", "ClCmd_LogoutMenu" );
	
	register_clcmd( "say_team /register", "ClCmd_RegisterMenu" );
	register_clcmd( "say_team /login", "ClCmd_LoginMenu" );
	register_clcmd( "say_team /logout", "ClCmd_LogoutMenu" );
	
	RegisterHam( Ham_Spawn, "player", "Ham_Spawn_Player_Post", true );
	
	set_task( 0.1, "MySQL_InitializeConnection" );
}

public plugin_end( ) {
	// Free Handle to prevent any errors
	SQL_FreeHandle( g_sqlTuple );
}

/* Client Natives */
public client_authorized( iPlayerID ) {
	ClearBit( g_bitIsLoggedIn, iPlayerID );
	ClearBit( g_bitIsRegistered, iPlayerID );
	
	g_strPlayerFirstName[ iPlayerID ] = "";
	g_strPlayerLastName[ iPlayerID ] = "";
	
	ClearPlayerAchievementProgress( iPlayerID );
	
	MySQL_PlayerConnected( iPlayerID );
}

public client_disconnected( iPlayerID ) {
	MySQL_SavePlayerStats( iPlayerID );
}

/* ClCmds */
public ClCmd_RegisterPassword( iPlayerID ) {
	new strPassword[ 64 ];
	read_args( strPassword, charsmax( strPassword ) );
	remove_quotes( strPassword );
	
	ShowPasswordConfirmationMenu( iPlayerID, strPassword );
}

public ClCmd_LoginPassword( iPlayerID ) {
	new strPassword[ 64 ];
	read_args( strPassword, charsmax( strPassword ) );
	remove_quotes( strPassword );
	
	g_strPlayerPassword[ iPlayerID ] = strPassword;
	
	MySQL_GetPlayerInfo( iPlayerID );
}

public ClCmd_FirstName( iPlayerID ) {
	new strFirstName[ 64 ];
	read_args( strFirstName, charsmax( strFirstName ) );
	remove_quotes( strFirstName );
	
	g_strPlayerFirstName[ iPlayerID ] = strFirstName;
	
	ShowPlayerRegistrationMenu( iPlayerID );
}

public ClCmd_LastName( iPlayerID ) {
	new strLastName[ 64 ];
	read_args( strLastName, charsmax( strLastName ) );
	remove_quotes( strLastName );
	
	g_strPlayerLastName[ iPlayerID ] = strLastName;
	
	ShowPlayerRegistrationMenu( iPlayerID );
}

public ClCmd_RegisterMenu( iPlayerID ) {
	if( CheckBit( g_bitIsRegistered, iPlayerID ) ) {
		client_print( iPlayerID, print_chat, "[ Achievements ] You are already registered. You cannot register twice." );
	} else {
		ShowPlayerRegistrationMenu( iPlayerID );
	}
}

public ClCmd_LoginMenu( iPlayerID ) {
	if( CheckBit( g_bitIsLoggedIn, iPlayerID ) ) {
		client_print( iPlayerID, print_chat, "[ Achievements ] You are already logged in. You cannot log in twice." );
	} else {
		if( CheckBit( g_bitIsRegistered, iPlayerID ) ) {
			ShowPlayerLogInMenu( iPlayerID );
		} else {
			client_print( iPlayerID, print_chat, "[ Achievements ] You have to be registered first to login. Please type /register to do so." );
		}
	}
}

public ClCmd_LogoutMenu( iPlayerID ) {
	if( CheckBit( g_bitIsLoggedIn, iPlayerID ) ) {
		ClearBit( g_bitIsLoggedIn, iPlayerID );
		
		client_print( iPlayerID, print_chat, "[ Achievements ] You are now logged out. Your progress will not be saved." );
		client_print( iPlayerID, print_chat, "[ Achievements ] If you want your progress to be saved, please log back in." );
		
		MySQL_SavePlayerStats( iPlayerID );
	} else {
		client_print( iPlayerID, print_chat, "[ Achievements ] You are not even logged in. You have to login first in order to logout." );
	}
}

/* Ham Hooks */
public Ham_Spawn_Player_Post( iPlayerID ) {
	if( !is_user_alive( iPlayerID ) ) {
		return HAM_IGNORED;
	}
	
	if( CheckBit( g_bitIsRegistered, iPlayerID ) ) {
		client_print( iPlayerID, print_chat, "[ Achievements ] Please type /login to login." );
	} else {
		client_print( iPlayerID, print_chat, "[ Achievements ] Please type /register to register." );
	}
	
	return HAM_IGNORED;
}

/* MySQL Functions */
public MySQL_InitializeConnection( ) {
	// Save info in tuple
	g_sqlTuple = SQL_MakeDbTuple( g_strSQLHost, g_strSQLUsername, g_strSQLPassword, g_strSQLDatabase );
	
	// Connect and return approriate info
	new iErrorCode;
	new Handle:sqlConnection = SQL_Connect( g_sqlTuple, iErrorCode, g_strErrorMessage, charsmax( g_strErrorMessage ) );
	
	// Stop plugin with sql error message if connection was not successful
	if( sqlConnection == Empty_Handle ) {
		set_fail_state( g_strErrorMessage );
	}
	
	// If all goes right, free handle to be used later on
	SQL_FreeHandle( sqlConnection );
	
	MySQL_GetAchievementGoals( );
}

MySQL_GetAchievementGoals( ) {
	new strQuery[ 512 ];
	formatex( strQuery, charsmax( strQuery ), "SELECT * FROM Achievement;" );
	
	SQL_ThreadQuery( g_sqlTuple, "MySQL_Answer_GetAchievementGoals", strQuery );
}

public MySQL_Answer_GetAchievementGoals( iFailState, Handle:hQuery, strErrorMessage[ ], iErrorCode, strData[ ], iDataSize ) {
	if( iFailState == TQUERY_CONNECT_FAILED ) {
		log_amx( "Could not connect to the MySQL Database." );
		log_amx( "[%d] %s", iErrorCode, strErrorMessage );
	} else if( iFailState == TQUERY_QUERY_FAILED ) {
		log_amx( "Query Failed" );
		log_amx( "[%d] %s", iErrorCode, strErrorMessage );
	} else {
		if( !SQL_NumResults( hQuery ) ) {
			set_fail_state( "It appears that there are no Achievements in the Database. Stopping plugin." );
		} else {
			new iID, iGoal;
			
			for( new iLoop = 0; iLoop < SQL_NumResults( hQuery ); iLoop++ ) {
				iID = SQL_ReadResult( hQuery, ACHIEVEMENT_COLUMN_ID );
				iGoal = SQL_ReadResult( hQuery, ACHIEVEMENT_COLUMN_GOAL );
				
				g_iAchievementGoal[ iID ] = iGoal;
			}
		}
	}
	
	SQL_FreeHandle( hQuery );
}

MySQL_PlayerConnected( iPlayerID ) {
	new strPlayerID[ 1 ];
	strPlayerID[ 0 ] = iPlayerID;
	
	new strPlayerAuthID[ 36 ];
	get_user_authid( iPlayerID, strPlayerAuthID, charsmax( strPlayerAuthID ) );
	
	new strQuery[ 512 ];
	formatex( strQuery, charsmax( strQuery ), "SELECT * FROM Player WHERE Player.SteamID = '%s'", strPlayerAuthID );
	
	SQL_ThreadQuery( g_sqlTuple, "MySQL_Answer_PlayerConnected", strQuery, strPlayerID, sizeof( strPlayerID ) );
}

public MySQL_Answer_PlayerConnected( iFailState, Handle:hQuery, strErrorMessage[ ], iErrorCode, strPlayerID[ ], iSize ) {
	new iPlayerID = strPlayerID[ 0 ];
	
	if( iFailState == TQUERY_CONNECT_FAILED ) {
		log_amx( "Could not connect to the MySQL Database." );
		log_amx( "[%d] %s", iErrorCode, strErrorMessage );
	} else if( iFailState == TQUERY_QUERY_FAILED ) {
		log_amx( "Query failed" );
		log_amx( "[%d] %s", iErrorCode, strErrorMessage );
	} else {
		if( SQL_NumResults( hQuery ) ) {
			SetBit( g_bitIsRegistered, iPlayerID );
		}
	}
	
	SQL_FreeHandle( hQuery );
}

MySQL_RegisterPlayer( iPlayerID, strPassword[ ] ) {
	new strPlayerID[ 1 ];
	strPlayerID[ 0 ] = iPlayerID;
	
	new strPlayerAuthID[ 36 ];
	get_user_authid( iPlayerID, strPlayerAuthID, charsmax( strPlayerAuthID ) );
	
	new strSalt[ 16 ];
	GenerateRandomString( strSalt, charsmax( strSalt ) );
	
	new strHashedPassword[ 34 ];
	HashPassword( strHashedPassword, sizeof( strHashedPassword ), strPassword, strSalt );
	
	new strQuery[ 512 ];
	formatex( strQuery, charsmax( strQuery ), "INSERT INTO Player ( SteamID, FirstName, LastName, Password, Salt ) VALUES ( '%s', '%s', '%s', '%s', '%s' );", strPlayerAuthID, g_strPlayerFirstName[ iPlayerID ], g_strPlayerLastName[ iPlayerID ], strHashedPassword, strSalt );
	
	SQL_ThreadQuery( g_sqlTuple, "MySQL_Answer_RegisterPlayer", strQuery, strPlayerID, sizeof( strPlayerID ) );
}

public MySQL_Answer_RegisterPlayer( iFailState, Handle:hQuery, strErrorMessage[ ], iErrorCode, strData[ ], iDataSize ) {
	new iPlayerID = strData[ 0 ];
	
	if( iFailState == TQUERY_CONNECT_FAILED ) {
		log_amx( "Could not connect to the MySQL Database." );
		log_amx( "[%d] %s", iErrorCode, strErrorMessage );
		
		client_print( iPlayerID, print_chat, "[ Achievements ] There has been a problem registering your password. Please try again" );
	} else if( iFailState == TQUERY_QUERY_FAILED ) {
		log_amx( "Query failed" );
		log_amx( "[%d] %s", iErrorCode, strErrorMessage );
		
		client_print( iPlayerID, print_chat, "[ Achievements ] There has been a problem registering your password. Please try again" );
	} else {
		SetBit( g_bitIsRegistered, iPlayerID );
		
		client_print( iPlayerID, print_chat, "[ Achievements ] You have been successfully registered." );
		client_print( iPlayerID, print_chat, "[ Achievements ] Please type /login to login." );
	}
	
	SQL_FreeHandle( hQuery );
}

MySQL_GetPlayerInfo( iPlayerID ) {
	new strPlayerID[ 1 ];
	strPlayerID[ 0 ] = iPlayerID;
	
	new strPlayerAuthID[ 36 ];
	get_user_authid( iPlayerID, strPlayerAuthID, charsmax( strPlayerAuthID ) );
	
	new strQuery[ 512 ];
	formatex( strQuery, charsmax( strQuery ), "SELECT * FROM Player WHERE ( Player.SteamID = '%s' )", strPlayerAuthID );
	
	SQL_ThreadQuery( g_sqlTuple, "MySQL_Answer_GetPlayerInfo", strQuery, strPlayerID, sizeof( strPlayerID ) );
}

public MySQL_Answer_GetPlayerInfo( iFailState, Handle:hQuery, strErrorMessage[ ], iErrorCode, strData[ ], iDataSize ) {
	new iPlayerID = strData[ 0 ];
	
	if( iFailState == TQUERY_CONNECT_FAILED ) {
		log_amx( "Could not connect to the MySQL Database." );
		log_amx( "[%d] %s", iErrorCode, strErrorMessage );
		
		client_print( iPlayerID, print_chat, "[ Achievements ] There has been a problem connecting to the database. Please try again." );
	} else if( iFailState == TQUERY_QUERY_FAILED ) {
		log_amx( "Query Failed" );
		log_amx( "[%d] %s", iErrorCode, strErrorMessage );
		
		client_print( iPlayerID, print_chat, "[ Achievements ] It seems that you are not registered. Please register first." );
	}
	
	new strPlayerHashedPassword[ 34 ];
	
	SQL_ReadResult( hQuery, PLAYER_COLUMN_PASSWORD, strPlayerHashedPassword, charsmax( strPlayerHashedPassword ) );
	SQL_ReadResult( hQuery, PLAYER_COLUMN_SALT, g_strPlayerSalt[ iPlayerID ], charsmax( g_strPlayerSalt[ ] ) );
	
	CheckPasswordValidity( iPlayerID, strPlayerHashedPassword );
	
	SQL_FreeHandle( hQuery );
}

MySQL_GetPlayerStats( iPlayerID ) {
	new strPlayerID[ 1 ];
	strPlayerID[ 0 ] = iPlayerID;
	
	new strPlayerAuthID[ 36 ];
	get_user_authid( iPlayerID, strPlayerAuthID, charsmax( strPlayerAuthID ) );
	
	new strQuery[ 512 ];
	formatex( strQuery, charsmax( strQuery ), "SELECT * From Achieves WHERE ( Achieves.SteamID = '%s' )", strPlayerAuthID );
	
	SQL_ThreadQuery( g_sqlTuple, "MySQL_Answer_GetPlayerStats", strQuery, strPlayerID, sizeof( strPlayerID ) );
}

public MySQL_Answer_GetPlayerStats( iFailState, Handle:hQuery, strErrorMessage[ ], iErrorCode, strData[ ], iDataSize ) {
	new iPlayerID = strData[ 0 ];
	
	if( iFailState == TQUERY_CONNECT_FAILED ) {
		log_amx( "Could not connect to the MySQL Database." );
		log_amx( "[%d] %s", iErrorCode, strErrorMessage );
		
		client_print( iPlayerID, print_chat, "[ Achievements ] There has been a problem connecting to the database. Please try again." );
	} else if( iFailState == TQUERY_QUERY_FAILED ) {
		log_amx( "Query Failed" );
		log_amx( "[%d] %s", iErrorCode, strErrorMessage );
		
		client_print( iPlayerID, print_chat, "[ Achievements ] There has been a problem retrieving your stats. Please try again." );
	} else {
		if( !SQL_NumResults( hQuery ) ) {
			MySQL_InsertPlayerAchieves( iPlayerID );
		} else {
			new iID, iProgress;
			
			for( new iLoop = 0; iLoop < SQL_NumResults( hQuery ); iLoop++ ) {
				iID = SQL_ReadResult( hQuery, ACHIEVES_COLUMN_ID );
				iProgress = SQL_ReadResult( hQuery, ACHIEVES_COLUMN_PROGRESS );
				
				g_iPlayerAchievementProgress[ iPlayerID ][ iID ] = iProgress;
			}
		}
	}
	
	SQL_FreeHandle( hQuery );
}

MySQL_InsertPlayerAchieves( iPlayerID ) {
	new strPlayerID[ 1 ];
	strPlayerID[ 0 ] = iPlayerID;
	
	new strPlayerAuthID[ 36 ];
	get_user_authid( iPlayerID, strPlayerAuthID, charsmax( strPlayerAuthID ) );
	
	new strQuery[ 2048 ] = "";

	for( new iLoop = 1; iLoop < ACHIEVEMENT_MAX; iLoop++ ) {
		format( strQuery, charsmax( strQuery ), "%s INSERT INTO Achieves ( SteamID, ID, Progress, Acquired ) VALUES ( '%s', %d, 0, false );", strQuery, strPlayerAuthID, iLoop );
	}
	
	SQL_ThreadQuery( g_sqlTuple, "MySQL_Answer_InsertPlayerStats", strQuery, strPlayerID, sizeof( strPlayerID ) );
}

public MySQL_Answer_InsertPlayerStats( iFailState, Handle:hQuery, strErrorMessage[ ], iErrorCode, strData[ ], iDataSize ) {
	new iPlayerID = strData[ 0 ];
	
	if( iFailState == TQUERY_CONNECT_FAILED ) {
		log_amx( "Could not connect to the MySQL Database." );
		log_amx( "[%d] %s", iErrorCode, strErrorMessage );
		
		client_print( iPlayerID, print_chat, "[ Achievements ] There has been a problem connecting to the database. Please try again." );
	} else if( iFailState == TQUERY_QUERY_FAILED ) {
		log_amx( "Query Failed" );
		log_amx( "[%d] %s", iErrorCode, strErrorMessage );
		
		client_print( iPlayerID, print_chat, "[ Achievements ] There has been a problem inserting your stats. Please try again." );
	} else {
		client_print( iPlayerID, print_chat, "[ Achievements ] Your stats has been inserted into our database. Start playing to increase your stats." );
	}
	
	SQL_FreeHandle( hQuery );
}

MySQL_SavePlayerStats( iPlayerID ) {
	new strPlayerID[ 1 ];
	strPlayerID[ 0 ] = iPlayerID;
	
	new strPlayerAuthID[ 36 ];
	get_user_authid( iPlayerID, strPlayerAuthID, charsmax( strPlayerAuthID ) );
	
	new strQuery[ 4096 ] = "";
	new iProgress;
	
	
	for( new iLoop = 1; iLoop < ACHIEVEMENT_MAX; iLoop++ ) {
		iProgress = g_iPlayerAchievementProgress[ iPlayerID ][ iLoop ];
		
		format( strQuery, charsmax( strQuery ), "%s UPDATE Achieves SET Achieves.Progress = %d, Achieves.Acquired = %d WHERE Achieves.SteamID = '%s' AND Achieves.ID = %d;", strQuery, iProgress, ( g_bPlayerAchievementAcquired[ iLoop ] ) ? 1 : 0, strPlayerAuthID, iLoop );
	}
	
	SQL_ThreadQuery( g_sqlTuple, "MySQL_Answer_SavePlayerStats", strQuery, strPlayerID, sizeof( strPlayerID ) );
}

public MySQL_Answer_SavePlayerStats( iFailState, Handle:hQuery, strErrorMessage[ ], iErrorCode, strData[ ], iDataSize ) {
	if( iFailState == TQUERY_CONNECT_FAILED ) {
		log_amx( "Could not connect to the MySQL Database." );
		log_amx( "[%d] %s", iErrorCode, strErrorMessage );
	} else if( iFailState == TQUERY_QUERY_FAILED ) {
		log_amx( "Query Failed" );
		log_amx( "[%d] %s", iErrorCode, strErrorMessage );
	}
	
	SQL_FreeHandle( hQuery );
}

/* Menus */
ShowPlayerLogInMenu( iPlayerID ) {
	static menuPlayerLogIn;
	
	if( !menuPlayerLogIn ) {
		new strMenuTitle[ 128 ] = "\yAchievement Log In Menu:^n^n\yNote: \wIf you are not logged in,^nyour progress will not be saved.";
		
		menuPlayerLogIn = menu_create( strMenuTitle, "Handle_PlayerLogInMenu" );
		
		menu_additem( menuPlayerLogIn, "\wEnter Password" );
		menu_additem( menuPlayerLogIn, "\wLog In Later" );
		
		menu_setprop( menuPlayerLogIn, MPROP_NUMBER_COLOR, "\y" );
		menu_setprop( menuPlayerLogIn, MPROP_EXIT, MEXIT_NEVER );
	}
	
	menu_display( iPlayerID, menuPlayerLogIn, 0 );
}

public Handle_PlayerLogInMenu( iPlayerID, iMenu, iKey ) {
	switch( iKey ) {
		case 0: {
			client_cmd( iPlayerID, "messagemode LOGIN_PASSWORD" );
		}
		
		case 1: {
			client_print( iPlayerID, print_chat, "[ Achievements ] You have chosen to login later. You can type /login to login later on." );
		}
	}
}

ShowPlayerRegistrationMenu( iPlayerID ) {
	static menuPlayerRegistration;
	
	if( !menuPlayerRegistration ) {
		new strMenuTitle[ 128 ] = "\yAchievement Registration Menu:^n^n\yNote: \wIf you want your progress to be tracked,^nyou must register first.";
	
		menuPlayerRegistration = menu_create( strMenuTitle, "Handle_PlayerRegistrationMenu" );
		
		menu_additem( menuPlayerRegistration, "\wEnter Password" );
		menu_additem( menuPlayerRegistration, "\wEnter First Name" );
		menu_additem( menuPlayerRegistration, "\wEnter Last Name" );
		
		menu_additem( menuPlayerRegistration, "\wRegister Later" );
		
		menu_setprop( menuPlayerRegistration, MPROP_NUMBER_COLOR, "\y" );
		menu_setprop( menuPlayerRegistration, MPROP_EXIT, MEXIT_NEVER );
	}
	
	menu_display( iPlayerID, menuPlayerRegistration, 0 );
}

public Handle_PlayerRegistrationMenu( iPlayerID, iMenu, iKey ) {
	switch( iKey ) {
		case 0: {
			if( equal( g_strPlayerFirstName[ iPlayerID ], "" ) || equal( g_strPlayerLastName[ iPlayerID ], "" ) ) {
				client_print( iPlayerID, print_chat, "[ Achievements ] Please input your First Name and Last Name before entering your password." );
				
				ShowPlayerRegistrationMenu( iPlayerID );
			} else {
				client_cmd( iPlayerID, "messagemode REGISTER_PASSWORD" );
			}
		}
		
		case 1: {
			client_cmd( iPlayerID, "messagemode FIRST_NAME" );
		}
		
		case 2: {
			client_cmd( iPlayerID, "messagemode LAST_NAME" );
		}
		
		case 3: {
			client_print( iPlayerID, print_chat, "[ Achievements ] You have chosen to register later. You can type /register to register later on." );
		}
	}
}

ShowPasswordConfirmationMenu( iPlayerID, strPassword[ ] ) {
	new strMenuTitle[ 128 ];
	formatex( strMenuTitle, charsmax( strMenuTitle ), "\yPassword Confirmation Menu:^n^n\yIs this your password?^n\r%s", strPassword );
	
	new menuPasswordConfirmation = menu_create( strMenuTitle, "Handle_PasswordConfirmationMenu" );
	
	menu_additem( menuPasswordConfirmation, "\wYes", strPassword );
	menu_additem( menuPasswordConfirmation, "\wNo", "" );
	
	menu_setprop( menuPasswordConfirmation, MPROP_NUMBER_COLOR, "\y" );
	menu_setprop( menuPasswordConfirmation, MPROP_EXIT, MEXIT_NEVER );
	
	menu_display( iPlayerID, menuPasswordConfirmation, 0 );
}

public Handle_PasswordConfirmationMenu( iPlayerID, iMenu, iKey ) {
	new strPassword[ 64 ], strAction[ 32 ], iAccess, iCallBack;
	menu_item_getinfo( iMenu, iKey, iAccess, strPassword, charsmax( strPassword ), strAction, charsmax( strAction ), iCallBack );
	
	switch( iKey ) {
		case 0: {
			MySQL_RegisterPlayer( iPlayerID, strPassword );
		}
		
		case 1: {
			ShowPlayerRegistrationMenu( iPlayerID );
		}
	}
}

/* Other Functions */
GenerateRandomString( strSalt[ ], iSaltSize ) {
	new strAlphabet[ ] = "abcdefghijklmnopqrstuvwxyz";
	new strNumbers[ ] = "0123456789";
	
	for( new iLoop = 0; iLoop < iSaltSize; iLoop++ ) {
		if( random_num( 0, 1 ) ) {
			strSalt[ iLoop ] = strNumbers[ random_num( 0, 9 ) ];
		} else {
			strSalt[ iLoop ] = strAlphabet[ random_num( 0, 25 ) ];
			
			if( random_num( 0, 1 ) ) {
				strSalt[ iLoop ] = char_to_upper( strSalt[ iLoop ] );
			}
		}
	}
}

HashPassword( strHashedPassword[ ], iHashedPasswordSize, strPassword[ ], strSalt[ ] ) {
	new strString[ 128 ];
	formatex( strString, charsmax( strString ), "%s%s", strPassword, strSalt );
	
	hash_string( strString, Hash_Md5, strHashedPassword, iHashedPasswordSize - 1 );
}

CheckPasswordValidity( iPlayerID, strPlayerHashedPassword[ ] ) {
	new strHashedPassword[ 34 ];
	HashPassword( strHashedPassword, sizeof( strHashedPassword ), g_strPlayerPassword[ iPlayerID ], g_strPlayerSalt[ iPlayerID ] );
	
	if( equal( strHashedPassword, strPlayerHashedPassword ) ) {
		SetBit( g_bitIsLoggedIn, iPlayerID );
		
		client_print( iPlayerID, print_chat, "[ Achievements ] You have been logged in. Your progress will now be saved automatically." );
		
		MySQL_GetPlayerStats( iPlayerID );
	} else {
		client_print( iPlayerID, print_chat, "[ Achievements ] The password you inputted is incorrect. Please try again." );
	}
	
	ClearPlayerData( iPlayerID );
}

ClearPlayerData( iPlayerID ) {
	g_strPlayerPassword[ iPlayerID ] = "^0";
	g_strPlayerSalt[ iPlayerID ] = "^0";
}

ClearPlayerAchievementProgress( iPlayerID ) {
	for( new iLoop = 0; iLoop < ACHIEVEMENT_MAX; iLoop++ ) {
		g_iPlayerAchievementProgress[ iPlayerID ][ iLoop ] = 0;
		g_bPlayerAchievementAcquired[ iPlayerID ][ iLoop ] = false;
	}
}

/*
	Notepad++ v6.9
	Style Configuration:	C++
	Font:			Consolas
	Font size:		10
	Indent Tab:		8 spaces
*/