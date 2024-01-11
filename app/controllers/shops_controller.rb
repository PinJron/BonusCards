class ShopsController < ApplicationController
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

    buy_amount = buy_params[:amount].ceil

    return @errors = true if buy_amount <= 0

    use_bonuses = buy_params[:use_bonuses]

    process_payment(card, buy_amount, use_bonuses) in { card:, amount_due: }

    @card = card
    @amount_due = amount_due
  end

  def update
    @errors = true unless @shop.update(shop_params[:attributes])
  end

  private

  def process_payment(card, buy_amount, use_bonuses)
    return add_bonuses(card, buy_amount) unless use_bonuses

    return use_card_bonuses(card, buy_amount) if card.bonuses >= buy_amount
    return add_bonuses(card, buy_amount) unless user.negative_balance?

    use_total_user_bonuses(card, buy_amount)
  end

  def use_total_user_bonuses(card, buy_amount)
    user.with_lock do
      user_balance = user.total_bonuses

      calculate_bonuses_breakdown(user_balance, buy_amount) in {
        bonuses_used:, amount_due:
      }
      card.decrement!(:bonuses, bonuses_used)

      { card:, amount_due: }
    end
  end

  def use_card_bonuses(card, buy_amount)
    card.with_lock do
      card_balance = card.bonuses

      calculate_bonuses_breakdown(card_balance, buy_amount) in {
        bonuses_used:, amount_due:
      }
      card.decrement!(:bonuses, bonuses_used)

      { card:, amount_due: }
    end
  end

  def add_bonuses(card, buy_amount)
    bonuses = amount >= 100 ? (amount / 100).floor : 0
    card.increment!(:bonuses, bonuses)

    { card:, amount_due: buy_amount }
  end

  def calculate_bonuses_breakdown(balance, buy_amount)
    bonuses_used =
      if balance >= buy_amount
        balance - buy_amount
      else
        balance
      end

    amount_due = buy_amount - bonuses_used

    { bonuses_used:, amount_due: }
  end

  def shop_params = params.require(:data).permit(attributes: :name)
  def buy_params = params.permit(:amount, :use_bonuses, :user_id)

  def shop = @shop ||= Shop.find(params[:id])
  def user = @user ||= User.find(buy_params[:user_id])
end
