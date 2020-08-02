$(document).on('turbolinks:load', function () {
    const question = $('#question')
    question.on('click', '.edit-question-link', function (e) {
        e.preventDefault();
        $(this).hide();
        $('form#edit-question').removeClass('hidden');
    })
    question.on('click', '.add_comment_button', function (e) {
        e.preventDefault();
        $(this).hide();
        $('#question .add_comment_button').hide();
        $('#question .comment_text_area').val('');
        $('#question .comment-block').show();


    })
});