require 'rails_helper'

describe 'Club API', type: :request do
    describe 'GET /clubs' do
        it 'returns all clubs' do
            
            FactoryBot.create(:club)
            FactoryBot.create(:club)
            get '/clubs'
    
            expect(JSON.parse(response.body).size).to eq(2)
            expect(response).to have_http_status(:success)
            
            
        end
    end
    
    describe 'DELETE /clubs' do
        it 'deletes a club' do
            
            FactoryBot.create(:member)
            expect {
                delete '/clubs/1'
            }.to change {Club.count}.from(1).to(0) 
            .and change { Member.count }.from(1).to(0)

        end
    end


    describe 'PATCH /clubs' do
        it 'updates a existing club' do
            FactoryBot.create(:club)
            
            put '/clubs/1', params: {club: {name: 'Helder Club'}}
            
            expect(response).to have_http_status(:success)

        end
    end

   
    
end