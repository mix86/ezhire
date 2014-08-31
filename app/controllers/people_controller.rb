class PeopleController < ApplicationController
  include Projectable

  helper_method :persons

  def index
  end

  def search
    result = Moikrug.new(city, specializations).search
    result.each do |item|
      person = Person.where(name: item[:name])
      unless person.exists?
        fb = Faceboo.new(item[:name]).search_one
        person = Person.create name: item[:name],
                               owner: current_user,
                               project: project,
                               moikrug: item,
                               facebook: fb
      end
    end

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

  def city
    params[:city]
  end

  def specializations
    params[:query].split(',').map(&:strip)
  end
end
