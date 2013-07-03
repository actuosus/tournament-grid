/* Russian translation for the jQuery Timepicker Addon */
/* Written by Trent Richardson */
define('jquery.ui.timepicker.ru', ['jquery.ui.timepicker'], function () {
  (function ($) {
    $.timepicker.regional['ru'] = {
      timeOnlyTitle: 'Выберите время',
      timeText: 'Время',
      hourText: 'Часы',
      minuteText: 'Минуты',
      secondText: 'Секунды',
      millisecText: 'Миллисекунды',
      microsecText: 'Микросекунды',
      timezoneText: 'Часовой пояс',
      currentText: 'Сейчас',
      closeText: 'Закрыть',
      timeFormat: 'HH:mm',
      amNames: ['AM', 'A'],
      pmNames: ['PM', 'P'],
      isRTL: false
    };
    $.timepicker.setDefaults($.timepicker.regional['ru']);
  })(jQuery);
});