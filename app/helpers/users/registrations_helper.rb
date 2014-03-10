module Users::RegistrationsHelper
  def terms_and_conditions
    @t_and_c.content.html_safe
  end
end
