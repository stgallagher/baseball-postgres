# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :player_profile do
    batting_power 1
    batting_contact 1
    pitching 1
    player nil
  end
end
