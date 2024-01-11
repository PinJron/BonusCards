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

      if use_bonuses?
        if negative_balance_enabled?
          use_bonuses_negative_balance
        else
          use_bonuses
        end
      else
        add_bonuses
      end
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

  def negative_balance_enabled?
    @user.negative_balance
  end

  def use_bonuses?
    buy_params[:use_bonuses]
  end

  def all_cards_ballance
    @user.cards.sum(:bonuses)
  end

  def max_negative_balance
    Card.where(user_id: @user.id).where.not(id: @card.id).sum(:bonuses)
  end

  def use_bonuses_negative_balance
    max_avaible_bonuses = all_cards_ballance
    max_neg_bal = max_negative_balance

    if max_avaible_bonuses >= 0 && buy_ammount.ceil < max_avaible_bonuses
      decrement_bonuses
    elsif buy_ammount.ceil >= max_avaible_bonuses
      @user.with_lock do 
        @amount_due = buy_ammount.ceil - max_avaible_bonuses
        @card.update(bonuses: -max_neg_bal)
      end
    end
  end

  def use_bonuses_
    if @card.bonuses >= buy_ammount.ceil
      decrement_bonuses
    else
      @amount_due = buy_ammount.ceil - @card.bonuses
      @card.update(bonuses: 0)
    end
  end

  def decrement_bonuses
    card.with_lock do
      @card.update(bonuses: @card.bonuses - buy_ammount.ceil)
    end
    @amount_due = 0
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
