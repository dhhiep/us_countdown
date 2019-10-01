(function ($) {

    'use strict';

    // ------------------------------------------------------- //
    // Datepicker
    // ------------------------------------------------------ //
	$(function () {
		//default date range picker
		$('#daterange').daterangepicker({
			autoApply:true
		});

		//date time picker
		$('#datetime').daterangepicker({
			timePicker: true,
			timePickerIncrement: 30,
			locale: {
				format: 'MM/DD/YYYY h:mm A'
			}
		});

		//single date
		$('.date-pikcer').daterangepicker({
			singleDatePicker: true,
			autoUpdateInput: false,
	    locale: {
	      format: 'DD/MM/YYYY'
	    }
		});

	  $('.date-pikcer').on('apply.daterangepicker', function(ev, picker) {
	      $(this).val(picker.startDate.format('DD/MM/YYYY'));
	  });

	  $('.date-pikcer').on('cancel.daterangepicker', function(ev, picker) {
	      $(this).val('');
	  });
	});

})(jQuery);
