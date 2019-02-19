class SaleFilesController < ApplicationController
	before_action :set_file, only: [:edit, :update, :show]

	def index
		@files = SaleFile.all
	end

	def new
		@file = SaleFile.new
	end

	def create
		@file = SaleFile.new(sale_file_params)

		if @file.save
			flash[:success] = "File successfully created."
			redirect_to sale_files_path
		else
			render :new
		end
	end

	def edit
	end

	def update
		if @file.update(sale_file_params)
			flash[:success] = "File successfully updated."
			redirect_to files_path
		else
			render :edit
		end
	end

	def show
		@sales = @file.sales.page(params[:page]).per(6)
	end

	private
	def sale_file_params
		params.require(:sale_file).permit(:file)
	end

	def set_file
		@file = SaleFile.find(params[:id])
	end
end