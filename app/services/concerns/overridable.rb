module Overridable
  extend ActiveSupport::Concern

  protected

  def override_attributes(record, overrides)
    MatchOverrides
      .new(
        record: record,
        overrides: overrides
      )
      .perform
      .reduce(record) do |acc, override|
      ApplyOverride
        .new(
          record: acc,
          override: override,
        )
        .perform
    end
  end
end
