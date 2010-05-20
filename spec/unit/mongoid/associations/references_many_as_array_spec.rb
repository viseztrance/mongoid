require "spec_helper"

describe Mongoid::Associations::ReferencesManyAsArray do

  let(:block) do
    Proc.new do
      def extension
        "Testing"
      end
    end
  end

  let(:options) do
    Mongoid::Associations::Options.new(
      :name => :preferences,
      :foreign_key => "preference_ids",
      :extend => block
    )
  end

  describe "#initialize" do

    let(:person) do
      Person.new
    end

    context "when a target is not provided" do

      before do
        person.preference_ids = ["1", "2", "3"]
        @association = Mongoid::Associations::ReferencesManyAsArray.new(
          person, options
        )
        @criteria = Preference.any_in(:_id => ["1", "2", "3"])
      end

      it "sets the association options" do
        @association.options.should == options
      end

      it "sets the target to the criteria for finding by ids" do
        @association.target.should == @criteria
      end
    end

    context "when a target is provided" do
      before do
        @preferences = [
          Preference.new,
          Preference.new
        ]
        @association = Mongoid::Associations::ReferencesManyAsArray.new(
          person, options, @preferences
        )
      end

      it "sets the target to the entries provided" do
        @association.target.should == @preferences
      end
    end
  end

  describe ".instantiate" do

    let(:person) do
      Person.new
    end

    context "when a target is not provided" do

      before do
        person.preference_ids = ["1", "2", "3"]
        @association = Mongoid::Associations::ReferencesManyAsArray.instantiate(
          person, options
        )
        @criteria = Preference.any_in(:_id => ["1", "2", "3"])
      end

      it "sets the association options" do
        @association.options.should == options
      end

      it "sets the target to the criteria for finding by ids" do
        @association.target.should == @criteria
      end
    end

    context "when a target is provided" do
      before do
        @preferences = [
          Preference.new,
          Preference.new
        ]
        @association = Mongoid::Associations::ReferencesManyAsArray.instantiate(
          person, options, @preferences
        )
      end

      it "sets the target to the entries provided" do
        @association.target.should == @preferences
      end
    end
  end

  describe "#method_missing" do

    let(:person) do
      Person.new
    end

    context "when target is a criteria" do

      before do
        person.preference_ids = ["1", "2", "3"]
        @association = Mongoid::Associations::ReferencesManyAsArray.instantiate(
          person, options
        )
      end

      it "executes the criteria and sends to the result" do
        Preference.expects(:any_in).with(:_id => ["1", "2", "3"]).returns([])
        @association.entries.should == []
      end
    end

    context "when target is an array" do

    end
  end
end
