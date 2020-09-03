import consumer from "./consumer"

consumer.questions_subscribe = consumer.subscriptions.create('QuestionsChannel', {
    connected: function() {
      return subscribeToQuestions();
    },
    received: function(data) {
      $('.question_list').append('<p class="list-group-item list-group-item-action"><a href="/questions/' + data.id + '">' + data.title + '</a></p>')
    }
  });


  var subscribeToQuestions;

  subscribeToQuestions = function() {
    var current_page;
    current_page = document.location.pathname;
    if (current_page === '/' || current_page === 'questions') {
      return consumer.questions_subscribe.perform('follow');
    }  else {
      return consumer.questions_subscribe.perform('unfollow');
    }
  };
$(document).on('turbolinks:load', function() {
  return subscribeToQuestions();
});