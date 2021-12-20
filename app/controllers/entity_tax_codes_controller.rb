class EntityTaxCodesController < ApplicationController

    def index
        @user = current_user
        if @user.nil? || UserAccessCompany.where(user_id: @user.id).empty?
            redirect_to root_path
        else
            @user_accesses = UserAccessCompany.where(user_id: @user.id)
            @entity_ids = []
            @user_accesses.each do |user_access|
                @entity_ids += user_access.company.entity_ids
            end
            @entity_tax_codes = EntityTaxCode.where(entity_id: @entity_ids, is_hidden: nil)
        end
    end

    def show
        @user = current_user
        @company = Company.find(params[:company_id])
        if @user.nil? || UserAccessCompany.where(user_id: @user.id, company_id: @company.id).empty?
            redirect_to root_path
        else
            @company = Company.find(params[:company_id])
            @entity_tax_code = EntityTaxCode.find(params_entity_id[:id])
            @countries = Country.all.order("name asc")
        end
    end

    def edit
        @user = current_user
        @company = Company.find(params[:company_id])
        if @user.nil? || UserAccessCompany.where(user_id: @user.id, company_id: @company.id).empty?
            redirect_to root_path
        else
            @entity_tax_code = EntityTaxCode.find(params_entity_id[:id])
            @tax_code_operation_sides = TaxCodeOperationSide.all
            @tax_code_operation_locations = TaxCodeOperationLocation.all
            @tax_code_operation_types = TaxCodeOperationType.all
            @tax_code_operation_rates = TaxCodeOperationRate.all
        end
    end
    
    def update
        @user = current_user
        @company = Company.find(params[:company_id])
        if @user.nil? || UserAccessCompany.where(user_id: @user.id, company_id: @company.id).empty?
            redirect_to root_path
        else
            @entity_tax_code = EntityTaxCode.find(params_entity_id[:id])
            @country_tax_code = CountryTaxCode.where(country_id: @entity_tax_code.country_tax_code.country_id, tax_code_operation_location_id: params_javascript[:location_operation], tax_code_operation_side_id: params_javascript[:side_operation], tax_code_operation_type_id: params_javascript[:type_operation], tax_code_operation_rate_id: params_javascript[:rate_operation])[0]
            @entity_tax_code = @entity_tax_code.update(name: params_entity_tax_code[:name], country_tax_code_id: @country_tax_code.id)
            redirect_to company_entity_tax_codes_path(@company)
        end


    end

    def new
        @user = current_user
        @entity_tax_code = EntityTaxCode.new
        @countries = Country.all.order("name asc")
        @tax_code_operation_sides = TaxCodeOperationSide.all
        @tax_code_operation_locations = TaxCodeOperationLocation.all
        @tax_code_operation_types = TaxCodeOperationType.all
        @tax_code_operation_rates = TaxCodeOperationRate.all

    end

    def create
        @user = current_user
        @company = Company.find(params[:company_id])
        if @user.nil? || UserAccessCompany.where(user_id: @user.id, company_id: @company.id).empty?
            redirect_to root_path
        else
            @country_tax_code = CountryTaxCode.where(country_id: params_javascript[:country], tax_code_operation_location_id: params_javascript[:location_operation], tax_code_operation_side_id: params_javascript[:side_operation], tax_code_operation_type_id: params_javascript[:type_operation], tax_code_operation_rate_id: params_javascript[:rate_operation])[0]
            @entity_tax_code = EntityTaxCode.new(name: params_entity_tax_code[:name], entity_id: params_entity[:entity_id])
            @entity_tax_code.country_tax_code = @country_tax_code
            

            if @entity_tax_code.save!
                redirect_to company_entity_tax_codes_path(@company)
            else
                render :new
            end
        end
    end

    def destroy
        @company = Company.find(params[:company_id])
        @entity_tax_code = EntityTaxCode.find(params[:entity_tax_code_id])
        # Cannot delete it because might still have transactions linked to it, will make the return generation bugging
        @entity_tax_code.update(is_hidden: true)
        redirect_to company_entity_tax_codes_path(@company)
    end

    private

    def params_entity_id
        params.permit(:id)
    end

    def params_entity_tax_code
        params.require(:entity_tax_code).permit(:name)
    end

    def params_entity
        params.require(:entity).permit(:entity_id)
    end

    def params_javascript
        params.permit(:country, :side_operation, :location_operation, :type_operation, :rate_operation)
    end
end