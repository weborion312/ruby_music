require 'spec_helper'

describe ApplicationHelper do
  context 'flashes' do
    %w[alert notice warning error].each do |type|
      it "should show #{type.pluralize}" do
        flash[:"#{type}"] = 'foobar'
        flashes(:"#{type}").should include "<div class=\"flash #{type}\"><div class=\"flash_#{type}\" id=\"#{type}\"><a class=\"#{type}\" href=\"#\" onclick=\"$('.flash').fadeOut(); return false;\">foobar (click to close)</a></div></div>"
      end
    end
  end
end
