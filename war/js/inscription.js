
function inscription()
{
	var login = $('#login').val();
	var pass = $('#pass').val();
	var pass2 = $('#pass2').val();
	var email = $('#email').val();

	var comment = "";
	document.getElementById('errors').innerHTML = comment;

	if(pass != pass2)
	{
		comment="Mots de passes non egaux.";
		document.getElementById('errors').innerHTML = comment;
		return;
	}
	if(pass.length<8)
	{
		comment="Mot de passe trop court (8 caracteres minimum)";
		document.getElementById('errors').innerHTML = comment;
		return;
	}
	if(pass.length>20){
		comment="Mot de passe trop long (20 caractres maximum)";
		document.getElementById('errors').innerHTML = comment;
		return;
	}
	if(pass2.length>20){
		comment="Mot de passe trop long (20 caractres maximum)";
		document.getElementById('errors').innerHTML = comment;
		return;
	}
	if(login.length>20){
		comment="Identifiant trop long (20 caractres maximum)";
		document.getElementById('errors').innerHTML = comment;
		return;
	}
	if(email.length>35){
		comment="Email trop long (35 caractres maximum)";
		document.getElementById('errors').innerHTML = comment;
		return;
	}
	else 
	{
		if(email.match(/\S+@\S+\.\S+/).length=="1")
		{ // si on matche bien qqch du type xxxxx@xxx.xxx
			var json = {};
			json.login = login;
			json.pass = pass;
			json.email = email;

			$.ajax({
				type: "POST",
				dataType:"json",
				url:"inscription",
				data:json
			}).then(function(json){
				if(json.response == "true")
				{
					alert("Nouvel utlisateur ajoute avec succes");
				}

				else
				{
					comment="Un compte est deja associe a cette adresse email.";
					document.getElementById('errors').innerHTML = comment;
					return;
				}
			});
		}
		else
		{
			comment="Adresse mail non conforme.";
			document.getElementById('errors').innerHTML = comment;
			return;
		}
	}
}

