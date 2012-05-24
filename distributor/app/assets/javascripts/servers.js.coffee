# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
	$("#select_all_packages").on("change", () ->
		if $(this).is(':checked')
			$(".select_package").attr('checked', true)
		else
			$(".select_package").attr('checked', false)
	);
