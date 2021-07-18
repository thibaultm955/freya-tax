class TransactionsController < ApplicationController

    def index
        @return = Return.find(params_transaction[:return_id])
        @transactions = @return.transactions
        @company = current_user.company
        @entity = @return.entity
    end

    def show

        # if set to destroy, remove the amount from the return box
        if params[:format] == "destroy"
            @return = Return.find(params_transaction[:return_id])
            @transaction = Transaction.find(params_transaction[:id])
            @periodicity_to_project_type = @return.periodicity_to_project_type
            box_names = BoxName.where(periodicity_to_project_type_id: @periodicity_to_project_type.id, language_id: 2)
            @tax_code = @transaction.entity_tax_code
            box_informations = BoxInformation.where(tax_code_operation_location_id: @tax_code.country_tax_code.tax_code_operation_location_id, tax_code_operation_rate_id: @tax_code.country_tax_code.tax_code_operation_rate_id, tax_code_operation_side_id: @tax_code.country_tax_code.tax_code_operation_side_id, tax_code_operation_type_id: @tax_code.country_tax_code.tax_code_operation_type_id )

            box_informations.each do |box_information|
                return_box = ReturnBox.where(box_name_id: box_information.box_name_id)[0]
                amount = box_information.amount.name
                if amount == "Reporting Currency Taxable Basis"
                    updated_amount = return_box.amount - @transaction.net_amount
                    return_box = return_box.update(amount: updated_amount)
                elsif amount == "Reporting Currency VAT Amount"
                    updated_amount = return_box.amount - @transaction.vat_amount
                    return_box = return_box.update(amount: updated_amount)
                elsif amount == "Reporting Currency Gross Amount"
                    updated_amount = return_box.amount - @transaction.total_amount
                    return_box = return_box.update(amount: updated_amount)
                end
            end

            @transaction.destroy
            redirect_to company_entity_return_transactions_path(current_user.company.id, @return.entity.id, @return.id)
        end
    end

    def new
        @return = Return.find(params[:return_id])
        @company = current_user.company
        @entity = @return.entity
        @transaction = Transaction.new
        @tax_codes = @entity.entity_tax_codes
    end

    def create
        # if didn't upload a file
        if params[:transaction][:file].nil?
            @transaction = Transaction.new(invoice_number: params_new_transaction[:invoice_number], invoice_date: params_new_transaction[:invoice_date], vat_amount: params_new_transaction[:vat_amount], net_amount: params_new_transaction[:net_amount], total_amount: params_new_transaction[:total_amount], business_partner_name: params_new_transaction[:business_partner_name], business_partner_vat_number: params_new_transaction[:business_partner_vat_number])
            @return = Return.find(params[:return_id])
            @transaction.return = @return
            @tax_code = EntityTaxCode.find(params_tax_code[:tax_code_id])
            @transaction.entity_tax_code = @tax_code

            box_informations = BoxInformation.where(tax_code_operation_location_id: @tax_code.country_tax_code.tax_code_operation_location_id, tax_code_operation_rate_id: @tax_code.country_tax_code.tax_code_operation_rate_id, tax_code_operation_side_id: @tax_code.country_tax_code.tax_code_operation_side_id, tax_code_operation_type_id: @tax_code.country_tax_code.tax_code_operation_type_id )

            box_informations.each do |box_information|
                return_box = ReturnBox.where(box_name_id: box_information.box_name_id)[0]
                amount = box_information.amount.name
                if amount == "Reporting Currency Taxable Basis"
                    updated_amount = return_box.amount + params_new_transaction[:net_amount].to_f
                    return_box = return_box.update(amount: updated_amount)
                elsif amount == "Reporting Currency VAT Amount"
                    updated_amount = return_box.amount + params_new_transaction[:vat_amount].to_f
                    return_box = return_box.update(amount: updated_amount)
                elsif amount == "Reporting Currency Gross Amount"
                    updated_amount = return_box.amount + params_new_transaction[:total_amount].to_f
                    return_box = return_box.update(amount: updated_amount)
                end
            end
            
            if @transaction.save!
                redirect_to company_entity_return_transactions_path(current_user.company.id, @return.entity.id, @return.id)
            else 
                render :new
            end

        # if they did upload a file
        else
            csv_file = CSV.parse(params[:transaction][:file].tempfile, headers: true)
            csv_file.each do |row|
                invoice_date_splitted = row['invoice_date'].split('/')
                @transaction = Transaction.new(invoice_number: row['invoice_number'], invoice_date: ( '20' + invoice_date_splitted[2] + '-' + invoice_date_splitted[1]  + '-' + invoice_date_splitted[0]), vat_amount: row['vat_amount'], net_amount: row['net_amount'], total_amount: row['total_amount'], business_partner_name: row['business_partner_name'], business_partner_vat_number: row['business_partner_vat_number'])
                @return = Return.find(params[:return_id])
                @transaction.return = @return
                @tax_code = EntityTaxCode.where(:entity_id => params[:entity_id], :name => row['Tax Code'])[0]
                @transaction.entity_tax_code = @tax_code
                box_informations = BoxInformation.where(tax_code_operation_location_id: @tax_code.country_tax_code.tax_code_operation_location_id, tax_code_operation_rate_id: @tax_code.country_tax_code.tax_code_operation_rate_id, tax_code_operation_side_id: @tax_code.country_tax_code.tax_code_operation_side_id, tax_code_operation_type_id: @tax_code.country_tax_code.tax_code_operation_type_id )

                box_informations.each do |box_information|
                    return_box = ReturnBox.where(box_name_id: box_information.box_name_id)[0]
                    amount = box_information.amount.name
                    if amount == "Reporting Currency Taxable Basis"
                        updated_amount = return_box.amount + params_new_transaction[:net_amount].to_f
                        return_box = return_box.update(amount: updated_amount)
                    elsif amount == "Reporting Currency VAT Amount"
                        updated_amount = return_box.amount + params_new_transaction[:vat_amount].to_f
                        return_box = return_box.update(amount: updated_amount)
                    elsif amount == "Reporting Currency Gross Amount"
                        updated_amount = return_box.amount + params_new_transaction[:total_amount].to_f
                        return_box = return_box.update(amount: updated_amount)
                    end
                end
                @transaction.save
            end

            
            redirect_to company_entity_return_transactions_path(current_user.company.id, @return.entity.id, @return.id)
            
            
            

        end
        
    end

    def edit
        @return = Return.find(params_transaction[:return_id])
        @transaction = Transaction.find(params_transaction[:id])
        @company = current_user.company
        @entity = @return.entity
        @tax_codes = @entity.entity_tax_codes
    end

    def update
        @return = Return.find(params_transaction[:return_id])
        @transaction = Transaction.find(params_transaction[:id])

        # Remove previous amount from return
        @periodicity_to_project_type = @return.periodicity_to_project_type
        box_names = BoxName.where(periodicity_to_project_type_id: @periodicity_to_project_type.id, language_id: 2)
        @tax_code = @transaction.entity_tax_code
        box_informations = BoxInformation.where(tax_code_operation_location_id: @tax_code.country_tax_code.tax_code_operation_location_id, tax_code_operation_rate_id: @tax_code.country_tax_code.tax_code_operation_rate_id, tax_code_operation_side_id: @tax_code.country_tax_code.tax_code_operation_side_id, tax_code_operation_type_id: @tax_code.country_tax_code.tax_code_operation_type_id )

        box_informations.each do |box_information|
            return_box = ReturnBox.where(box_name_id: box_information.box_name_id)[0]
            amount = box_information.amount.name
            if amount == "Reporting Currency Taxable Basis"
                updated_amount = return_box.amount - @transaction.net_amount
                return_box = return_box.update(amount: updated_amount)
            elsif amount == "Reporting Currency VAT Amount"
                updated_amount = return_box.amount - @transaction.vat_amount
                return_box = return_box.update(amount: updated_amount)
            elsif amount == "Reporting Currency Gross Amount"
                updated_amount = return_box.amount - @transaction.total_amount
                return_box = return_box.update(amount: updated_amount)
            end
        end

        # if user didn't update the tax code
        if params_tax_code[:tax_code_id].empty?
            @transaction = @transaction.update(invoice_number: params_new_transaction[:invoice_number], invoice_date: params_new_transaction[:invoice_date], vat_amount: params_new_transaction[:vat_amount], net_amount: params_new_transaction[:net_amount], total_amount: params_new_transaction[:total_amount], business_partner_name: params_new_transaction[:business_partner_name], business_partner_vat_number: params_new_transaction[:business_partner_vat_number])
        else
            @tax_code = EntityTaxCode.find(params_tax_code[:tax_code_id])
            @transaction = @transaction.update(invoice_number: params_new_transaction[:invoice_number], invoice_date: params_new_transaction[:invoice_date], vat_amount: params_new_transaction[:vat_amount], net_amount: params_new_transaction[:net_amount], total_amount: params_new_transaction[:total_amount], business_partner_name: params_new_transaction[:business_partner_name], business_partner_vat_number: params_new_transaction[:business_partner_vat_number], entity_tax_code_id: @tax_code.id)
        end

        @transaction = Transaction.find(params_transaction[:id])
        @periodicity_to_project_type = @return.periodicity_to_project_type
        box_names = BoxName.where(periodicity_to_project_type_id: @periodicity_to_project_type.id, language_id: 2)
        @tax_code = @transaction.entity_tax_code
        box_informations = BoxInformation.where(tax_code_operation_location_id: @tax_code.country_tax_code.tax_code_operation_location_id, tax_code_operation_rate_id: @tax_code.country_tax_code.tax_code_operation_rate_id, tax_code_operation_side_id: @tax_code.country_tax_code.tax_code_operation_side_id, tax_code_operation_type_id: @tax_code.country_tax_code.tax_code_operation_type_id )

        box_informations.each do |box_information|
            return_box = ReturnBox.where(box_name_id: box_information.box_name_id)[0]
            amount = box_information.amount.name
            if amount == "Reporting Currency Taxable Basis"
                updated_amount = return_box.amount + @transaction.net_amount
                return_box = return_box.update(amount: updated_amount)
            elsif amount == "Reporting Currency VAT Amount"
                updated_amount = return_box.amount + @transaction.vat_amount
                return_box = return_box.update(amount: updated_amount)
            elsif amount == "Reporting Currency Gross Amount"
                updated_amount = return_box.amount + @transaction.total_amount
                return_box = return_box.update(amount: updated_amount)
            end
        end

        redirect_to company_entity_return_transactions_path(current_user.company.id, @return.entity.id, @return.id)
    end

    def destroy
        @return = Return.find(params_transaction[:return_id])
        @transaction = Transaction.find(params_transaction[:id])
        @transaction.destroy
        redirect_to company_entity_return_transactions_path(current_user.company.id, @return.entity.id, @return.id)
    
    end

    private

    def params_transaction
        params.permit(:company_id, :entity_id, :return_id, :id)
    end

    def params_new_transaction
        if params[:transaction].nil?
            
        else
            params.require(:transaction).permit(:invoice_number, :invoice_date, :vat_amount, :net_amount, :total_amount, :business_partner_name, :business_partner_vat_number)
        end
    end

    def params_tax_code
        params.permit(:tax_code_id)
    end
end