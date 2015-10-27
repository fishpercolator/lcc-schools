class PostcodeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    ukpc = UKPostcode.parse(value)
    case
    when !ukpc.valid?
      record.errors[attribute] << 'not recognised as a UK postcode'
    when !ukpc.full_valid?
      record.errors[attribute] << 'must be a full UK postcode'
    end
  end
end
