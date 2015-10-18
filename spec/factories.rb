FactoryGirl.define do  factory :backup do
    frequency "MyString"
  end
  
	factory :ftp_connector do
		username "thelocalpress"
		password "ghourdy123$"
		host "103.18.109.102"
		port "21"
		user_id "1"
  	end
  
	factory :connector do
		username "thelocalpress"
		password "ghourdy123$"
		user_id "1"
	end

	factory :user do
		email  "ratelade.benjamin@gmail.com"
		password "qwert123$"
	end
end