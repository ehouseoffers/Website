$(function() {
	
	var totalPanels			= $(".scrollContainer").children().size();
		
	var regWidth			= $(".panel").css("width");
	var regImgWidth			= $(".panel img").css("width");
	var regTitleSize		= $(".panel h2").css("font-size");
	var regParSize			= $(".panel p").css("font-size");
	
	var movingDistance	    = 188;
	
	var curWidth			= 200;
	var curImgWidth			= 200;
	var curTitleSize		= "20px";
	var curParSize			= "15px";

	var $panels				= $('.slider .scrollContainer > div');
	var $container			= $('.slider .scrollContainer');
    var $title              = $('.slider h2');

    var scrollbar = $('.slider .scrollbar');
    // Calculate the width of the scrollbar relative to the number of panels we have
    var w = Math.round(100/totalPanels);
    if ( w > 50 ) w = 50;
    if ( w < 10 ) w = 10;
    scrollbar.css('width', w+'%');
    var scrollbar_width = parseInt(scrollbar.css('width'));

    // Pixels that the scrollbar must move on each click. leftmost is at 6px for padding; right has 6px padding as well.
    // Subtract our max from min gives us the total width the scrollbar can move in.
    var scroll_min = 6;   // the left-most position the scrollbar can take
    var scroll_max = parseInt(536 - scrollbar_width); // the right-most position (relative to the left-most part of the bar)
    // Finally, the total number of pixels the scrollbar must scroll by, left or right, when scrolling
    var scroll_by = Math.ceil((scroll_max - scroll_min) / (totalPanels-1));

	$panels.css({'float' : 'left','position' : 'relative'});
    
	$(".slider").data("currentlyMoving", false);

	$container
		.css('width', ($panels[0].offsetWidth * $panels.length) + 100 )
		.css('left', "0px");

	var scroll = $('.slider .scroll').css('overflow', 'hidden');

	function returnToNormal(element) {
	    $(element)
		.animate({ width: regWidth })
		.find("img")
		.animate({ width: regImgWidth });
	};
	
	function growBigger(element) {
        try {
    	    var img = $(element)
                        .animate({ width: curWidth })
                        .find("img")
                        .animate({ width: curImgWidth });

            var path = img.attr('data-path');
            var title = img.attr('alt');
            $title.html($(document.createElement('a')).attr('href', path).html(title));
        } catch(e) {}
	}
	
	// if move_right is not true, then we are moving left
	function change(move_right) {
	    // Only continue if we are not at the first or last panel
		if((move_right && !(curPanel < totalPanels)) || (!move_right && (curPanel <= 1))) { return false; }	
        
        //if not currently moving
        if (($(".slider").data("currentlyMoving") == false)) {
            
			$(".slider").data("currentlyMoving", true);
			
			var next         = move_right ? curPanel + 1 : curPanel - 1;
			var leftValue    = $(".scrollContainer").css("left");
			var movement	 = move_right ? parseFloat(leftValue, 10) - movingDistance : parseFloat(leftValue, 10) + movingDistance;

            // The first panel stays in the far left slot, so if we are move from the second panel to the first or the
            // first to the second, there is no movement, only resizing.
            if ( next <= 2 ) movement = 0;
            if ( next == totalPanels || (!move_right && next == (totalPanels-1)) ) movement = parseFloat(leftValue, 10);

			$(".scrollContainer")
			.stop()
			.animate({
				"left": movement
			}, function() {
				$(".slider").data("currentlyMoving", false);
			});

            scroll_to(move_right, curPanel);

			returnToNormal("#panel_"+curPanel);
			growBigger("#panel_"+next);
		
			curPanel = next;

			//remove all previous bound functions
			$("#panel_"+(curPanel+1)).unbind();	
		
			//go forward
			$("#panel_"+(curPanel+1)).click(function(){ change(true); });
		
            //remove all previous bound functions															
			$("#panel_"+(curPanel-1)).unbind();
		
			//go back
			$("#panel_"+(curPanel-1)).click(function(){ change(false); }); 
		
			//remove all previous bound functions
            $("#panel_"+curPanel).unbind();
            make_clickable(curPanel);
		}
	}

    function make_clickable(panel_id) {
        $("#panel_"+panel_id)
        .hover(function(){ $(this).css('cursor','pointer') },
               function(){ $(this).css('cursor','default') })
        .click(function(){
            window.location = $('img', $(this)).attr('data-path');
        });
    }

    function scroll_to(move_right, panel) {
        // current position left (location) of scrollbar
        var loc = parseInt(scrollbar.css('left'));

        // determine the next left position for our scrollbar; are we moving left or right?
        var left_position = parseInt(move_right ? Math.ceil(loc+scroll_by) : Math.floor(loc-scroll_by));

        // thresholds
        if ( left_position > scroll_max ) {
            left_position = scroll_max;
        } else if ( left_position < scroll_min ) {
            left_position = scroll_min;
        }

        // move the scrollbar already
        scrollbar.animate({ 'left' : left_position });
    }
	
	// Set up "Current" panel and next and prev
    growBigger("#panel_2");
    var curPanel = 2;
    scroll_to(true, curPanel);
    make_clickable(curPanel);
	
	$("#panel_"+(curPanel+1)).click(function(){ change(true); });
	$("#panel_"+(curPanel-1)).click(function(){ change(false); });
	
	//when the left/right arrows are clicked
	$(".scroll_right").click(function(){ change(true); });	
	$(".scroll_left").click(function(){ change(false); });



    // $(window).keydown(function(event){
    //   switch (event.keyCode) {
    //      case 13: //enter
    //          $(".right").click();
    //          break;
    //      case 32: //space
    //          $(".right").click();
    //          break;
    //     case 37: //left arrow
    //          $(".left").click();
    //          break;
    //      case 39: //right arrow
    //          $(".right").click();
    //          break;
    //   }
    // });
	
});