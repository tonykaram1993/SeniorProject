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
		<h1 class="page-header">Profile</h1>
		<p>
			<?php 
				if( isset( $_SESSION[ "steamid" ] ) ) {
					$strSteamID = $_SESSION[ "steamid" ];
					
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
						$sqlQuery = sprintf( "SELECT * FROM Player WHERE Player.SteamID = '%s';", $strSteamID );
						mysqli_select_db( $sqlConnection, 'ultimateachievements' );
						$sqlResult = mysqli_query( $sqlConnection, $sqlQuery );
						
						if( $sqlResult && mysqli_num_rows( $sqlResult ) > 0 ) {
							$row = mysqli_fetch_array( $sqlResult, MYSQL_ASSOC );
							
							$strFirstName = $row[ "FirstName" ];
							$strLastName = $row[ "LastName" ];
							
							echo '<br><strong>Steam ID:</strong> ' . $strSteamID;
							echo '<br><strong>First Name:</strong> ' . $strFirstName;
							echo '<br><strong>Last Name:</strong> ' . $strLastName;
						} else {
							echo '<div class="alert alert-danger">';
							echo '<strong>Ooops!</strong> <br><br>It appears that we could not find your records in our database.<br><br>';
							echo 'Please try again.';
							echo '</div>';
						}
					}
				} else {
					echo '<div class="alert alert-danger">';
					echo '<strong>Ooops!</strong> <br><br>It appears that you are not logged in. Please login first before visiting the profile page.<br><br>';
					echo 'Please <a href="login.php">login</a> here.';
					echo '</div>';
				}
				
			?>
			
			<form class="form-reset" action="reset.php" methord="post">
			<br><button class="btn btn-lg btn-primary type="submit">Reset Progress</button>
			</form>
			<br>
			<div class="alert alert-warning">
			<strong>Warning!</strong> Resetting your progress cannot be undone. You have been warned!
			</div>
		</p>
		
		<h1 class="page-header">Acquired Achievements</h1>
		<p>
			<?php 
				if( !$sqlConnection ) {
					$strErrorMessage = mysqli_error( );
					
					echo '<div class="alert alert-danger">';
					echo '<strong>Oooops!</strong> <br><br>It appears that a connection to the database was not successful. Please try again.<br><br>';
					echo 'Error: ' . $strErrorMessage;
					echo '</div>';
				} else {
					$sqlQuery = sprintf( "SELECT * FROM Achievement LEFT JOIN Achieves ON (Achievement.ID = Achieves.ID) WHERE Achieves.Acquired = 1 AND Achieves.SteamID = '%s';", $strSteamID );
					mysqli_select_db( $sqlConnection, 'ultimateachievements' );
					$sqlResult = mysqli_query( $sqlConnection, $sqlQuery );
					
					if( $sqlResult && mysqli_num_rows( $sqlResult ) > 0 ) {
						$iCount = 1;
						
						while( $iRow = mysqli_fetch_array( $sqlResult, MYSQL_ASSOC ) ) {
							if( $iCount % 3 == 1 ) {
								echo '<div class="row">';
							}
							
							echo '<div class="col-md-4 portfolio-item">';
							//echo '<img class="img-responsive" src="http://placehold.it/700x400" alt="Achievement Picture">';

							echo '<h3>' . $iRow[ "Name" ] . '</h3>';

							echo '<p>' . $iRow[ "Description" ] . '.</p>';
							echo '<strong>Progress: </strong>' . $iRow[ "Progress" ] . '<br>';
							echo '<strong>Goal: </strong>' . $iRow[ "Goal" ] . '';
							echo '</div>';
							
							if( $iCount % 3 == 0 ) {
								echo '</div>';
							}
							
							$iCount++;
						}
						
						if( --$iCount % 3 != 0 ) {
							echo '</div>';
						}
					} else {
						echo '<div class="alert alert-danger">';
						echo '<strong>Ooops!</strong> <br><br>It appears that you have no acquired achievements.<br><br>';
						echo 'Start playing on the server now.';
						echo '</div>';
					}
				}
			?>
		</p>
		
		<h1 class="page-header">UnAcquired Achievements</h1>
		<p>
			<?php 
				if( !$sqlConnection ) {
					$strErrorMessage = mysqli_error( );
					
					echo '<div class="alert alert-danger">';
					echo '<strong>Oooops!</strong> <br><br>It appears that a connection to the database was not successful. Please try again.<br><br>';
					echo 'Error: ' . $strErrorMessage;
					echo '</div>';
				} else {
					$sqlQuery = sprintf( "SELECT * FROM Achievement LEFT JOIN Achieves ON (Achievement.ID = Achieves.ID) WHERE Achieves.Acquired = 0 AND Achieves.SteamID = '%s';", $strSteamID );
					mysqli_select_db( $sqlConnection, 'ultimateachievements' );
					$sqlResult = mysqli_query( $sqlConnection, $sqlQuery );
					
					if( $sqlResult && mysqli_num_rows( $sqlResult ) > 0 ) {
						$iCount = 1;
						
						while( $iRow = mysqli_fetch_array( $sqlResult, MYSQL_ASSOC ) ) {
							if( $iCount % 3 == 1 ) {
								echo '<div class="row">';
							}
							
							echo '<div class="col-md-4 portfolio-item">';
							//echo '<img class="img-responsive" src="http://placehold.it/700x400" alt="Achievement Picture">';

							echo '<h3>' . $iRow[ "Name" ] . '</h3>';

							echo '<p>' . $iRow[ "Description" ] . '.</p>';
							echo '<strong>Progress: </strong>' . $iRow[ "Progress" ] . '<br>';
							echo '<strong>Goal: </strong>' . $iRow[ "Goal" ] . '';
							echo '</div>';
							
							if( $iCount % 3 == 0 ) {
								echo '</div>';
							}
							
							$iCount++;
						}
						
						if( --$iCount % 3 != 0 ) {
							echo '</div>';
						}
					} else {
						echo '<div class="alert alert-success">';
						echo '<strong>Ooops!</strong> <br><br>It appears that have acquired all the achievements.<br><br>';
						echo 'You can always reset your progress above to start over, or you can wait for us to add more achievements in the near future.';
						echo '</div>';
					}
				}
			?>
		</p>
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