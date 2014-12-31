
	var refreshId = setInterval(function()
	{
	     $('#responsecontainer').fadeOut("slow").load('<%= refresh_part_messages_path%>').fadeIn("slow");
	}, 1000);