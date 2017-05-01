class SearchResultsMailer < ApplicationMailer
  default from: 'Chuck Norris Facts <no-reply@chucknorris.io>'

  def send_results(message)
    @message = message
    mail(to: @message.email, subject: "Your search results")
  end
end
