$(document).on('turbolinks:load', function () {
    $('.answers').on('click', '.edit-answer-link', function (e) {
        e.preventDefault();
        $(this).hide();
        var answerId = $(this).data('answerId');
        $('form#edit-answer-' + answerId).removeClass('hidden');
    })
    $('.answers').on('click','.add_comment_button', function (e) {
        e.preventDefault();
        $(this).hide();
        let answerId = $(this).data('answerId');
        $('#answer-id-'+ answerId +' .add_comment_button').hide();
        $('#answer-id-'+ answerId +' .comment-block').show();
        $('#answer-id-'+ answerId +' .comment_text_area').val('');
    });

    $(document).on('ajax:error', '.new-answer', function(e) {

        const error = (e.detail[0]);

        $('.new-answer-errors').html('<p>' + error + '</p>');

    })
});

