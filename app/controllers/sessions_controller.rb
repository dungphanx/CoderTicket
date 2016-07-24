class SessionsController < ApplicationController
	def new
	end

	def create
		if @user = User.find_by(email: params[:email])
			if @user.authenticate(params[:password])
				flash[:success] = "Welcome back #{@user.name}"
				session[:user_id] = @user.id
				redirect_to root_path
			else
				flash[:errors] = "Password not right!"
				redirect_to root_path
			end
		else
			flash[:errors] = "Please enter email and password"
			redirect_to root_path
		end
	end
end
