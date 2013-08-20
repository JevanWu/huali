shared_examples_for "ActiveModel::Full" do
  require 'test/unit/assertions'
  require 'active_model/lint'
  include Test::Unit::Assertions
  include ActiveModel::Lint::Tests

  before do
    @model = subject
  end

  ActiveModel::Lint::Tests.public_instance_methods.map { |method| method.to_s }.grep(/^test/).each do |method|
    example(method.gsub('_', ' ')) { send method }
  end
end

shared_examples_for "ActiveModel::Validations" do
  it { should respond_to(:errors) }
  it { should respond_to(:valid?) }
  it 'errors#[] return an Array' do
    subject.errors[:hello].should be_a(Array)
  end
end