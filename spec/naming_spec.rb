require 'spec_helper'

describe SplitDateTime::Splitter::Naming do
  it 'should use prefix if one is provided' do
    SplitDateTime::Splitter::Naming.prefix_or_field(:test_field, :test).should eq 'test'
  end

  it 'should use field name if no prefix is provided' do
    SplitDateTime::Splitter::Naming.prefix_or_field(:test_field).should eq 'test_field'
  end

  it 'should correctly format date getter' do
    SplitDateTime::Splitter::Naming.date_getter(:test_field).should eq 'test_field_date'
  end

  it 'should correctly format time getter' do
    SplitDateTime::Splitter::Naming.time_getter(:test_field).should eq 'test_field_time'
  end

  it 'should correctly format date setter' do
    SplitDateTime::Splitter::Naming.date_setter(:test_field).should eq 'test_field_date='
  end

  it 'should correctly format time setter' do
    SplitDateTime::Splitter::Naming.time_setter(:test_field).should eq 'test_field_time='
  end
end
