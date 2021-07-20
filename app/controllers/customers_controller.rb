class CustomersController < ApplicationController

    def new
        @company = Company.find(params[:company_id])
        @customer = Customer.new
    end

end