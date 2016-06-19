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
				<li class="active"><a href="achievements.php">Achievements</a></li>
				<li><a href="profile.php">Profile</a></li>
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
			<div class="col-lg-12">
				<h1 class="page-header">Achievements</h1>
			</div>
		</div>
		
		<?php 
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
				$sqlQuery = "SELECT * FROM Achievement;";
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
						echo '<strong>Goal: </strong>' . $iRow[ "Goal" ] . '';
						echo '</div>';
						
						if( $iCount % 3 == 0 ) {
							echo '</div>';
						}
						
						$iCount++;
					}
				} else {
					echo '<div class="alert alert-danger">';
					echo '<strong>Ooops!</strong> <br>It appears there are no Achievements in the database.';
					echo '</div>';
				}
			}
		?>
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