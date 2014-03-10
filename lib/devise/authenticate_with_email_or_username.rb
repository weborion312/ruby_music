module Devise
  module AuthenticateWithEmailOrUsername
    def self.included(base)
      base.class_eval do

        attr_accessor :login

        def self.find_for_database_authentication(warden_conditions)
          conditions = warden_conditions.dup
          login = conditions.delete(:login)
          where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
        end

      end
    end
  end
end
