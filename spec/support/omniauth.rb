OmniAuth.config.test_mode = true

TWITTER_OAUTH_RESPONSE = {
  "provider"  =>  "twitter", 
  "uid"       =>  "6584842", 
  "random_trash" => "why is this even here?",
  "info" => {
    "nickname"        =>  "willmarshall", 
    "name"            =>  "Will Marshall", 
    "location"        =>  "Wellington, New Zealand", 
    "image"           =>  "http://a3.twimg.com/profile_images/344764293/swans_normal.jpg", 
    "description"     =>  "A description of Will", 
    "urls"            =>  {
      "Website"   =>  "http://soundcloud.com/willmarshall", 
      "Twitter"   =>  "http://twitter.com/willmarshall"
    }
  }
}

MYSPACE_OAUTH_RESPONSE = {
  "provider"     => "myspace",
  "uid"          => "myspace.com:384178151",
  "nickname"     => "johnf",
  "profileUrl"   => "http://www.myspace.com/384178151",
  "thumbnailUrl" => "http://x.myspacecdn.com/images/no_pic.gif",
  "info"     => {
    "id"       => "myspace.com:384178151",
    "image"    => "http://x.myspacecdn.com/images/no_pic.gif",
    "name"     => "johnf",
    "nickname" => "johnf",
  }
}

FACEBOOK_OAUTH_RESPONSE = {
  "provider"    => "facebook",
  "random_trash" => "why is this even here?",
  "uid"         => "532287403", 
  "credentials" => {"token" => "AAACLKT94fL4BAMUn0CE0d6JCLBVwdmuDvVr59hoYamjZAvTCU3ZCpUAhJ2icD8K1KpbXw52ZB1FPq9VGgReeu7biIVWGUEZD"},
  "info" => {
    "nickname"   => "WillMarshallBreaks", 
    "email"      => "willrj.marshall@gmail.com", 
    "first_name" => "Will", 
    "last_name"  => "Marshall", 
    "name"       => "Will Marshall", 
    "image"      => "http://graph.facebook.com/532287403/picture?type=square", 
    "urls"       => { 
      "Facebook"    => "http://www.facebook.com/WillMarshallBreaks", 
      "Website"     => nil
    }
  },
  "extra" => { 
    "user_hash" => {
      "id"           => "532287403", 
      "name"         => "Will Marshall", 
      "first_name"   => "Will", 
      "last_name"    => "Marshall", 
      "link"         => "http://www.facebook.com/WillMarshallBreaks", 
      "username"     => "WillMarshallBreaks", 
      "hometown"     => {"id" => "107847249250173", "name" => "Cambridge, Cambridgeshire"},
      "location"     => {"id"=>"114912541853133",   "name" => "Wellington, New Zealand"},
      "bio"          => "I'm a DJ, hacker, burner and general trouble-maker. I am primcore.", 
      "gender"       => "male", 
      "email"        => "willrj.marshall@gmail.com", 
      "timezone"     => 11, 
      "locale"       => "en_GB", 
      "updated_time" =>"2011-06-07T05:27:38+0000"
    }
  }
}


OmniAuth.config.mock_auth[:twitter]  = TWITTER_OAUTH_RESPONSE
OmniAuth.config.mock_auth[:facebook] = FACEBOOK_OAUTH_RESPONSE
OmniAuth.config.mock_auth[:myspace]  = MYSPACE_OAUTH_RESPONSE
