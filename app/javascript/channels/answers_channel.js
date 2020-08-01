import consumer from "./consumer"

$(document).on('turbolinks:load', function () {
  let answersList =  $('.answers');
  if (answersList.length) {
    consumer.subscriptions.create({ channel: "AnswersChannel", question_id: gon.question_id}, {
      received(data) {

        if (gon.user_id === data.answer.user_id) return;

        const template = require('../../views/mustage_templates/answer.hbs');

        data.is_question_owner = gon.user_id === gon.question_owner_id;

        answersList.append(template(data));
      }
    })
  }
});