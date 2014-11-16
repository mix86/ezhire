class PeopleController < ApplicationController
  include Projectable

  helper_method :person, :persons

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
    moikrug = Moikrug.new(city, specializations)
    result = moikrug.search

    result.each do |item|
      person = Person.where(name: item[:name])
      unless person.exists?
        fb = Faceboo.new(item[:name]).search_one
        person = create_person item[:name], moikrug: item, facebook: fb
      end
    end

    project.update_attributes stats: { moikrug_last_query: moikrug.query }

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
    @persons ||= Person.of(current_user).where(project: project).in(status: [:new, :accepted])
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

  def city
    params[:city]
  end

  def specializations
    params[:query].split(',').map(&:strip)
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
