require 'spec_helper'

describe IuMoip::XML do
  context '#general methods' do
    it '#format_money' do
      subject.format_money(1.01).should == '1.01'
      subject.format_money(4.6).should == '4.60'
      subject.format_money(107695966.6345345).should == '107695966.63'
      subject.format_money(6.6385345).should == '6.64'
    end
  end
end