class CustomersController < ApplicationController

    def index
        @user = current_user
        @user_accesses = UserAccessCompany.where(user_id: @user.id)
        @company_ids = []
        @user_accesses.each do |user_access|

            @company_ids << user_access.company_id
        end
        @customers = Customer.where(company_id: @company_ids)
    end

    def new
        @company = Company.find(params[:company_id])
        @customer = Customer.new
        @countries = Country.order("name asc").all
    end

    def create
        @company = Company.find(params[:company_id])
        @customer = Customer.new(name: params_create[:name], vat_number: params_create[:vat_number], street: params_create[:street], city: params_create[:city], post_code: params_create[:post_code], country_id: params[:country].to_i, company_id: @company.id)
        if @customer.save
            redirect_to company_customers_path(@company.id)
        else
            render :new
        end
    end

    def edit
        @company = Company.find(params[:company_id])
        @customer = Customer.find(params[:id])
        @countries = Country.order("name asc").all
    end

    def update
        @company = Company.find(params[:company_id])
        @customer = Customer.find(params[:id])
        @customer.update!(name: params_create[:name], vat_number: params_create[:vat_number], street: params_create[:street], city: params_create[:city], post_code: params_create[:post_code], country_id: params[:country].to_i, company_id: @company.id)
        redirect_to company_customers_path(@company.id)

    end

      # too dangerous, can break all invoice & co

=begin 
    def delete
        @company = Company.find(params[:company_id])

        @customer = Customer.find(params[:customer_id])
        @customer.destroy
        redirect_to company_customers_path(@company.id)

    end 
=end

    # FRENCH

    def index_french
        @customers = Customer.where(params[:customer_id])
    end


    def edit_french
        @company = Company.find(params[:company_id])
        @customer = Customer.find(params[:customer_id])
        @countries = Country.order("name asc").all
    end

    def update_french
        @company = Company.find(params[:company_id])
        @customer = Customer.find(params[:customer_id])
        @customer.update!(name: params_french[:name], vat_number: params_french[:vat_number], street: params_french[:street], city: params_french[:city], post_code: params_french[:post_code], country_id: params_french[:country].to_i, company_id: @company.id)
        path = '/entreprises/' + @company.id.to_s + '/clients'
        redirect_to path
    end

    def new_french
        @company = Company.find(params[:company_id])
        @customer = Customer.new
        @countries = Country.order("name asc").all
    end

    def create_french
        @company = Company.find(params[:company_id])
        @customer = Customer.new(name: params_french[:name], vat_number: params_french[:vat_number], street: params_french[:street], city: params_french[:city], post_code: params_french[:post_code], country_id: params_french[:country].to_i, company_id: @company.id)
        path = '/entreprises/' + @company.id.to_s + '/clients'
        if @customer.save
            redirect_to path
        else
            render :new
        end
    end

    private

    def params_create
        params.require(:customer).permit(:name, :vat_number, :street, :city, :post_code, :country)
    end

    def params_french

        params.permit(:name, :vat_number, :street, :city, :post_code, :country)
    end
end