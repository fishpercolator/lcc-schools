Given(/^there are some schools$/) do
  @schools = [
    create(:primary, :availability),
    create(:primary, :oversubscribed),
    create(:primary, :not_all_nearest),
    create(:primary, :voluntary),
    create(:secondary, :availability)
  ]
end
