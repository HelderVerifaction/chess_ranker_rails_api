require 'rails_helper'

describe 'Member API', type: :request do
    describe 'GET /members' do
        it 'returns all members' do
            
            FactoryBot.create(:member)
            get '/clubs/1/members'
    
            expect(JSON.parse(response.body).size).to eq(1)
            expect(response).to have_http_status(:success)
            
        end
    end
    
    describe 'POST /members' do
        it 'creates a new member' do
            FactoryBot.create(:club)
            expect {
                post '/clubs/1/members', params: {member: {first_name: 'Helder', last_name: 'Fernandes', email:'helder@gmail.com'}}
            }.to change {Member.count}.from(0).to(1) 

        end
    end

    describe 'DELETE /members' do
        it 'deletes a new member' do
            FactoryBot.create(:club)
            FactoryBot.create(:member)
            expect {
                delete '/clubs/1/members/1'
            }.to change {Member.count}.from(1).to(0) 

        end
    end

    describe 'PATCH /members' do
        it 'updates a existing member' do
            FactoryBot.create(:club)
            FactoryBot.create(:member)
            
            put '/clubs/1/members/1', params: {member: {first_name: 'Helder'}}
            
            expect(response).to have_http_status(:success)

        end
    end

end

