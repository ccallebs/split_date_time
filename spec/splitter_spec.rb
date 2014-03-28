require 'spec_helper'

describe SplitDateTime::Splitter do
  context '#inclusion' do
    class TestClass
      include SplitDateTime::Splitter
    end
    let(:subject) { TestClass.new }

    it 'should create time accessors when included' do
    end

    it 'should create date accessors when included' do
    end

    it 'should create callbacks when included' do
    end

    it 'should create callback method when included' do
    end
  end

  context '#accessors' do
    it 'should correctly extract a DateTime date' do
    end

    it 'should correctly extract a DateTime time' do
    end

    it 'should correctly add specific prefix when provided' do
    end
  end

  context '#callbacks' do
    it 'should correctly concatenate a field Date/Time together' do
    end
  end
end
