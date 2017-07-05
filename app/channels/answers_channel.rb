class AnswersChannel < ApplicationCable::Channel
  def subscribed
    stream_from "answers-question-#{params['question_id']}"
  end
end
