require 'digest/md5'

class Users::OmniauthController < Devise::OmniauthCallbacksController

  User::OAUTH_PROVIDERS.each do |provider|
    class_eval %Q{
      def #{provider}
        provider_callback
      end
    }
  end

  def passthru
    render :file => "#{Rails.root}/public/404",
    :formats => [:html],
    :status => 404,
    :layout => false
  end

  private

  def provider_callback
    if request.env['omniauth.error'].present?
      flash[:error] = t('devise.omniauth_callbacks.failure',
                        :kind => auth_hash['provider'],
                        :reason => 'User was not valid')
      redirect_to root_url + '#!/users/sign_up'
      return
    end

    user = User.find_for_oauth(auth_hash['provider'], auth_hash['uid'])
    if user.present?
      user.update_omniauth_data(auth_hash)
      sign_in_and_redirect user, :event => :authentication
    elsif current_user
      current_user.register_with_oauth(auth_hash['uid'], auth_hash['provider'])
      redirect_to root_url + "#!" + profile_path(current_user)
    else
      set_session(auth_hash)
      session[:tmp_provider] = auth_hash['provider'].to_s

      # We can do this because the oauth response is in the session
      # So if we load Home with this Backbone route
      # Then Backbone will Ajax fetch sign_up
      # And sign_up will pluck the Oauth response out of the session
      redirect_to root_url + "#!/users/sign_up"
    end
  end

  def set_session(omniauth_result)
    case omniauth_result["provider"]
    when "facebook"
      session[:oauth_response] = {
        "provider" => omniauth_result["provider"],
        "uid"      => omniauth_result["uid"],
        "extra"    => omniauth_result["extra"],
        "info"     => omniauth_result["info"]
      }
    when "twitter"
      session[:oauth_response] = {
        "provider" => omniauth_result["provider"],
        "uid"      => omniauth_result["uid"],
        "info"     => omniauth_result["info"]
      }
    when "myspace"
      session[:oauth_response] = {
        "provider" => omniauth_result["provider"],
        "uid"      => omniauth_result["uid"],
        "info"     => omniauth_result["info"]
      }
    end
  end

  def auth_hash
    request.env["omniauth.auth"]
  end
end
