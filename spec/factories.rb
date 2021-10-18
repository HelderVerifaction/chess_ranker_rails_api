FactoryBot.define do
   
    factory :member ,class: Member do
        first_name {Faker::Name.first_name}
        last_name {Faker::Name.last_name}
        email {Faker::Internet.email}
        games_played { 0 }
        club        
    end

    factory :club ,class: Club do
        name {Faker::Name}
    end
end

