When(/^I visit that school's page$/) do
  visit school_path(@school)
end

Then(/^I should see that school's details$/) do
  steps '
    Then I should see that "Address" is "Schoolton school"
    And I should see that "Head teacher" is "Mr. Head"
    And I should see that "Website" is "http://somewhere"
  '
end

Then(/^I should see that "(.+)" is "(.+)"$/) do |name, value|
  within '.school-details' do
    expect(page).to have_selector('dt', text: name)
    expect(page).to have_selector('dd', text: value)
  end
end

And(/^I should see a graph showing how places were allocated$/) do
  within '.admissions-graph' do
    expect(page).to have_selector('dt', text: 'Priority 1a')
    expect(page).to have_selector('dd label', text: '1')
    expect(page).to have_selector('dd .priority.priority1a')
    expect(page).to have_selector('dd .priority.priority1b')
    expect(page).to have_selector('dd .priority.priority2')
    expect(page).to have_selector('dd .priority.priority3')
    expect(page).to have_selector('dd .priority.priority4')
    expect(page).to have_selector('dd .priority.priority5')
  end
end
