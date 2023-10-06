class LlmService
  attr_reader :client, :question

  def initialize(client = OpenAI::Client.new)
    @client = client
  end

  def generate_answer(question)
    @question = question
    message_to_chat(<<~CONTENT)
      Answer the question below
      using the provided context as first source of truth (process and analize the context first), complement with your current knowledge if needed,
      but don't make up any answer if you don't know just say \"I don't know\". Answer in the same language as the question.

      Context:
      #{context}

      ---

      Question: #{question}
    CONTENT
  end

  def generate_embedding_for(text)
    embedding_for(text)
  end

  private

  def message_to_chat(message_content)
    response = client.chat(parameters: {
                             model: 'gpt-3.5-turbo',
                             messages: [{ role: 'user', content: message_content }],
                             temperature: 0
                           })
    response.dig('choices', 0, 'message', 'content')
  end

  def context
    question_embedding = embedding_for(question)
    nearest_items = Item.nearest_neighbors(
      :embedding, question_embedding,
      distance: 'euclidean'
    )
    nearest_items.first&.text
  end

  def embedding_for(text)
    response = client.embeddings(
      parameters: {
        model: 'text-embedding-ada-002',
        input: text
      }
    )

    response.dig('data', 0, 'embedding')
  end
end
