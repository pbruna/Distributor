# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
	$("#select_all_servers").on("change", () ->
		if $(this).is(':checked')
			$(".select_server").attr('checked', true)
		else
			$(".select_server").attr('checked', false)
	);