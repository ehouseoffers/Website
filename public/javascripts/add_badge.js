$(document).ready(function() {
    $('textarea.copyC').focus(function(){
        this.select();
        $(this).css('color','#75973e');
    });
    $('textarea.copyC').blur(function(){
        $(this).css('color','#676767');
    });

});

