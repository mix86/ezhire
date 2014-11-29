class Person
  class Creator
    def initialize name, options
      @name = name
      @options = options
    end

    def call
      Person.create! params
    end

    private

    def params
      { name: @name,
        owner: user,
        project: project,
        moikrug_link: moikrug_link,
        moikrug_profile: moikrug_profile,
        facebook_link: facebook_link,
        facebook_profile: facebook_profile,
        skills: skills,
        experience: experience }
    end

    def user
      @options[:user] || fail(RuntimeError, "no user param provided")
    end

    def project
      @options[:project] || fail(RuntimeError, "no project param provided")
    end

    def moikrug_link
      @options[:moikrug][:link] if @options[:moikrug]
    end

    def moikrug_profile
      @options[:moikrug] || Hash.new
    end

    def facebook_link
      @options[:facebook][:link] if @options[:facebook]
    end

    def facebook_profile
      @options[:facebook] || Hash.new
    end

    def skills
      @options[:moikrug][:skills] if @options[:moikrug]
    end

    def experience
      @options[:moikrug][:experience] if @options[:moikrug]
    end
  end
end
