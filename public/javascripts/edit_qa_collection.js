$(document).ready(function() {
    $.clone_qa_count = 0;
    init_clone_qa_form();
    init_qa_removal();

    function init_clone_qa_form() {
        $('a#add_new_qa').parent().removeClass('hidden');
        $('a#add_new_qa').click(function(){
            try {
                // Question:
                // 1. Copy table row
                // 2. figure out what bg colors to use for all table row
                // 2. update attributes and input value
                // 3. append the newly updated table row
                // 4. move on to the answer table row
                var cloneQ = $('tr.question:last').clone();

                var add_class = cloneQ.hasClass('grey_bg') ? 'white_bg' : 'grey_bg';
                var rm_class  = cloneQ.hasClass('grey_bg') ? 'grey_bg' : 'white_bg';
                cloneQ.addClass(add_class).removeClass(rm_class);

                $('input', cloneQ).attr({
                    id   : 'new_qa_'+ $.clone_qa_count +'_question',
                    name : 'new_qa['+ $.clone_qa_count +'][question]'
                }).val('');
                $('tbody', 'table.edit_qa_collection').append(cloneQ);

                // Answer
                var cloneA = $('tr.answer:last').clone();
                cloneA.addClass(add_class).removeClass(rm_class);
                $('a.qa_delete', cloneA).remove();
                $('textarea', cloneA).attr({
                    id   : 'new_qa_'+ $.clone_qa_count +'_answer',
                    name : 'new_qa['+ $.clone_qa_count +'][answer]'
                }).html('');
                $('tbody', 'table.edit_qa_collection').append(cloneA);

                // Spacer
                var cloneS = $('tr.spacer:last').clone();
                $('tbody', 'table.edit_qa_collection').append(cloneS);

                // Setup for the next new QA
                $.clone_qa_count++;

                try {$.modal.impl.updateDimensionsAfterAppend('tr.question:last, tr.answer:last, tr.spacer:last');}catch(e){}

               return false;
           } catch(e) {return false;}
        });
    }
    
    function init_qa_removal() {
        $('a.qa_delete').each(function(){
            $(this).parent().removeClass('hidden');
            $(this).click(function(){
                var id = $(this).attr('data-id');
                $.ajax({
                    url     : $(this).attr('href'),
                    dataType: 'html',
                    type    : $(this).attr('data-method'),
                    success: function (data, status, xhr) {
                        $('tr#q_'+ id).fadeOut();
                        $('tr#a_'+ id).fadeOut();
                        $('tr#s_'+ id).fadeOut();
                        $('li#qa_'+ id).fadeOut();
                    },
                    error: function (xhr, status, error) {
                        $.Growl.show({
                          message : 'There was a problem removing this q&a. Please reload the page and try again. If the problem persists, please contact your local smart guy.',
                          icon    : 'error',
                          timeout : 7500
                        });
                    }
                });

               return false; 
            });
        });
    }
});