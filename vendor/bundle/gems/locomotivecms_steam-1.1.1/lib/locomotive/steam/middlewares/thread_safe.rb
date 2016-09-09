module Locomotive::Steam::Middlewares

  class ThreadSafe

    attr_accessor_initialize :app
    attr_accessor :env

    def call(env)
      threadsafed = dup
      threadsafed.env = env

      # time = Benchmark.realtime do
      threadsafed._call # thread-safe purpose
      # end

      # puts "[Benchmark][#{self.class.name}] Time elapsed #{time*1000} milliseconds"

      threadsafed.next
    end

    def next
      # avoid to be called twice
      @next_response || (@next_response = app.call(env))
    end

    #= Shortcuts =

    def services
      @services ||= env.fetch('steam.services')
    end

    def request
      @request ||= env.fetch('steam.request')
    end

    def site
      @site ||= env.fetch('steam.site')
    end

    def page
      @page ||= env.fetch('steam.page')
    end

    def path
      @path ||= env.fetch('steam.path')
    end

    def locale
      @locale ||= env.fetch('steam.locale')
    end

    def liquid_assigns
      @liquid_assigns ||= env.fetch('steam.liquid_assigns')
    end

    def default_locale
      site.default_locale
    end

    def params
      @params ||= self.request.params.with_indifferent_access
    end

  end

end
