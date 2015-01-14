<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>

 
<%@ page import="com.google.appengine.api.channel.ChannelService" %>
<%@ page import="com.google.appengine.api.channel.ChannelServiceFactory" %>
<%@page import="java.util.ArrayList"%>

<%@page import="bang.model.game.GameModel"%>
<%@page import="bang.manager.CacheManager"%>
 
 
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
    	<%
    	int lPlayerNumber = 0;
    	int lPlayerNumberRight = 0;
    	int lPlayerNumberTop = 0;
    	int lPlayerNumberLeft = 0;
    	
    	GameModel gameModel = (GameModel) CacheManager.getInstance().get("game");
    	Switch(gameModel.getNbPlayers())
    	{
    		case 0: lPlayerNumber = 1;
    			lPlayerNumberRight = 4;
    			lPlayerNumberTop = 3;
    			lPlayerNumberLeft = 2;
    			break;
    		case 1: lPlayerNumber = 2;
    			lPlayerNumberRight = 1;
    			lPlayerNumberTop = 4;
    			lPlayerNumberLeft = 3;
				break;
    		case 2: lPlayerNumber = 3;
    			lPlayerNumberRight = 2;
    			lPlayerNumberTop = 1;
    			lPlayerNumberLeft = 4;
				break;
    		case 3: lPlayerNumber = 4;
    			lPlayerNumberRight = 3;
    			lPlayerNumberTop = 2;
    			lPlayerNumberLeft = 1;
				break;
    	}
    	%>
    	<div id='plateau'>
    			<div id='player<% out.write(lPlayerNumberTop); %>'><% out.write(lPlayerNumberTop); %></div>
    			<div id='player<% out.write(lPlayerNumberLeft); %>'><% out.write(lPlayerNumberLeft); %></div>
    			<div id='pioche'>pioche</div>
    			<div id='defausse' class='dropper'>def</div>
    			<div id='action'>
    				<div id='action_play' class='action_div' onclick='play()'>Play card</div>
    				<div id='action_defausse' class='action_div' onclick='defausse()'>Defausse card</div>
    				<div id='action_cancel' class='action_div' onclick='cancel()'>Cancel</div>
    			</div>
    			<div id='player<% out.write(lPlayerNumberRight); %>'><% out.write(lPlayerNumberRight); %></div>
    			<div id='player<% out.write(lPlayerNumber); %>'>
    				<div class='life_horizontal'>1</div>
    				<div class='slot_horizontal' id='card1'>
    					<img class='image_in_slot' onclick='showAction(1)' src='img/test.jpg'/>
    				</div>
    				<div class='slot_horizontal' id='card2'>
    					<img class='image_in_slot' onclick='showAction(2)' src='img/bang.jpg'/>
    				</div>
    				<div class='slot_horizontal' id='card3'>
    					<img class='image_in_slot' onclick='showAction(3)' src='img/test3.jpg'/>
    				</div> 
    				<div class='slot_horizontal' id='card4'>
    					<img class='image_in_slot' onclick='showAction(4)' src='img/test4.jpg'/>
    				</div>
    				<div class='slot_horizontal' id='card5'>
    					<img class='image_in_slot' onclick='showAction(5)' src='img/missed.jpg'/>
    				</div>
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
			addPlayer(token);
		}
		
		socket.onmessage = function(message) {

			if(message.data.indexOf("bang") > -1){
				alert("U just got banged !");
				checkForMissed();
			}
			
			if(message.data.indexOf("gameStart") > -1){
				//alert("4 joueurs, la partie va commencer");
				getStartingHand(1);
			}		    
	    };
    	</script>
    </body>
</html> 
