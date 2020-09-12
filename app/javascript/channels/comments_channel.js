import consumer from "./consumer"


consumer.comments_subscribe = consumer.subscriptions.create('CommentsChannel', {
    connected: function() {
        return subscribeToComments();
    },
    received: function(data) {
        if (gon.user_id === data.comment.user_id) return;
        const template = require('./handlebars/comment.hbs');
        if (data.type === 'answer') {
            $(`#${data.type}-id-${data.id} .answer_comments`).append(template(data));
        } else {
            $(`#question .question_comments`).append(template(data));
        }
    }
});


var subscribeToComments;

subscribeToComments = function() {
    if (gon.question_id) {
        return consumer.comments_subscribe.perform('follow', {
            id: gon.question_id
        });
    } else {
        return consumer.comments_subscribe.perform('unfollow');
    }
};

$(document).on('turbolinks:load', function() {
    return subscribeToComments();
});