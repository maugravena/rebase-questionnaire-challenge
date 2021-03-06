require 'rails_helper'

describe 'users can create questions' do
  context '#create' do
    let(:user) do
      User.create!(name: "Joana", email: "joana@teste.com")
    end

    let(:questionnaire) do
      Questionnaire.create!(name: 'Lógica', description: 'É um teste', limit_time: 2, user: user)
    end

    context 'with valid params' do
      let(:questions_params) do
        {
          id: questionnaire.id,
          questions: {
            description: 'Qual a sua idade?',
            points: 2
          }
        }
      end

      it 'returns success response' do
        post '/api/v1/pergunta', params: questions_params

        expect(response).to have_http_status(:created)
      end

      it 'should create the questions' do
        expect { post '/api/v1/pergunta', params: questions_params }.to change { Question.count }.by(1)
      end

      it 'should create with description and points' do
        post '/api/v1/pergunta', params: questions_params

        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:description]).to eq(questions_params[:description])
        expect(json[:points]).to eq(questions_params[:points])
      end
    end

    context 'with invalid params' do
      let(:questions_params) do
        {
          id: questionnaire.id,
          questions: {
            points: 2
          }
        }
      end

      it 'returns unprocessable entity response' do
        post '/api/v1/pergunta', params: questions_params

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the error message' do
        post '/api/v1/pergunta', params: questions_params

        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:errors][:description]).to include("não pode ficar em branco")
      end
    end
  end
end
