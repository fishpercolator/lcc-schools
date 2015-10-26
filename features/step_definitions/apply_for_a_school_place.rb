When(/^I visit the apply schools page$/) do
  visit schools_apply_path
end

And(/^I enter a valid postcode and house number$/) do
  fill_in 'Postcode', with: 'LS8 1JN'
  fill_in 'House name or number', with: '30'

  click_link 'Which schools could I apply to?'
end

Then(/^I should see a map with my home and my five nearest community schools$/) do
  within '#map div.leaflet-marker-pane' do
    expect(page).to have_xpath('img[contains(@src, "House")]')
    expect(page).to have_xpath('img[contains(@src, "marker-icon")]', count: 5)
  end
end


Then(/^I should see a map with my home$/) do
  within '#map div.leaflet-marker-pane' do
    expect(page).to have_xpath('img[contains(@src, "House")]')
  end
end

And(/^I should see my five nearest community schools$/) do
  within '#map div.leaflet-marker-pane' do
    expect(page).to have_xpath('img[contains(@src, "marker-icon")]', count: 5)
  end
end

And(/^I should see other own admission schools$/) do
  within '#map div.leaflet-marker-pane' do
    expect(page).to have_xpath('img[contains(@src, "own-admission")]', count: @schools.count {|s| s.own_admission_policy? })
  end
end
