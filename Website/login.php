<!DOCTYPE html>
<html lang="en">
<head>
	<title>Tony Karam Senior Project</title>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
	<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
</head>
<body>
<nav class="navbar navbar-inverse">
	<div class="container-fluid">
		<div class="navbar-header">
			<a class="navbar-brand" href="/index.php">Achievements</a>
		</div>
		<ul class="nav navbar-nav">
			<li><a href="/index.php">Home</a></li>
			<li><a href="/profile.php">Profile</a></li>
			<li><a href="/admin.php">Admin</a></li>
			<li><a href="/contact/php">Contact Us</a></li>
		</ul>
		<ul class="nav navbar-nav navbar-right">
			<li><a href="/sign-up.php"><span class="glyphicon glyphicon-user"></span> Sign Up</a></li>
			<li class="active"><a href="/login.php"><span class="glyphicon glyphicon-log-in"></span> Login</a></li>
		</ul>
	</div>
</nav>

<div class="container">
    <div class="row">
        <div class="col-sm-6 col-md-4 col-md-offset-4">
	     <h1 class="text-center login-title">Sign in</h1>
            <div class="account-wall">
                <form class="form-signin">
		<br>
                <input type="text" class="form-control" placeholder="Steam ID" required autofocus>
                <br>
		<input type="password" class="form-control" placeholder="Password" required>
		<br>
                <button class="btn btn-lg btn-primary btn-block" type="submit">
                    Sign in</button>
		<script>
		$(document).ready(function(){
		    $('[data-toggle="popover"]').popover(); 
		});
		</script>
		<a href="#" class="need-help" title="Where can you find your Steam ID?" data-toggle="popover" data-content="You can find your Steam ID when you connect to any server. Once on a server, type 'status' in console and find your Steam ID next to your name.">Need Help?</a><br>
                </form>
            </div>
            <a href="/sign-up.php" class="text-center new-account">Sign Up </a>
	    <br><br>
	    <div class="alert alert-info">
	    <a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
		<strong>Why login?</strong>
		<br>By loggin in you get access to:
		<ul>
			<li>View your profile</li>
			<li>View your achievements</li>
			<li>Explore new possible achievements</li>
			<li>And so much more!</li>
		</ul>
	    </div>
        </div>
    </div>
</div>

</body>
</html>