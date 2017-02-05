require 'rails_helper'

RSpec.describe 'Books API' do
  let!(:user) { create(:user) }
  let!(:books) { create_list(:book, 20, user_id: user.id) }
  let(:user_id) { user.id }
  let(:id) { books.first.id }

  describe 'GET /users/:user_id/books' do
    before { get "/users/#{user_id}/books" }

    context 'when user exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all user books' do
        expect(json.size).to eq(20)
      end
    end

    context 'when user does not exist' do
      let(:user_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find User/)
      end
    end
  end

  describe 'GET /users/:user_id/books/:id' do
    before { get "/users/#{user_id}/books/#{id}" }

    context 'when user book exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the book' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when user books does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Book/)
      end
    end
  end

  describe 'POST /users/:user_id/books' do
    let(:valid_attributes) { { title: 'Visit Narnia', description: 'this is demo' } }

    context 'when request attributes are valid' do
      before { post "/users/#{user_id}/books", params: valid_attributes }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      before { post "/users/#{user_id}/books", params: {} }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: Title can't be blank/)
      end
    end
  end

  describe 'PUT /users/:user_id/books/:id' do
    let(:valid_attributes) { { title: 'Mozart' } }

    before { put "/users/#{user_id}/books/#{id}", params: valid_attributes }

    context 'when book exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'updates the book' do
        updated_book = Book.find(id)
        expect(updated_book.title).to match(/Mozart/)
      end
    end

    context 'when the book does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Book/)
      end
    end
  end

  describe 'DELETE /users/:id' do
    before { delete "/users/#{user_id}/books/#{id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end