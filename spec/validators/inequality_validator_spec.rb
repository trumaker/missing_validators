require 'spec_helper'

describe InequalityValidator do
  describe do
    let(:klass) do
      Class.new do
        include ActiveModel::Validations
        attr_accessor :attr
        validates :attr, inequality: { to: Proc.new { |o| "invalid value" } }
      end
    end

    subject(:model){ klass.new }

    specify "field is the same as the result of the validating proc" do
      model.attr = "invalid value"
      expect(model).to be_invalid
    end

    specify "field is not the same as the result of the validating proc" do
      model.attr = "valid value"
      expect(model).to be_valid
    end
  end

  describe do
    let(:klass) do
      Class.new do
        include ActiveModel::Validations
        attr_accessor :origin, :destination, :airline
        validates :origin, inequality: { to: :destination }
      end
    end

    subject(:model){ klass.new }

    it { should ensure_inequality_of(:origin).to(:destination) }
    it { should_not ensure_inequality_of(:origin).to(:airline) }

    specify "both fields have same values" do
      model.origin = model.destination = "MOW"
      expect(model).to be_invalid
    end

    specify "fields have different value" do
      model.origin = "NYC"
      model.destination = "MOW"
      expect(model).to be_valid
    end

    specify "first field has value, the second is nil" do
      model.origin = "NYC"
      model.destination = nil
      expect(model).to be_valid
    end

    specify "first field is nil, the second has value" do
      model.origin = nil
      model.destination = "NYC"
      expect(model).to be_valid
    end

    specify "both fields are nil" do
      model.origin = model.destination = nil
      expect(model).to be_invalid
    end
  end
end
