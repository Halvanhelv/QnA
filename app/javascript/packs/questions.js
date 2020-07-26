$(document).on('turbolinks:load', function(){
    $('.answers').on('click', '.edit-answer-link', function(e) {
        e.preventDefault();
        $(this).hide();
        var answerId = $(this).data('answerId');
        console.log(answerId);
        $('form#edit-answer-' + answerId).removeClass('hidden');
    })

    $('#question-vote').on('ajax:success', function(e) {
        var question = e.detail[0];
        console.log(question)
        $('#question #question-vote #question-rating').html('<p id="question-rating">' + question.rating + '</p>');
        $('.notice').html('')
        $('.notice').append('<p>' + question.message + '</p>');
    })
        .on('ajax:error', function (e) {
            var errors = e.detail[0];

            $.each(errors, function(index, value) {
                $('.alert').append('<p>' + value + '</p>');
            })

        })
});