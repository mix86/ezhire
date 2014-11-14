class PeopleController < ApplicationController
  include Projectable

  helper_method :persons

  def index
  end

  def create
    create_person permitted[:name]
    render action: :index
  end

  def update
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
    @person ||= Person.of(current_user).find(params[:id])
  end

  private

  def create_person name, options = Hash.new
    Person.create name: name,
                  owner: current_user,
                  project: project,
                  moikrug: options[:moikrug],
                  facebook: options[:facebook]
  end


  def city
    params[:city]
  end

  def specializations
    params[:query].split(',').map(&:strip)
  end

  def permitted
    params.require(:person).permit(:name)
  end
end
