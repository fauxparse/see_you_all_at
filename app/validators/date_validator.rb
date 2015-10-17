class DateValidator < ActiveModel::Validator
  def validate(record)
    record.errors.add(:ends_on, :invalid) if record.starts_on > record.ends_on
  end
end
