FactoryGirl.define do
  sequence :code do |ref|
    "#{ref}"
  end

  factory :school do
    code
    phase 'Primary'
    name 'Schoolton school'
    headteacher 'Mr. Head'
    address1 'School street'
    address2 'Schooltown'
    address3 'Leeds'
    website 'http://somewhere'
    available_places 30

    centroid {
      RGeo::Geographic.spherical_factory(srid: 4326).point(-1.47486759802822, 53.8426310787134)
    }

    factory :primary
    factory :secondary do
      phase 'Secondary'
    end

    trait :availability do
      number_of_admissions 29
    end

    trait :oversubscribed do
      number_of_admissions 30
      nearest 1.4
    end

    trait :not_all_nearest do
      number_of_admissions 30
      not_all_nearest true
    end

    trait :with_priority_data do
      priority1a 1
      priority1b nil
      priority2 14
      priority3 nil
      priority4 12
      priority5 3
    end

    trait :own_admissions_policy do
      name 'Schoolton school (Voluntary aided)'
    end
  end
end
