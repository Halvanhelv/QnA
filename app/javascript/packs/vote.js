$(document).on('turbolinks:load', function() {
    $(document).on('ajax:success', '#vote-block', function(e) {
        const votable = e.detail[0];

        if (votable.type === 'question') {
            $('#question #vote-block #vote-rating').html('<p id="question-rating">' + votable.rating + '</p>');
        } else {
            $(`#answer-id-${votable.id} #vote-rating`).html('<p id="answer-rating">' + votable.rating + '</p>');
        }

        $('.notice').html('').append('<p>' + votable.message + '</p>');
    });

    $(document).on('ajax:error', '#vote-block', function(e) {
        const errors = e.detail[0];
        $.each(errors, function(index, value) {
            $('.alert').html('<p>' + value + '</p>');
        })

    })
});