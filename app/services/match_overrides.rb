class MatchOverrides < ApplicationService
  attr_reader :record, :overrides

  def initialize(record:, overrides:)
    @record = record
    @overrides = overrides
  end

  def perform
    matching_overrides
  end

  private

  def matching_overrides
    overrides.select do |override|
      override_matches?(override)
    end
  end

  def override_matches?(override)
    override.matches.any? do |match|
      match.all? do |key, match_value|
        record_value = record.public_send(key.to_sym)
        value_matches?(match_value, record_value)
      end
    end
  end

  def value_matches?(match, value)
    value.to_s.match?(Regexp.new(match))
  end
end