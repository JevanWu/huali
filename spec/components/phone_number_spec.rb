# encoding: utf-8
require 'spec_helper'
require 'active_support/core_ext/hash/except'
require 'pry'

describe PhoneNumber do
  numbers_fixture = File.join(File.dirname(__FILE__), 'phone_number_fixture.yml')
  numbers = YAML.load_file(numbers_fixture)

  describe '#number' do
    it 'removes whitespaces' do
      PhoneNumber.new("155 0213 2136 ").number.should == "15502132136"
    end

    it 'removes ( and )' do
      PhoneNumber.new("(852)95198660").number.should == "85295198660"
    end

    it 'removes -' do
      PhoneNumber.new("021-55034540").number.should == "02155034540"
    end

    it 'preserves leading +' do
      PhoneNumber.new("+447784663458").number.should == "+447784663458"
    end
  end

  %w(hk us uk au no de it sg fr).each do |country|
    describe "##{country}?" do
      it "detects #{country} number" do
        numbers[country].each do |num|
          PhoneNumber.new(num).send(:"#{country}?").should be_true, "the number is #{num}; the country is #{country}"
        end
      end

      it "doesnt mistake number which is not #{country}" do
        numbers.except(country).values.flatten.each do |num|
          PhoneNumber.new(num).send(:"#{country}?").should_not be_true, "the number is #{num}; the country is #{country}"
        end
      end
    end
  end

  describe '#international?' do
    it 'detects international numbers' do
      numbers.except('other').values.flatten.each do |num|
        PhoneNumber.new(num).should be_international, "the number is #{num}"
      end
    end

    it 'doesnt mistake domestic numbers' do
      numbers['other'].each do |num|
        PhoneNumber.new(num).should_not be_international, "the number is #{num}"
      end
    end
  end

  describe '#domestic?' do
    it 'detects domestic numbers' do
      numbers.except('other').values.flatten.each do |num|
        PhoneNumber.new(num).should_not be_domestic, "the number is #{num}"
      end
    end

    it 'doesnt mistake domestic numbers' do
      numbers['other'].each do |num|
        PhoneNumber.new(num).should be_domestic, "the number is #{num}"
      end
    end
  end
end
