<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>

 
<%@ page import="com.google.appengine.api.channel.ChannelService" %>
<%@ page import="com.google.appengine.api.channel.ChannelServiceFactory" %>
<%@page import="java.util.ArrayList"%>
 
 
<%
 
ChannelService channelService = ChannelServiceFactory.getChannelService();
String token = channelService.createChannel("player1");
 
%>
 
<!DOCTYPE html>
<html>
    <head>
         <meta charset="utf-8">
	    <title>Kill the Pich</title>
	    <link href="css/game.css" rel="stylesheet">
	    <link href="css/player1.css" rel="stylesheet">
	
    </head>
    <body>
    	<div id="plateau">

		<div id="player3">3</div>
		<div id="player2">2</div>
		<div id="centerPlateau">
			<div id="piocheDef">
				<div id="pioche">Pioche</div>
				<div id="defausse" class="dropper">Defausse</div>
			</div>
			<div id="notifications">Notifications</div>
		</div>
		<div id="action">
			<div id="action_play" class="action_div" onclick="play()">Play card</div>
			<div id="action_defausse" class="action_div" onclick="defausse()">Defausse card</div>
			<div id="action_cancel" class="action_div" onclick="cancel()">Cancel</div>
			<div id="action_endOfTurn" class="action_div" onclick="endOfTurn()">End of turn</div>
		</div>
		<div id="player4">4</div>
		<div id="player1">
			<div id="information">
				<div id="life">
					life
				</div>
				<div id="role">
					role
				</div>
			</div>
			<div id="cards">

			</div>
		</div>
    
   	    <script src='//code.jquery.com/jquery-1.7.2.min.js'></script>
	    <script src="/_ah/channel/jsapi"></script>
	    <script src="js/jquery.js"></script>
		<script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.10.4/jquery-ui.min.js"></script>
		<script src="js/jquery-ui.js"></script>
		<script src="js/jquery-2.1.1.js"></script>
		<script src="js/game.js"></script>
    	<script>
	    var token ="<%=token %>";// This will creaete unique identifier(some id created by google api + ur key)
		channel = new goog.appengine.Channel('<%=token%>');    
		socket = channel.open();    
		
		socket.onopen = function() {
			addPlayer("player1",token);
		}
		
		socket.onmessage = function(message) {

			if(message.data.indexOf("paf") > -1){
				if(message.data.indexOf("paf1") > -1){
					$("#notifications").text("You got pafed !!");
				}
				else{
					var player = message.data.split("paf")[1];
					$("#notifications").text("player "+player+" got pafed!!");
				}
			}
			
			if(message.data.indexOf("missed") > -1){
				if(message.data.indexOf("missed1") > -1){
					$("#notifications").append("<p>You don't lose 1 life !!</p>");
				}
				else{
					var player = message.data.split("missed")[1];
					$("#notifications").append("<p>player "+player+" dodged the paf!!</p>");
				}
			}

			if(message.data.indexOf("startGame") > -1){
				$("#notifications").text("4 players. The game begins");
				refreshHand(1);
				if(message.data.indexOf("Turn1") > -1){
					$("#notifications").append("<p>You are the sherif !! Your turn to play</p>");

					$(document).ajaxStop(function () {
					     enablePlayer();
					  });
				}
				else{
					var player = message.data.split("Turn")[1];
					$("#notifications").append("<p>player "+player+" is the sherif. It's his turn to play</p>");
					
					$(document).ajaxStop(function () {
					      disablePlayer();
					  });
				}
				
			}	
			
			if(message.data.indexOf("turn") > -1){

				refreshHand(1);
				if(message.data.indexOf("turn1") > -1){
					$("#notifications").text("Your turn to play");

					$(document).ajaxStop(function () {
					     enablePlayer();
					});
				}
				else{
					var player = message.data.split("turn")[1];
					$("#notifications").text("player "+player+" turn to play");
					
					$(document).ajaxStop(function () {
					      disablePlayer();
					});
				}
			}	
			
			
			
			if(message.data.indexOf("refreshHand") > -1){
				//alert("4 joueurs, la partie va commencer");
				refreshHand(1);
			}	
			if(message.data.indexOf("loseLife") > -1){
				if(message.data.indexOf("loseLife1") > -1){
					$("#notifications").append("<p>You lose 1 life !!</p>");
				}
				else{
					var player = message.data.split("loseLife")[1];
					$("#notifications").append("<p>player "+player+" lost 1 life!!</p>");
				}
				refreshHand(1);
				reEnablePlayer();
			}	
			if(message.data.indexOf("waitAnswer") > -1){
				if(message.data.indexOf("waitAnswer1") > -1){
					$("#notifications").text("Your turn to dodge!!");
			        $("#notifications").append("<p>If you dont wan't or can't to dodge just click here</p>");
			        $("#notifications").append("<button onclick='skipDodge()'>Skip</button>");
					$(document).ajaxStop(function () {
					     enableMissed();
    				});

				}
				else{
					var player = message.data.split("waitAnswer")[1];
					$("#notifications").append("<p>player "+player+" can dodge!!</p>");
				}
			}
			
	    };
    	</script>
    </body>
</html> 
