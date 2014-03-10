Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.env.test?
    provider :twitter
    provider :facebook
    provider :myspace
  else
    # Put env independant ones here
    provider :twitter, 'DZMMxWffrzlvXovjTHKxzw', 'uM1nsy8b2HRyA4GyWc2Sz4tNBF9JYpUrnjcMDaMMI'

    case Rails.env
    when 'production'
      provider :facebook, '202006839921513', '03d2c33bb336427f4fcebd03a7039574'
      provider :myspace, '97a76a31ff9b44fe97d209f2d1fa5439', '1d7d9a5dd2da4048b5e35a08344912686f36647c161749e8bfbd07acd22118ef'
    when 'development'
      provider :facebook, '343292745743018', '9d78058239885ac62a11a8b0fd5e4198'
      provider :myspace, 'e6ac65af41314092a5fd19b77e4f4fdd', '25ba5813bc2241f8bb5002f9936232a78cae1e0f9121457cb69d08a3adb9dfad'
    when 'staging'
      provider :facebook, '229959557120464', 'a193f707d704bbfbb791c0aaff04f81d'
      provider :myspace, 'cb482aa995104fbd97b0e107cbbe00de', '75ce724798934ae99ee8e73049e886be65fc3906dfcf454a970a54e0cecc0f8c'
    when 'uat'
      provider :facebook, '228950510555330', '722e4b9881dd81c422bff71540a09449'
      provider :myspace, '0f459e2debb546b488d88bfb1362eef4', 'cb9817b6d2e64c1690e63d1d84f2d8f75dc606a193a54086b94fb394b73d0bf1'
    else
      raise 'oauth keys unsupported env'
    end
  end
end
