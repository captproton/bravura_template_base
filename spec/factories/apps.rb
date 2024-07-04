require 'ostruct'

FactoryBot.define do
  factory :app, class: OpenStruct do
    initialize_with do
      OpenStruct.new(
        config: OpenStruct.new(
          assets: OpenStruct.new(
            paths: [],
            precompile: []
          )
        )
      )
    end
  end
end
