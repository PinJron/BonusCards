class ShopsController < ApplicationController
  before_action :set_shop, only: %i[show update]
  before_action :set_user, only: %i[buy]

  def index
    @shops = Shop.all
    render json: @shops
  end

  def show
    @shop = Shop.find(params[:id])
  end

  def create
    candidate = Shop.find_by(name: shop_params[:attributes][:name])
    if candidate
      @errors = true
    else
      @shop = Shop.create(shop_params[:attributes])
    end
  end

  def buy
    Card.transaction do
      @card = @user.cards.find_by(shop_id: params[:id])

      return @errors = true unless @card

      @card.lock!

      use_bonuses? ? use_bonuses : add_bonuses
    end
  end

  def update
    @errors = true unless @shop.update(shop_params[:attributes])
  end

  private

  def calculate_bonus(amount)
    amount >= 100 ? (amount / 100).floor : 0
  end

  def set_shop
    @shop = Shop.find(params[:id])
  end

  def shop_params
    params.require(:data).permit(attributes: :name)
  end

  def use_bonuses?
    buy_params[:use_bonuses]
  end

  def use_bonuses
    if @card.bonuses >= buy_ammount.ceil
      @card.update(bonuses: @card.bonuses - buy_ammount.ceil)
      @amount_due = 0
    else
      @amount_due = buy_ammount.ceil - @card.bonuses
      @card.update(bonuses: 0)
    end
  end

  def add_bonuses
    bonuses = calculate_bonus(buy_ammount)
    @card.update(bonuses: @card.bonuses + bonuses)
    @amount_due = buy_ammount
  end

  def buy_params
    params.permit(:amount, :use_bonuses, :user_id)
  end

  def set_user
    @user = User.find(buy_params[:user_id])
  end

  def buy_ammount
    buy_params[:amount]
  end
end
