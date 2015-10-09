module Sortable
  extend ActiveSupport::Concern

  included do
    before_validation :set_initial_position, if: :new_record?
    validates :position,
      presence: true,
      numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    after_destroy :adjust_positions
  end

  private

  def set_initial_position
    self.position ||= sortable_scope.count
  end

  def adjust_positions
    sortable_scope.select { |r| r.position >= position }.each do |record|
      record.update(position: record.position - 1)
    end
  end
end
