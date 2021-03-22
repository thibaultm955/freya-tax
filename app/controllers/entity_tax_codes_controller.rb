class EntityTaxCodesController < ApplicationController

    def index
        @entities = current_user.company.entities
        @entity_tax_codes = EntityTaxCode.where(entity_id: current_user.company.entities)
    end

    def show
        @entity_tax_code = EntityTaxCode.find(params_entity_id[:id])
    end

    def edit
        @company = current_user.company
        @entity_tax_code = EntityTaxCode.find(params_entity_id[:id])
        @tax_code_operation_sides = TaxCodeOperationSide.all
        @tax_code_operation_locations = TaxCodeOperationLocation.all
        @tax_code_operation_types = TaxCodeOperationType.all
        @tax_code_operation_rates = TaxCodeOperationRate.all
    end
    
    def update
        if params_javascript[:side_operation] != ""
            @entity_tax_code = EntityTaxCode.find(params_entity_id[:id])
            @country_tax_code = CountryTaxCode.where(country_id: @entity_tax_code.country_tax_code.country_id, tax_code_operation_location_id: params_javascript[:location_operation], tax_code_operation_side_id: params_javascript[:side_operation], tax_code_operation_type_id: params_javascript[:type_operation], tax_code_operation_rate_id: params_javascript[:rate_operation])[0]
            @entity_tax_code = @entity_tax_code.update(name: params_entity_tax_code[:name], country_tax_code_id: @country_tax_code.id)
            redirect_to company_entity_tax_codes_path(current_user.company)
        elsif params_entity_tax_code[:name] != ""
            @entity_tax_code = EntityTaxCode.find(params_entity_id[:id])
            @entity_tax_code = @entity_tax_code.update(name: params_entity_tax_code[:name])
            redirect_to company_entity_tax_codes_path(current_user.company)
        else
            redirect_to company_entity_tax_codes_path(current_user.company)
        end
    end

    def new
        @entity_tax_code = EntityTaxCode.new
        @company = current_user.company
        @countries = Country.all
        @tax_code_operation_sides = TaxCodeOperationSide.all
        @tax_code_operation_locations = TaxCodeOperationLocation.all
        @tax_code_operation_types = TaxCodeOperationType.all
        @tax_code_operation_rates = TaxCodeOperationRate.all
    end

    def create
        @country_tax_code = CountryTaxCode.where(country_id: params_javascript[:country], tax_code_operation_location_id: params_javascript[:location_operation], tax_code_operation_side_id: params_javascript[:side_operation], tax_code_operation_type_id: params_javascript[:type_operation], tax_code_operation_rate_id: params_javascript[:rate_operation])[0]
        @entity_tax_code = EntityTaxCode.new(name: params_entity_tax_code[:name], entity_id: params_entity[:entity_id])
        @entity_tax_code.country_tax_code = @country_tax_code
        

        if @entity_tax_code.save!
            redirect_to company_entity_tax_codes_path(current_user.company)
        else
            render :new
        end
        
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