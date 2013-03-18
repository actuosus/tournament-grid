jQuery(function($) {
	"use strict";

//	if ($.browser.msie && $.browser.version < 8) {
//		/**
//		 * fix ie7 :focus
//		 */
//		$('textarea, input').bind('focus blur',function (){
//			$(this).toggleClass('focus');
//		});
//	}


	/**
	 * Placeholder support for old brawsers
	 */
	(function () {
		var placeholderSupport = function () {
			var testInput = document.createElement('input');
			if ('placeholder' in testInput) {
				return true; 
			} else { return false; }
		}();
		if ( ! placeholderSupport ) {
			$('input, textarea').each(function () {
				var placeholder = $(this).attr('placeholder');
				$(this)
					.val(placeholder)
					.attr('title', placeholder);
			});
			$('input, textarea').focusin(function() {
				if ($(this).val() === $(this).attr('title')) { $(this).val(''); }
			}).focusout(function() {
				if ($(this).val() === '') { $(this).val($(this).attr('title')); }
			});
		}
	})();

});
