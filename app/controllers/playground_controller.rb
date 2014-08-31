class PlaygroundController < ApplicationController

  def index
  end

  def search
    result = Moikrug.new(city, specializations).search
    puts result
    result.each do |item|
      person = Person.where(name: item[:name])
      unless person.exists?
        fb = Faceboo.new(item[:name]).search_one
        person = Person.create name: item[:name], moikrug: item, facebook: fb
      end
    end

    @persons = Person.all

    render action: :index
  end

  def clear
    Person.all.delete
    render action: :index
  end

  private

  def city
    params[:city]
  end

  def specializations
    params[:query].split(',').map(&:strip)
  end
end
