$(document).on('turbolinks:load', function(){
   var answer_vote_block = $(".answers #answer-vote")
    $(document).on('ajax:success', function(e) {
        const votable = e.detail[0];


        if (votable.type === 'question') {
            $('#question #question-vote #vote-rating').html('<p id="question-rating">' + votable.rating + '</p>');
        }
        else
        {
            $(`#answer-id-${votable.id} #vote-rating`).html('<p id="answer-rating">' + votable.rating + '</p>');
        }

        $('.notice').html('').append('<p>' + votable.message + '</p>');
    });

    $(document).on('ajax:error', function (e) {
        console.log('dddddddddddddddddddddddddddddddddddddddddddd')
            const errors = e.detail[0];

            $.each(errors, function(index, value) {
                $('.alert').append('<p>' + value + '</p>');
            })

        })
});