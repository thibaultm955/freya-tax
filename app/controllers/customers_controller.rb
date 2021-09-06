class CustomersController < ApplicationController

    def index
        @customers = Customer.where(params[:customer_id])
    end

    def new
        @company = Company.find(params[:company_id])
        @customer = Customer.new
        @countries = Country.order("name asc").all
    end

    def create
        @customer = Customer.new(name: params_create[:name], vat_number: params_create[:vat_number], street: params_create[:street], city: params_create[:city], post_code: params_create[:post_code], country_id: params_create[:country], company_id: current_user.company.id)
        if @customer.save
            redirect_to company_invoices_path(current_user.company.id)
        else
            render :new
        end
    end


    private

    def params_create
        params.require(:customer).permit(:name, :vat_number, :street, :city, :post_code, :country)
    end
end