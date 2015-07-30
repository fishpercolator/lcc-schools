When(/^I visit the explore schools page$/) do
  visit '/schools'
end

Then(/^I should see a map of all the schools$/) do
  expect(page).to have_selector('#map')
  expect(page).to have_selector('.leaflet-marker-icon', count: @schools.count)
end

And(/^I should see a list of all the schools with coloured badges indicating whether they were oversubscribed$/) do
  within 'table.schools' do
    expect(page).to have_selector('.badge-contention-low', count: 2)
    expect(page).to have_selector('.badge-contention-medium', count: 1)
    expect(page).to have_selector('.badge-contention-high', count: 1)
    expect(page).to have_selector('.badge-contention-unknown', count: 1)
  end
end

When(/^I filter by community admission policy$/) do
  within '.filter-type .admission-policy' do
    click_link 'Community'
  end
end

Then(/^I should see only schools with a community admission policy$/) do
  save_screenshot('/Users/russ/Desktop/foo.png')
  within 'table.schools' do
    expect(page).to have_selector('.school', count: @schools.count(&:community_admission_policy?))
  end
end
