class CardsController < ApplicationController
  before_action :set_card, only: %i[show]

  # GET /cards or /cards.json
  def index
    @cards = Card.all
  end

  # GET /cards/1 or /cards/1.json
  def show
    @card = Card.find(params[:id])
  end
end
