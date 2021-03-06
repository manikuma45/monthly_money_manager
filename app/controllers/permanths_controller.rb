class PermanthsController < ApplicationController
  #before_action :set_permanth,only:[:show,:edit,:update,:destroy]
  before_action :set_permanth,only:[:destroy]
  before_action :login_check

  def index
    @permanths = Permanth.where(user_id: current_user.id)
    @sum = user_money(@permanths)
  end

  def new
    @permanth = Permanth.new
  end

  def create
    @permanth = current_user.permanths.build(permanth_params)
    if @permanth.save
      redirect_to permanths_path, notice: "登録しました！"
    else
      @permanth.errors.messages.delete(:service_id)
      @permanth.registration=""
      @permanth.cancellation=""
      @service = Service.new
      render 'new'
    end
  end

  def search
    @services = Service.where("user_id = ? && name LIKE ?", 1,"%#{params[:search]}%")
  end

  def mail
    PermanthMailer.permanth_test_email(current_user,params[:sum],params[:email],).deliver
    redirect_to permanths_path, notice: "メールを送信しました！"
  end

  def destroy
    @permanth.destroy
    redirect_to permanths_path,notice:"投稿を削除しました！"
  end

  private

  def permanth_params
    params.require(:permanth).permit(:service_id, :registration, :cancellation)
  end

  def set_permanth
    @permanth = Permanth.find(params[:id])
  end
end