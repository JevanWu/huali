require 'spec_helper_lite'
require 'utils'

describe Utils do
  describe ".split_collection_array" do
    let(:collections) { [1, 2, 3, 4] }
    subject { Utils.split_collection_array(collections) }

    context "when collection array is a empty array" do
      let(:collections) { [] }

      it { should == [[], []] }
    end

    context "when collection array has 1 element" do
      let(:collections) { [1] }

      it { should == [[1], []] }
    end

    context "when collection array has 2 element" do
      let(:collections) { [1, 2] }

      it { should == [[1, 2], []] }
    end

    context "when collection array has 3 element" do
      let(:collections) { [1, 2, 3] }

      it { should == [[1, 3], [2]] }
    end

    context "when collection array has 4 element" do
      let(:collections) { [1, 2, 3, 4] }

      it { should == [[1, 3], [2, 4]] }
    end

    context "when collection array has 5 element" do
      let(:collections) { [1, 2, 3, 4, 5] }

      it { should == [[1, 3, 5], [2, 4]] }
    end

    context "when collection array has 6 element" do
      let(:collections) { [1, 2, 3, 4, 5, 6] }

      it { should == [[1, 3, 5], [2, 4, 6]] }
    end
  end
end
