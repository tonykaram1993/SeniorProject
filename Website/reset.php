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
	<link href="css/3-col-portfolio.css" rel="stylesheet">
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
				<li class="active"><a href="profile.php">Profile</a></li>
			</ul>
			<ul class="nav navbar-nav navbar-right">
				<li><a href="sign-up.php"><span class="glyphicon glyphicon-user"></span> Sign Up</a></li>
				<li><a href="login.php"><span class="glyphicon glyphicon-log-in"></span> Login</a></li>
				<li><a href="logout.php"><span class="glyphicon glyphicon-log-out"></span> Logout</a></li>
			</ul>
		</div>
	</nav>
	
	<div class="container">
	    <div class="row">
		<div class="col-sm-6 col-md-4 col-md-offset-4">
		    <?php 
			if( isset( $_SESSION[ "steamid" ] ) ) {
				$strServerIP = "127.0.0.1";
				$strUsername = "website";
				$strPassword = "password";
				
				$sqlConnection = mysqli_connect( $strServerIP, $strUsername, $strPassword );
				
				if( !$sqlConnection ) {
					$strErrorMessage = mysqli_error( );
					
					echo '<div class="alert alert-danger">';
					echo '<strong>Ooops!</strong> <br>It appears that a connection to the database was not successful. Please try again.<br><br>';
					echo 'Error: ' . $strErrorMessage;
					echo '</div>';
				} else {
					$sqlQuery = sprintf( "DELETE FROM Achieves WHERE Achieves.SteamID = '%s';", $_SESSION[ "steamid" ] );
					mysqli_select_db( $sqlConnection, 'ultimateachievements' );
					$sqlResult = mysqli_query( $sqlConnection, $sqlQuery );
					
					echo '<div class="alert alert-success">';
					echo '<strong>Success!</strong> <br>All your achievement progress has been deleted.';
					echo '</div>';
				}
			} else {
				echo '<div class="alert alert-danger">';
				echo '<strong>Ooops!</strong> <br>It appears that you are not logged in. Please login first.';
				echo '</div>';
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