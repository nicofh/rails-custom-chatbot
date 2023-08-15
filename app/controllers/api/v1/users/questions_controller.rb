module Api
  module V1
    module Users
      class QuestionsController < Api::V1::ApiController
        skip_before_action :authenticate_user!
        skip_after_action :verify_authorized, :verify_policy_scoped

        def create
          @answer = LlmService.new.generate_answer(question)
        end

        private

        def question
          params.require(:question)
        end
      end
    end
  end
end
