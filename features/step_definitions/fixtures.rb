Given(/^there are some schools$/) do
  @schools = [
    create(:primary, :availability, name: TEST_SEARCH_TERM),
    create(:primary, :oversubscribed, address1: TEST_SEARCH_TERM),
    create(:primary, :not_all_nearest),
    create(:primary, :own_admissions_policy),
    create(:secondary, :availability)
  ]
end

Given(/^there is a school with some priority data$/) do
  @school = create :school, :with_priority_data
end
