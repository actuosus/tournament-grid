/* Italian translation for the jQuery Timepicker Addon */
/* Written by Marco "logicoder" Del Tongo */
define('jquery.ui.timepicker.it', ['jquery.ui.timepicker'], function () {
  (function ($) {
    $.timepicker.regional['it'] = {
      timeOnlyTitle: 'Scegli orario',
      timeText: 'Orario',
      hourText: 'Ora',
      minuteText: 'Minuti',
      secondText: 'Secondi',
      millisecText: 'Millisecondi',
      microsecText: 'Microsecondi',
      timezoneText: 'Fuso orario',
      currentText: 'Adesso',
      closeText: 'Chiudi',
      timeFormat: 'HH:mm',
      amNames: ['m.', 'AM', 'A'],
      pmNames: ['p.', 'PM', 'P'],
      isRTL: false
    };
    $.timepicker.setDefaults($.timepicker.regional['it']);
  })(jQuery);
});