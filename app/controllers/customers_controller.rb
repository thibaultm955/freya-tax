class CustomersController < ApplicationController

    def index
        @user = current_user

        @user_accesses = UserAccessCompany.where(user_id: @user.id)
        @entity_ids = []
        @user_accesses.each do |user_access|
            @entity_ids += user_access.company.entity_ids
        end
        @entities = Entity.where(id: @entity_ids)

        @customers = Customer.where(entity_id: @entities)
    end

    def new
        @user = current_user

        @user_accesses = UserAccessCompany.where(user_id: @user.id)
        @entity_ids = []
        @user_accesses.each do |user_access|
            @entity_ids += user_access.company.entity_ids
        end
        @entities = Entity.where(id: @entity_ids)
        @customer = Customer.new
        @countries = Country.order("name asc").all
    end

    def create
        @entity = Entity.find(params[:entity])
        @customer = Customer.new(name: params_create_customer[:name], vat_number: params_create_customer[:vat_number], street: params_create_customer[:street], city: params_create_customer[:city], post_code: params_create_customer[:post_code], country_id: params[:country].to_i, entity_id: @entity.id)
        if @customer.save
            path = '/customers/'
            redirect_to path
        else
            render :new
        end
    end

    def edit
        @entity = Entity.find(params[:entity_id])
        @customer = Customer.find(params[:customer_id])
        @countries = Country.order("name asc").all
    end

    def update
        @entity = Entity.find(params[:entity_id])
        @customer = Customer.find(params[:customer_id])
        @customer.update!(name: params_create[:name], vat_number: params_create[:vat_number], street: params_create[:street], city: params_create[:city], post_code: params_create[:post_code], country_id: params[:country].to_i, entity_id: @entity.id)
        path = '/customers/'
        redirect_to path

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
        @entities = @company.entities
    end

    def update_french
        @company = Company.find(params[:company_id])
        @entity = Entity.find(params[:entity])
        @customer = Customer.find(params[:customer_id])
        @customer.update!(name: params_create[:name], vat_number: params_create[:vat_number], street: params_create[:street], city: params_create[:city], post_code: params_create[:post_code], country_id: params[:country].to_i, entity_id: @entity.id)
        path = '/clients/'
        redirect_to path
    end

    def new_french
        @user = current_user

        @user_accesses = UserAccessCompany.where(user_id: @user.id)
        @entity_ids = []
        @user_accesses.each do |user_access|
            @entity_ids += user_access.company.entity_ids
        end
        @entities = Entity.where(id: @entity_ids)
        @customer = Customer.new
        @countries = Country.order("name asc").all
    end

    def create_french
        @entity = Entity.find(params[:entity])
        @customer = Customer.new(name: params_create_customer[:name], vat_number: params_create_customer[:vat_number], street: params_create_customer[:street], city: params_create_customer[:city], post_code: params_create_customer[:post_code], country_id: params[:country].to_i, entity_id: @entity.id)
        if @customer.save
            path = '/clients/'
            redirect_to path
        else
            render :new
        end
    end

    private

    def params_create
        params.permit(:name, :vat_number, :street, :city, :post_code, :country)
    end

    def params_create_customer
        params.permit(:name, :vat_number, :street, :city, :post_code)
    end

    def params_french

        params.permit(:name, :vat_number, :street, :city, :post_code, :country)
    end
end