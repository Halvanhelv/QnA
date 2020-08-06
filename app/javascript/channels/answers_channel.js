
import consumer from "./consumer"


  consumer.answers_subscribe = consumer.subscriptions.create('AnswersChannel', {
    connected: function() {
      return subscribeToAnswers();
    },
    received(data) {

      if (gon.user_id === data.answer.user_id) return;

      const template = require('./handlebars/answer.hbs');

      data.is_question_owner = gon.user_id === gon.question_owner_id;

      $('.answers').append(template(data));
    }
  });


var subscribeToAnswers;

subscribeToAnswers = function() {

  if (gon.question_id) {
    console.log(consumer.answers_subscribe)
    return consumer.answers_subscribe.perform('follow', {
      id: gon.question_id
    });
  } else {
    return consumer.answers_subscribe.perform('unfollow');
  }
};

$(document).on('turbolinks:load', function() {
  return subscribeToAnswers();
});