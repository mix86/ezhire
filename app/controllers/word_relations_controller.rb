class WordRelationsController < ApplicationController

  helper_method :collection

  def index
  end

  def create
    WordRelation.create permitted
    redirect_to word_relations_path
  end

  def update
    resource.update_attributes permitted
    redirect_to word_relations_path
  end

  def destroy
    resource.destroy!
    redirect_to word_relations_path
  end

  private

  def permitted
    params.require(:word_relation).permit(:target, :relation, :source)
  end

  def collection
    WordRelation.all
  end

  def resource
    WordRelation.find params[:id]
  end
end
