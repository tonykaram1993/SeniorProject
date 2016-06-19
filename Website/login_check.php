<?php 
	session_start( );
?>

<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	
	<title>Ultimate Achievements</title>
	
	<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
	<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
	<link href="css/sticky-footer.css" rel="stylesheet">
</head>
<body>
<div id="background-container" class="container">
	<nav class="navbar navbar-inverse">
		<div class="container-fluid">
			<div class="navbar-header">
				<a class="navbar-brand" href="index.php">Ultimate Achievements</a>
			</div>
			<ul class="nav navbar-nav">
				<li><a href="index.php">Home</a></li>
				<li><a href="achievements.php">Achievements</a></li>
				<li><a href="profile.php">Profile</a></li>
			</ul>
			<ul class="nav navbar-nav navbar-right">
				<li><a href="sign-up.php"><span class="glyphicon glyphicon-user"></span> Sign Up</a></li>
				<li class="active"><a href="login.php"><span class="glyphicon glyphicon-log-in"></span> Login</a></li>
				<li><a href="logout.php"><span class="glyphicon glyphicon-log-out"></span> Logout</a></li>
			</ul>
		</div>
	</nav>

	<div class="container">
	    <div class="row">
		<div class="col-sm-6 col-md-4 col-md-offset-4">
		    <?php 
		        $strUserSteamID = $_POST[ "steamid" ];
			$strUserPassword = $_POST[ "password" ];
			
			$strServerIP = "127.0.0.1";
			$strUsername = "website";
			$strPassword = "password";
			
			$sqlConnection = mysqli_connect( $strServerIP, $strUsername, $strPassword );
			
			if( !$sqlConnection ) {
				$strErrorMessage = mysqli_error( );
				
				echo '<div class="alert alert-danger">';
				echo '<strong>Oooops!</strong> <br><br>It appears that a connection to the database was not successful. Please try again.<br><br>';
				echo 'Error: ' . $strErrorMessage;
				echo '</div>';
			} else {
				$sqlQuery = sprintf( "SELECT * FROM Player WHERE Player.SteamID = '%s';", $strUserSteamID );
				mysqli_select_db( $sqlConnection, 'ultimateachievements' );
				$sqlResult = mysqli_query( $sqlConnection, $sqlQuery );
				
				if( $sqlResult && mysqli_num_rows( $sqlResult ) > 0 ) {
					$row = mysqli_fetch_array( $sqlResult, MYSQL_ASSOC );
					
					$strDatabaseUserPassword = $row[ "Password" ];
					$strDatabaseUserSalt = $row[ "Salt" ];
					
					$strToHash = sprintf( "%s%s", $strUserPassword, $strDatabaseUserSalt );
					
					if( md5( $strToHash ) == $strDatabaseUserPassword ) {
						$_SESSION[ "steamid" ] = $strUserSteamID;
						
						echo '<div class="alert alert-success">';
						echo '<strong>Sucess!</strong> <br><br>You have been successfully logged in.<br>';
						echo 'You can now check your <a href="profile.php">profile</a>.';
						echo '</div>';
					} else {
						echo '<div class="alert alert-danger">';
						echo '<strong>Ooops!</strong> <br><br>It appears there are no records of the SteamID and Password combination that you provided in the database.<br><br>';
						echo 'Please try again or <a href="sign-up.php">Sign UP</a>.';
						echo '</div>';
					}
				} else {
					echo '<div class="alert alert-danger">';
					echo '<strong>Ooops!</strong> <br><br>It appears there are no records of the SteamID and Password combination that you provided in the database.<br><br>';
					echo 'Please try again or <a href="sign-up.php">Sign UP</a>.';
					echo '</div>';
				}
				
			}
		    ?>
		</div>
	    </div>
	</div>

	<footer class="footer">
		<div class="container">
			<br>
			
			<p class="text-muted">Copyright &copy; Tony Karam 2016</p>
		</div>
	</footer>
</div>
</body>
</html>