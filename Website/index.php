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
				<li class="active"><a href="index.php">Home</a></li>
				<li><a href="achievements.php">Achievements</a></li>
				<li><a href="profile.php">Profile</a></li>
			</ul>
			<ul class="nav navbar-nav navbar-right">
				<li><a href="sign-up.php"><span class="glyphicon glyphicon-user"></span> Sign Up</a></li>
				<li><a href="login.php"><span class="glyphicon glyphicon-log-in"></span> Login</a></li>
				<li><a href="logout.php"><span class="glyphicon glyphicon-log-out"></span> Logout</a></li>
			</ul>
		</div>
	</nav>

	<div id="banner" class="container content-section text-center">
		<img src="images/banner-achievements.jpg" />
	</div>

	<div id="introduction" class="container content-section text-center">
		<div class="row">
			<div class="col-lg-8 col-lg-offset-2">
				<h2>Welcome to Ultimate Achievements</h2>
				<br><br>
				<p>Ultimate Achievements is a Senior Project created by Tony Karam for Notre Dame University de Louaize. The goal of this project is to create an AmxModX plugin for Counter-Strike 1.6 servers to track players' progress and save it to a database. That database can later be accessed from this website where each player can login to check his/her own progress and possibly discover new <a href="achievements.php">achievements</a> that can be fulfilled.</p>
				<br>
				<p>The achievements are numerous and challenging. Achievements range from winning rounds, killing enemies, defusing and planting bombs, all the way to earning and spending in-game money. The plugin in question can be installed on as many servers as one would like. Each server can have it's own set of achievements and/or share achievements with other servers.</p>
			</div>
		</div>
	</div>

	<hr>

	<div class="row">
		<div class="col-lg-12">
			<h1>Some interesting features:</h1>
			<br>
		</div>
		
		<div class="col-md-4">
			<div class="panel panel-default">
				<div class="panel-heading">
					<h4>Easy to use</h4>
				</div>
				<div class="panel-body">
					<p>The plugin and the website are straight forward and easy to use.</p>
					<p>As soon the player joins the server for the first time, he is asked to set a password so his profile is created. It is as simple as that.</p>
					<p>The website is also user friendly. If you have used any other website, then you have all the knowledge you need to navigate yourself through this website and use it's different features.</p>
				</div>
			</div>
		</div>
		<div class="col-md-4">
			<div class="panel panel-default">
				<div class="panel-heading">
					<h4>Fully automated</h4>
				</div>
				<div class="panel-body">
					<p>This project is fully automated. It requires no human interaction at all.</p>
					<p>Everything is handled by the plugin and the website. That includes everything, starting from player registration, progress tracking, and ending with data uploads and downloads from the server to the database.</p>
					<p>That does not refrain the administrator from making his own changes and tweaks when he desires.</p>
				</div>
			</div>
		</div>
		<div class="col-md-4">
			<div class="panel panel-default">
				<div class="panel-heading">
					<h4>Secure</h4>
				</div>
				<div class="panel-body">
					<p>You don't have to worry about people stealing your login credentials. We have it locked and safe.</p>
					<p>This project uses a unique steam ID that is automatically created for each player, thanks to <a href="http://steacommunity.com/">Steam</a>, you can rest assured that your account is safe.</p>
					<p>Even the password, that you choose, is safely hashed with a randomly generated salt. That way it is tightly secured.</p>
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