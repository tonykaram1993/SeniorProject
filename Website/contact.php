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
			<a class="navbar-brand" href="index.php">Achievements</a>
		</div>
		<ul class="nav navbar-nav">
			<li><a href="index.php">Home</a></li>
			<li><a href="profile.php">Profile</a></li>
			<li><a href="admin.php">Admin</a></li>
			<li class="active"><a href="contact.php">Contact Us</a></li>
		</ul>
		<ul class="nav navbar-nav navbar-right">
			<li><a href="sign-up.php"><span class="glyphicon glyphicon-user"></span> Sign Up</a></li>
			<li><a href="login.php"><span class="glyphicon glyphicon-log-in"></span> Login</a></li>
		</ul>
	</div>
</nav>

<div class="container">
    <div class="row">
        <div class="col-sm-6 col-md-4 col-md-offset-4">
	     <h1 class="text-center login-title">Contact Us</h1>
            <div class="account-wall">
                <form class="form-contact">
		<br>
                <input type="text" class="form-control" placeholder="Full Name" id="name" required autofocus>
                <br>
		<input type="email" class="form-control" placeholder="Email" id="email" required>
		<br>
		<textarea rows="10" class="form-control" placeholder="Your comments" id="comments" required></textarea>
                <br>
		<button class="btn btn-lg btn-primary btn-block" type="submit">
                    Sign in</button>
		<script>
		$(document).ready(function(){
		    $('[data-toggle="popover"]').popover(); 
		});
		</script>
            </div>
	    <br><br>
	    <div class="alert alert-info">
	    <a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
		<strong>What happens next?</strong>
		<br><br>We will take a loot at your comments and get back to you as soon as possible. We will be in contact with you using the email that you provided above.
	    </div>
        </div>
    </div>
</div>

</body>
</html>