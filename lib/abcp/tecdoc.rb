module Abcp
  class TecDoc
    include HTTParty

    attr_accessor :user_login, :user_psw, :user_key

    base_uri 'http://tecdoc.api.abcp.ru'
    format :json

    def initialize(userlogin, userpsw, userkey)
      raise ArgumentError.new('Error! API keys not valid') if userlogin.nil? || userpsw.nil? || userkey.nil?

      @user_login = userlogin
      @user_psw = userpsw
      @user_key = userkey

      self.class.default_options.merge!(headers: { 'Content-type' => 'application/x-www-form-urlencoded',
                                                   'Accept' => 'application/json' })
    end

    def manufacturers
      response = self.class.get('/manufacturers?#{user_keys}')

      JSON.parse(response.body)
    end

    def models(manufacturerId)
      raise ArgumentError.new('Error! Pass manufacturerId ') if manufacturerId.nil?

      response = self.class.get('/models?manufacturerId=#{manufacturerId}&#{user_keys}')

      JSON.parse(response.body)
    end

    private

    def user_keys
      'userlogin=#{@user_login}&userpsw=#{@user_psw}&userkey=#{@user_key}'
    end
  end
end