class ApplyOverride < ApplicationService
  attr_reader :record, :override

  def initialize(record:, override:)
    @record = record
    @override = override
  end

  def perform
    override
      .replacements
      .reduce(record.dup) do |acc, replacement|
      values = Hash[replacement.map do |key, value|
        [
          key.to_sym,
          value ? process_erb(value) : value
        ]
      end]
      acc.merge(values)
    end
  end

  private

  def process_erb(template)
    ERB
      .new(template)
      .result(
        TemplateContext
          .new(
            record: record
          )
          .get_binding
      )
  end

  class TemplateContext < OpenStruct
    def get_binding
      binding
    end
  end
end