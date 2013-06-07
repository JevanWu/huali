require 'spec_helper'

describe DateRule do

  describe '#apply_test' do
    before(:each) do
      @start = '2013-01-01'
      @end = '2013-12-31'
    end

    let(:daterule) do
      daterule = DateRule.new range: [@start, @end]
    end

    it 'tests against valid Date string' do
      ['2013-02-03', '20130203', '3rd Feb 2013'].each do |date|
        daterule.apply_test(date).should be_true
      end
    end

    it 'tests against Date object' do
      date = Date.new(2013,2,3)
      daterule.apply_test(date).should be_true
    end

    context 'when ranges' do
      it 'has no start limit when range starts with nil' do
        daterule = DateRule.new range: [nil, @end]
        date = Date.new(0)
        daterule.apply_test(date).should be_true
      end

      it 'has no end limit when range ends with nil' do
        daterule = DateRule.new range: [@start, nil]
        date = Date.new(2099, 12, 31)
        daterule.apply_test(date).should be_true
      end

      it 'has no end limit when range is nil' do
        daterule = DateRule.new range: nil
        [Date.new(2099, 12, 31), Date.new(0)].each do |date|
          daterule.apply_test(date).should be_true
        end
      end
    end

    context 'when exclude' do
      it 'a single date string' do
        daterule = DateRule.new range: [@start, @end], exclude: '2013-02-03'
        date = Date.new(2013,2,3)
        daterule.apply_test(date).should be_false
      end

      it 'an array of single date strings' do
        daterule = DateRule.new range: [@start, @end], exclude: ['2013-02-03', '2013-02-05']
        [Date.new(2013,2,3), Date.new(2013,2,5)].each do |date|
          daterule.apply_test(date).should be_false
        end
      end

      it 'a Date object' do
        daterule = DateRule.new range: [@start, @end], exclude: Date.new(2013,2,3)
        date = Date.new(2013,2,3)
        daterule.apply_test(date).should be_false
      end

      it 'an array of Date objects' do
        daterule = DateRule.new range: [@start, @end], exclude: [Date.new(2013,2,3), Date.new(2013,2,5)]
        [Date.new(2013,2,3), Date.new(2013,2,5)].each do |date|
          daterule.apply_test(date).should be_false
        end
      end
    end

    context 'when include' do
      it 'a single date string' do
        daterule = DateRule.new range: [@start, @end], include: '2014-02-03'
        date = Date.new(2014,2,3)
        daterule.apply_test(date).should be_true
      end

      it 'an array of single date strings' do
        daterule = DateRule.new range: [@start, @end], include: ['2014-02-03', '2014-02-05']
        [Date.new(2014,2,3), Date.new(2014,2,5)].each do |date|
          daterule.apply_test(date).should be_true
        end
      end

      it 'a Date object' do
        daterule = DateRule.new range: [@start, @end], include: Date.new(2014,2,3)
        date = Date.new(2014,2,3)
        daterule.apply_test(date).should be_true
      end

      it 'an array of Date objects' do
        daterule = DateRule.new range: [@start, @end], include: [Date.new(2014,2,3), Date.new(2014,2,5)]
        [Date.new(2014,2,3), Date.new(2014,2,5)].each do |date|
          daterule.apply_test(date).should be_true
        end
      end

      it 'overrides exclude dates' do
        daterule = DateRule.new range: [@start, @end], exclude: '2013-02-04', include: ['2013-02-04']
        date = Date.new(2013,2,3)
        daterule.apply_test(date).should be_true
      end
    end

    context 'with generic keep_if filters' do
      it 'accepts date which passes the rule' do
        filter = lambda { |date| date.monday? }
        daterule = DateRule.new range: [@start, @end], keep_if: filter

        monday = Date.new(2013,6,10)
        tuesday = Date.new(2013,6,11)
        daterule.apply_test(monday).should be_true
        daterule.apply_test(tuesday).should be_false
      end

      it 'accepts date which passes any one of the rules' do
        filter1 = lambda { |date| date.monday? }
        filter2 = lambda { |date| date.tuesday? }
        daterule = DateRule.new range: [@start, @end], keep_if: [filter1, filter2]

        monday = Date.new(2013,6,10)
        tuesday = Date.new(2013,6,11)
        wednesday = Date.new(2013,6,12)
        daterule.apply_test(monday).should be_true
        daterule.apply_test(tuesday).should be_true
        daterule.apply_test(wednesday).should be_false
      end
    end

    context 'with generic delete_if filters' do
      it 'excludes date which passes the rule' do
        filter = lambda { |date| date.monday? }
        daterule = DateRule.new range: [@start, @end], delete_if: filter

        monday = Date.new(2013,6,10)
        tuesday = Date.new(2013,6,11)
        daterule.apply_test(monday).should be_false
        daterule.apply_test(tuesday).should be_true
      end

      it 'excludes date which matches any one of the rules' do
        filter1 = lambda { |date| date.monday? }
        filter2 = lambda { |date| date.tuesday? }
        daterule = DateRule.new range: [@start, @end], delete_if: [filter1, filter2]

        monday = Date.new(2013,6,10)
        tuesday = Date.new(2013,6,11)
        wednesday = Date.new(2013,6,12)
        daterule.apply_test(monday).should be_false
        daterule.apply_test(tuesday).should be_false
        daterule.apply_test(wednesday).should be_true
      end
    end
  end
end

