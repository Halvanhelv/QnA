user1 = User.create!(email: 'john@example.com', password: 'password')
user2 = User.create!(email: 'jane@example.com', password: 'password')

# Questions
question1 = Question.create!(title: 'What is Ruby on Rails?', body: 'I am new to Ruby on Rails and would like to know more about it.', user: user1)
question2 = Question.create!(title: 'How to install Ruby on Rails?', body: 'I would like to know how to install Ruby on Rails on my machine.', user: user2)

# Answers
answer1 = Answer.create!(body: 'Ruby on Rails is a web framework written in Ruby that follows the Model-View-Controller (MVC) architecture.', question: question1, user: user2)
answer2 = Answer.create!(body: 'You can install Ruby on Rails using the command `gem install rails`.', question: question2, user: user1)

# Comments
comment1 = Comment.create!(body: 'Thank you for your answer, it was really helpful!', commentable: question1, user: user2)
comment2 = Comment.create!(body: 'I tried installing Ruby on Rails using the command you provided but it didn\'t work. Can you please provide more detailed instructions?', commentable: question2, user: user1)

# Votes
vote1 = Vote.create!(score: 1, votable: question1, user: user2)
vote2 = Vote.create!(score: -1, votable: answer1, user: user1)

# Rewards
reward1 = Reward.create(name: 'Expert Ruby on Rails Developer', question: question1, user: user1)

# Subscriptions
subscription1 = Subscription.create(user: user1, question: question2)

# Links
link1 = Link.create(name: 'Ruby on Rails Guides', url: 'https://guides.rubyonrails.org/', linkable: question1)

# OAuthApplications
application1 = Doorkeeper::Application.create(name: 'My Application', uid: '123456', secret: '654321', redirect_uri: 'https://example.com/oauth/callback', scopes: 'read write')

# OAuthAccessGrants
# grant1 = Doorkeeper::AccessGrant.create(resource_owner: user1, application: application1, token: '123456789', expires_in: 3600, redirect_uri: 'https://example.com/oauth/callback', scopes: 'read write')
#
# # OAuthAccessTokens
# token1 = Doorkeeper::AccessToken.create(resource_owner: user1, application: application1, token: '987654321', refresh_token: '1234567890', expires_in: 7200, scopes: 'read write')