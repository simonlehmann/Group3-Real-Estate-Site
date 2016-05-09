// #	Created: Tylden Horan with aid from http://html-tuts.com/back-to-top-button-jquery/
// #	Date 23/04/2016
// #
// #	The following jQuery is for the top of page button


//$('body').prepend('<a href="#" class="back-to-top">Back to Top</a>');
var amountScrolled = 200;

$(window).scroll(function() {
	if ( $(window).scrollTop() > amountScrolled ) {
		$('a.back-to-top').fadeIn('fast');
	} else {
		$('a.back-to-top').fadeOut('fast');
	}
});

$('a.back-to-top').click(function() {
	console.log("Clicked!");
	console.log(5 + 6);
	$('html, body').animate({
		scrollTop: 0
	}, 700);
	return false;
});