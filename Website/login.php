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
		     <h1 class="text-center login-title">Sign in</h1>
		    <div class="account-wall">
			<form class="form-signin" action="login_check.php" method="post">
			<br>
			<input type="text" class="form-control"  name="steamid" placeholder="Steam ID" required autofocus>
			<br>
			<input type="password" class="form-control" name="password" placeholder="Password" required>
			<br>
			<?php
				if( isset( $_SESSION[ "steamid" ] ) ) {
					echo '<button disabled class="btn btn-lg btn-default btn-block">You are already logged in</button>';
				} else {
					echo '<button class="btn btn-lg btn-primary btn-block" type="submit">Sign in</button>';
				}
			?>
			<script>
			$(document).ready(function(){
			    $('[data-toggle="popover"]').popover(); 
			});
			</script>
			<a href="#" class="need-help" title="Where can you find your Steam ID?" data-toggle="popover" data-content="You can find your Steam ID when you connect to any server. Once on a server, type 'status' in console and find your Steam ID next to your name.">Need Help?</a><br>
			</form>
		    </div>
		    <a href="sign-up.php" class="text-center new-account">Sign Up </a>
		    <br><br>
		    <div class="alert alert-info">
		    <a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
			<strong>Why login?</strong>
			<br><br>By logging in you will be able to:
			<ul>
				<li>View your profile</li>
				<li>View your achievements</li>
				<li>View achievement progress</li>
			</ul>
			And so much more!
		    </div>
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