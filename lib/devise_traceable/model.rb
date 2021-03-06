require 'devise_traceable/hooks/traceable'

module Devise
  module Models
    # Trace information about your user sign in. It tracks the following columns:

    # * resource_id
    # * sign_in_at
    # * sign_out_at
    # * ip_address

    module Traceable
      def stamp_out!
        self.stamp_out!(nil)
      end

      def stamp_out!(user_agent)
        ActivityStream.create(:ip_address => self.current_sign_in_ip,
                              :action => "Logout",
                              "#{self.class}".foreign_key.to_sym => self.id,
                              :notes => { :user_agent => user_agent }.to_yaml)
      end

      def stamp_in!
        self.stamp_in!(nil)
      end

      def stamp_in!(user_agent)
        ActivityStream.create(:ip_address => self.current_sign_in_ip,
                              :action => "Login",
                              "#{self.class}".foreign_key.to_sym => self.id,
                              :notes => { :user_agent => user_agent }.to_yaml)
      end

      def stamp_password_changed!
        ActivityStream.create(:ip_address => self.current_sign_in_ip, :action => "Password Changed", "#{self.class}".foreign_key.to_sym => self.id)
      end
    end
  end
end
