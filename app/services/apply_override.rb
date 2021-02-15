class ApplyOverride < ApplicationService
  attr_reader :record, :replacements

  def initialize(record:, replacements:)
    @record = record
    @replacements = replacements
  end

  def perform
    replacements.map do |replacement|
      values = Hash[replacement.map do |key, value|
        [
          key,
          value ? process_erb(value) : value
        ]
      end]
      record.assign_attributes(values)
    end
    record
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