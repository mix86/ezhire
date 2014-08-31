class Event
  class Creator
    def initialize user, params
      @user = user
      @params = params
    end

    def call
      Event.create! params
    end

    private

    def params
      @params.merge! owner: @user, project: project
    end

    def project
      Person.find(@params[:person]).project
    end
  end
end
