class PeopleController < ApplicationController
  include Projectable

  helper_method :person, :persons, :last_query

  def index
  end

  def create
    create_person permitted[:name]
    render action: :index
  end

  def show
    render layout: -> { 'layouts/application' }
  end

  def update
    person.update_attributes(permitted)
    redirect_to project_person_path
  end

  def search
    project.search_queries << query
    project.save!

    digger = Digger.new query, start: page

    digger.call do |result|
      person = Person.of(current_user).where(name: result.name, project: project)

      unless person.exists?
        moikrug = Moikrug::ProfileFetcher.new(link: result.moikrug_link).call || {}
        facebook = {} # Faceboo::ProfileFetcher.new(link: result.facebook_link).call || {}
        person = create_person result.name, moikrug: moikrug, facebook: facebook
      end
    end

    project.update_attributes stats: { moikrug_last_query: digger.moikrug_query,
                                       pages_processed: page }

    render action: :index
  end

  def clear
    Person.of(current_user).delete
    render action: :index
  end

  def accept
    person.accepted!
    person.save!
    render action: :index
  end

  def reject
    person.rejected!
    person.save!
    render action: :index
  end

  def persons
    @persons ||= Person.of(current_user)
                       .where(project: project)
                       .in(status: [:new, :accepted])
                       .order(created_at: 1)
  end

  def person
    @person ||= Person.of(current_user).find(params[:id]) if params[:id]
  end

  private

  def create_person name, options = Hash.new
    Person.create name: name,
                  owner: current_user,
                  project: project,
                  moikrug_link: options[:moikrug][:link],
                  moikrug_profile: options[:moikrug],
                  facebook_link: (options[:facebook] && options[:facebook][:link]),
                  facebook_profile: options[:facebook],
                  skills: options[:moikrug][:skills],
                  experience: options[:moikrug][:experience]
  end

  def query
    @query ||= SearchQuery.new search_params
  end

  def last_query
    project.search_queries.last || SearchQuery.new
  end

  def page
    params[:more].present? ? (params[:page].to_i || 1) : 1
  end

  def search_params
    search_params = params.require(:search_query).permit(:specializations, :city, :period, :contender)
    search_params[:specializations] = search_params[:specializations].split(",").map(&:strip)
    search_params[:city] = "Москва" unless search_params[:city].present?
    search_params[:period] = 2 unless search_params[:period].present?
    search_params
  end

  def permitted
    params.require(:person).permit(:name,
                                   :email,
                                   :phone,
                                   :skype,
                                   :moikrug_link,
                                   :linkedin_link,
                                   :github_link,
                                   :stackoverflow_link,
                                   :facebook_link,
                                   :vk_link,
                                   :twitter_link,
                                   :googleplus_link)
  end
end
