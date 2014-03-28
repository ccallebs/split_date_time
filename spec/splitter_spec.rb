require 'spec_helper'

describe SplitDateTime::Splitter do

  class TestClass
    include SplitDateTime::Splitter

    attr_accessor :test_field_1, :test_field_2

    split_date_time :test_field_1
    split_date_time :test_field_2, prefix: :other
  end

  context '#initialization' do
    let(:subject) { TestClass.new }

    it 'should create time accessors when initialized' do
      subject.should respond_to(:test_field_1_time)
    end

    it 'should create date accessors when initialized' do
      subject.should respond_to(:test_field_1_date)
    end

    it 'should create callback method when initialized' do
      subject.should respond_to(:concatenate_test_field_1)
    end
  end

  context '#accessors' do
    let(:subject) { TestClass.new }

    it 'should extract a DateTime date' do
      subject.test_field_1 = DateTime.parse("03/03/2014 01:15:24 AM")
      subject.test_field_1_date.should eq "03/03/2014"
    end

    it 'should extract a DateTime time' do
      subject.test_field_1 = DateTime.parse("03/03/2014 01:15:24 AM")
      subject.test_field_1_time.should eq "01:15"
    end

    it 'should add specific prefix when provided' do
      subject.should respond_to(:other_date)
      subject.should respond_to(:other_time)
    end
  end

  context '#callbacks' do
    let(:subject) { TestClass.new }

    it 'should concatenate date/time together' do
      subject.test_field_1_date = '03/03/2014'
      subject.test_field_1_time = '01:15'
      subject.concatenate_test_field_1.should eq "Mon, 03 Mar 2014 01:15:00 +0000"
    end

    it 'should concatenate date/time together when only one was touched' do
      subject.test_field_1 = DateTime.parse("03/03/2014 01:15:24 AM")
      subject.test_field_1_date = '05/05/2014'
      subject.concatenate_test_field_1.should eq "Mon, 05 May 2014 01:15:00 +0000"
    end

    it 'should show field as modified if both date and time are touched' do
      subject.test_field_1_date = '03/03/2014'
      subject.test_field_1_time = '01:15'
      subject.test_field_1_modified?.should be_true
    end

    it 'should show field as modified if only date or time were touched' do
      subject.test_field_1 = DateTime.parse("03/03/2014 01:15:24 AM")
      subject.test_field_1_date = '05/05/2014'
      subject.test_field_1_modified?.should be_true
    end
  end
end
