import consumer from "./consumer"
$(document).on('turbolinks:load', function() {
console.log(consumer.subscriptions)
  // consumer.subscriptions.remove({channel: "QuestionsChannel", question_id: gon.id})
  if (consumer.subscriptions['subscriptions'].length > 0) {
    consumer.subscriptions.remove(consumer.subscriptions['subscriptions'][0])
  }

  if (gon.id) {
    consumer.subscriptions.create("QuestionsChannel", {

      connected() {
        this.perform("question" , { question_id: gon.id })
      },

      disconnected() {},
      received(data) {
        console.log(data)
        alert('GACHIBASS')

      }
    })
  }
  if ($(".question_list").length) {
    consumer.subscriptions.create("QuestionsChannel", {

      connected() {
        this.perform("questions")
      },

      disconnected() {},

      received(data) {
        $('.question_list').append('<p class="list-group-item list-group-item-action"><a href="/questions/' + data.id + '">' + data.title + '</a></p>')
        console.log(data.title)
      }
    })
  }
  else
  {

  }

})