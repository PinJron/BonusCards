class ShopsController < ApplicationController
  # before_action :set_shop, only: %i[show update]
  # before_action :set_user, only: %i[buy]

  def index
    @shops = Shop.all
  end

  def show = shop

  def create
    candidate = Shop.find_by(name: shop_params[:attributes][:name])

    if candidate
      @errors = true
    else
      @shop = Shop.create!(shop_params[:attributes])
    end
  end

  def buy
    card = user&.cards&.find_by(shop_id: params[:id])

    return @errors = true unless card

    @card, @amount_due = process_payment(
      card, buy_params[:amount].ceil, buy_params[:use_bonuses]
    )
  end

  def update
    @errors = true unless @shop.update(shop_params[:attributes])
  end

  private

  def process_payment(card, buy_ammount, use_bonuses)
    return add_bonuses(card, buy_ammount) unless use_bonuses

    return use_card_bonuses(card, buy_ammount) if card.bonuses >= buy_ammount
    return add_bonuses(card, buy_ammount) unless user.negative_balance?

    use_total_user_bonuses(card, buy_ammount)
  end

  def max_negative_balance
    Card.where(user_id: @user.id).where.not(id: @card.id).sum(:bonuses)
  end

  def use_total_user_bonuses(card, buy_ammount)
    user.with_lock do
      user_balance = user.total_bonuses

      calculate_bonuses_breakdown(user_balance, buy_ammount) in {
        bonuses_used:, amount_due:
      }

      [card.decrement_bonuses!(bonuses_used), amount_due]
    end
  end

  def use_card_bonuses(card, buy_ammount)
    card.with_lock do
      card_balance = card.bonuses

      calculate_bonuses_breakdown(card_balance, buy_ammount) in {
        bonuses_used:, amount_due:
      }

      [card.decrement_bonuses!(bonuses_used), amount_due]
    end
  end

  def add_bonuses(card, buy_ammount)
    bonuses = amount >= 100 ? (amount / 100).floor : 0

    [card.increment_bonuses!(bonuses), buy_ammount]
  end

  def calculate_bonuses_breakdown(balance, buy_ammount)
    bonuses_used =
      if balance >= buy_ammount
        balance - buy_ammount
      else
        balance
      end

    amount_due = buy_ammount - bonuses_used

    { bonuses_used:, amount_due: }
  end

  def shop_params = params.require(:data).permit(attributes: :name)
  def buy_params = params.permit(:amount, :use_bonuses, :user_id)

  def shop = @shop ||= Shop.find(params[:id])
  def user = @user ||= User.find(buy_params[:user_id])
end
