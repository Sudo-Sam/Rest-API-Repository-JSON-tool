$(document).on('click', '#time_div th', function (event) {
	$(this).next('td').toggle();
	$(this).attr('font-weight','bold');
	$(this).css('background-color', 'red');
  });