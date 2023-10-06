describe 'POST api/v1/questions', type: :request do
  context 'when user is logged in' do
    subject { post api_v1_questions_path, params:, headers: auth_headers, as: :json }
    let(:question) { 'Your question here' }
    let(:params) { { question: } }
    let(:user) { create(:user) }
    let(:llm_service) { instance_double(LlmService) }

    it 'returns a successful response and calls LlmService#generate_answer' do
      allow(LlmService).to receive(:new).and_return(llm_service)
      expect(llm_service).to receive(:generate_answer).with(question)

      subject

      expect(response).to have_http_status(:ok)
    end
  end

  context 'when user is not logged in' do
    subject { post api_v1_questions_path, as: :json }

    it 'returns unauthorized status' do
      subject
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
