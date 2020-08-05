import consumer from "./consumer"

$(document).on('turbolinks:load', function () {

  consumer.subscriptions.create({ channel: "CommentsChannel", question_id: gon.question_id}, {
    received(data) {

      if (gon.user_id === data.comment.user_id) return;

      const template = require('./handlebars/comment.hbs');
      if (data.type === 'answer') {
        $(`#${data.type}-id-${data.id} .answer_comments`).append(template(data));
      }
      else
      {
        $(`#question .question_comments`).append(template(data));
      }
    }
  })
});

