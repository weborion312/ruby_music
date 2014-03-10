module ApplicationHelper

  def close_link
    content_tag :a,  "x", {:class => 'close'}, :href => "#"
  end

  def registration_title session={}
    if session.include?('oauth')
      title = 'Please update the followng details in order to complete your
      registration'
    else
      title = 'Create New Account'
    end
    content_tag :h3, title
  end

  def popup_title title, color='pink'
    content_tag :div, {:class => "title #{color}"}, false do
      content_tag :h2 do
        if current_user
          link_to(title, profile_path(current_user)).html_safe
        else
          title
        end
      end
    end
  end

  def flashes *types
    types.map do |type|
      content_tag :div, {:class => "flash #{type}"}, false do
        msg = (flash[type].to_s + " (click to close)")
        content_tag(
                :div,
                (content_tag(
                         :a, msg,
                         :class => "#{type}",
                         :href => "#",
                         :onclick => "$('.flash').fadeOut(); return false;")),
                :id => type,
                :class => "flash_#{type}") unless flash[type].blank?
      end if flash[type].present?
    end.join("\n").html_safe
  end

  # We use this to render a JSON partial from inside a HTML file
  def with_format format, &block
    old_formats = formats
    begin
      self.formats = [format]
      return block.call
    ensure
      self.formats = old_formats
    end
  end

  def render_addthis
    render :partial => 'shared/addthis' unless (Rails.env.test? || Rails.env.development?)
  end
end
