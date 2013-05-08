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

  describe '#hk?' do
    it 'detects hk number' do
      numbers['hk'].each do |num|
        PhoneNumber.new(num).should be_hk, "the number is #{num}"

      end
    end

    it 'doesnt mistake number which is not hk' do
      numbers.except('hk').values.flatten.each do |num|
        PhoneNumber.new(num).should_not be_hk, "the number is #{num}"

      end
    end
  end

  describe '#us?' do
    it 'detects us number' do
      numbers['us'].each do |num|
        PhoneNumber.new(num).should be_us, "the number is #{num}"
      end
    end

    it 'doesnt mistake number which is not us' do
      numbers.except('us').values.flatten.each do |num|
        PhoneNumber.new(num).should_not be_us, "the number is #{num}"
      end
    end
  end
end
