Given(/^there are some schools$/) do
  @schools = [
    create(:primary, :availability, name: TEST_SEARCH_TERM),
    create(:primary, :oversubscribed, address1: TEST_SEARCH_TERM),
    create(:primary, :not_all_nearest),
    create(:primary, :voluntary),
    create(:secondary, :availability)
  ]
end
