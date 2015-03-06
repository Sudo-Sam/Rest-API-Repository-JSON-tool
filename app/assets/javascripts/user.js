$(document).on('click', '#time_div th', function(event) {
	$(this).next('td').toggle('fast');
	var back_color = $(this).css("background-color");
	if(back_color == "rgb(128, 128, 128)"){
	$(this).css("background-color", "transparent");
	}
	else{
	$(this).css("background-color", "grey");
	}
}); 