class RoundsController < ApplicationController
  before_action :ensure_user_logged_in, only: [:show]
	def show
		@show = Round.find(params[:id])
	end
end