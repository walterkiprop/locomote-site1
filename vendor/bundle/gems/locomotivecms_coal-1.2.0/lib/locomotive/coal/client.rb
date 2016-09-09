module Locomotive::Coal

  class Client

    attr_reader :uri, :credentials, :options

    def initialize(uri, credentials, options = {})
      if uri.blank? || credentials.blank?
        raise MissingURIOrCredentialsError.new('URI and/or credentials are missing')
      else
        @options = { path_prefix: 'locomotive' }.merge(options).with_indifferent_access
        @uri, @credentials = prepare_uri(uri), credentials.with_indifferent_access
      end
    end

    def token
      @token ||= Resources::Token.new(uri, credentials).get
    end

    def my_account
      @my_account ||= Resources::MyAccount.new(uri, connection)
    end

    def sites
      @sites ||= Resources::Sites.new(uri, connection)
    end

    def current_site
      @current_site ||= Resources::CurrentSite.new(uri, connection)
    end

    def pages
      @pages ||= Resources::Pages.new(uri, connection)
    end

    def content_types
      @content_types ||= Resources::ContentTypes.new(uri, connection)
    end

    alias :contents :content_types

    def content_entries(content_type)
      @content_entries ||= {}
      @content_entries[content_type.slug] ||= Resources::ContentEntries.new(uri, connection, content_type)
    end

    def content_assets
      @content_assets ||= Resources::ContentAssets.new(uri, connection)
    end

    def theme_assets
      @theme_assets ||= Resources::ThemeAssets.new(uri, connection)
    end

    def snippets
      @snippets ||= Resources::Snippets.new(uri, connection)
    end

    def translations
      @translations ||= Resources::Translations.new(uri, connection)
    end

    def engine_version
      @engine_version ||= Resources::EngineVersion.new(uri, connection).version
    end

    alias version engine_version

    def scope_by(site_or_handle)
      if site_or_handle.respond_to?(:handle)
        @current_site, site_or_handle = site_or_handle, site_or_handle.handle
      end
      options[:handle] = site_or_handle
      self
    end

    def reset
      @token = @my_account = @sites = @current_site = @pages = @content_types = @theme_assets = @content_assets = @translations = nil
    end

    def ssl?
      !!self.options[:ssl]
    end

    private

    def connection
      _token = credentials[:token] || -> { token }
      credentials.merge(token: _token, handle: options[:handle])
    end

    def uri_path
      [self.options[:path_prefix], 'api', 'v3'].join('/')
    end

    def prepare_uri(str)
      str = "http://#{str.to_s}" unless str.to_s =~ /^https?:\/\//

      URI(str).tap do |uri|
        if ssl?
          uri.scheme  = 'https'
          uri.port    = 443 if uri.port = 80
        end

        if uri.path == '/' || uri.path.blank?
          uri.merge!(uri_path)
        end
      end
    end

  end

end
