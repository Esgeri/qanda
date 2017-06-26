class AnswersChannel < ApplicationCable::Channel
  def subscribe(data)
    stream_from "questions/#{data['question_id']}/answers"
  end
end
