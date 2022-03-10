class TransactionsController < ApplicationController

    def index
        @return = Return.find(params_transaction[:return_id])
        @transactions = @return.transactions
        @company = Company.find(params[:company_id])
        @entity = @return.entity
    end

    def show
        @company = Company.find(params[:company_id])

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
            redirect_to company_entity_return_transactions_path(@company.id, @return.entity.id, @return.id)
        end
    end

    def new
        @return = Return.find(params[:return_id])
        @company = Company.find(params[:company_id])
        @entity = @return.entity
        @transaction = Transaction.new
        @tax_codes = @entity.entity_tax_codes
    end

    def create
        @company = Company.find(params[:company_id])

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
                redirect_to company_entity_return_transactions_path(@company.id, @return.entity.id, @return.id)
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

            
            redirect_to company_entity_return_transactions_path(@company.id, @return.entity.id, @return.id)
            
            
            

        end
        
    end

    def edit
        @return = Return.find(params_transaction[:return_id])
        @transaction = Transaction.find(params_transaction[:id])
        @company = Company.find(params[:company_id])
        @entity = @return.entity
        @tax_codes = @entity.entity_tax_codes
    end

    def update
        @company = Company.find(params[:company_id])

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

        redirect_to company_entity_return_transactions_path(@company.id, @return.entity.id, @return.id)
    end

    def destroy
        ddd
        @return = Return.find(params_transaction[:return_id])
        @transaction = Transaction.find(params_transaction[:id])
        @transaction.destroy
        redirect_to company_entity_return_transactions_path(current_user.company.id, @return.entity.id, @return.id)
    
    end

    def edit_transaction_invoice
        @transaction = Transaction.find(params[:transaction_id])
        @company = Company.find(params[:company_id])
        @invoice = @transaction.invoice
        @item = @transaction.item
        @entity = @item.entity
        @items = @entity.items
        @rate = @transaction.tax_code_operation_rate
        @rates = TaxCodeOperationRate.all

    end

    def edit_ticket_invoice
        @transaction = Transaction.find(params[:transaction_id])
        @company = Company.find(params[:company_id])
        @invoice = @transaction.invoice
        @item = @transaction.item
        @entity = @item.entity
        @items = @entity.items

    end

    def save_transaction_invoice
        @company = Company.find(params[:company_id])
        @rate = TaxCodeOperationRate.find(params[:rate])
        @item = Item.find(params[:item_id])
        @invoice = Invoice.find(params[:invoice_id])
        @transaction = Transaction.find(params[:transaction_id])
        @entity = Entity.find(@invoice.entity_id)
        quantity = params[:quantity].to_f
        net_amount = quantity * @item.net_amount
        vat_amount = quantity * @item.vat_amount

        previous_net_amount = @transaction.net_amount 
        previous_vat_amount = @transaction.vat_amount 

        # substract old amount 

        @country_tax_code = CountryTaxCode.where(country_id: @entity.country.id, tax_code_operation_location_id: @transaction.invoice.tax_code_operation_location.id, tax_code_operation_side_id: @transaction.invoice.tax_code_operation_side.id, tax_code_operation_rate_id: @rate.id, tax_code_operation_type_id: @transaction.item.tax_code_operation_type.id)[0]

        
        @entity_tax_code = EntityTaxCode.where(entity_id: @entity.id, country_tax_code_id: @country_tax_code.id)[0]

        box_informations = BoxInformation.where(tax_code_operation_location_id: @entity_tax_code.country_tax_code.tax_code_operation_location_id, tax_code_operation_rate_id: @entity_tax_code.country_tax_code.tax_code_operation_rate_id, tax_code_operation_side_id: @entity_tax_code.country_tax_code.tax_code_operation_side_id, tax_code_operation_type_id: @entity_tax_code.country_tax_code.tax_code_operation_type_id )
        
        box_informations.each do |box_information|
            return_box = ReturnBox.where(box_name_id: box_information.box_name_id)[0]
            amount = box_information.amount.name
            if amount == "Reporting Currency Taxable Basis"
                updated_amount = return_box.amount - previous_net_amount
                return_box = return_box.update(amount: updated_amount)
            elsif amount == "Reporting Currency VAT Amount"
                updated_amount = return_box.amount  - previous_vat_amount
                return_box = return_box.update(amount: updated_amount)
            elsif amount == "Reporting Currency Gross Amount"
                updated_amount = return_box.amount  - previous_net_amount - previous_vat_amount
                return_box = return_box.update(amount: updated_amount)
            end
        end


        # Add new amount 

        @new_country_tax_code = CountryTaxCode.where(country_id: @entity.country.id, tax_code_operation_location_id: @transaction.invoice.tax_code_operation_location.id, tax_code_operation_side_id: @transaction.invoice.tax_code_operation_side.id, tax_code_operation_rate_id: @rate.id, tax_code_operation_type_id: @item.tax_code_operation_type.id)[0]

        @new_entity_tax_code = EntityTaxCode.where(entity_id: @entity.id, country_tax_code_id: @new_country_tax_code.id)

        # if you don't have a tax code, you'll need to create one
        if @new_entity_tax_code.empty?
            name_tax_code = @transaction.invoice.tax_code_operation_location.name + " | " + @transaction.invoice.tax_code_operation_side.name + " | " + @transaction.item.tax_code_operation_type.name + " | " + @rate.name
            @new_entity_tax_code = EntityTaxCode.new(name: name_tax_code, entity_id: @entity.id, country_tax_code_id: @new_country_tax_code.id)
            @new_entity_tax_code.save

        end

        @new_entity_tax_code = EntityTaxCode.where(entity_id: @entity.id, country_tax_code_id: @new_country_tax_code.id)[0]

        box_informations = BoxInformation.where(tax_code_operation_location_id: @new_entity_tax_code.country_tax_code.tax_code_operation_location_id, tax_code_operation_rate_id: @new_entity_tax_code.country_tax_code.tax_code_operation_rate_id, tax_code_operation_side_id: @new_entity_tax_code.country_tax_code.tax_code_operation_side_id, tax_code_operation_type_id: @new_entity_tax_code.country_tax_code.tax_code_operation_type_id )
        

        box_informations.each do |box_information|
            return_box = ReturnBox.where(box_name_id: box_information.box_name_id)[0]
            amount = box_information.amount.name
            if amount == "Reporting Currency Taxable Basis"
                updated_amount = return_box.amount + net_amount 
                return_box = return_box.update(amount: updated_amount)
            elsif amount == "Reporting Currency VAT Amount"
                updated_amount = return_box.amount + vat_amount 
                return_box = return_box.update(amount: updated_amount)
            elsif amount == "Reporting Currency Gross Amount"
                updated_amount = return_box.amount + net_amount + vat_amount 
                return_box = return_box.update(amount: updated_amount)
            end
        end


        # will have to multiply quantity with what is specified
        @transaction.update!(vat_amount: vat_amount, net_amount: net_amount, comment: params[:comment], invoice_id: @invoice.id, :item_id => @item.id, :quantity => quantity, tax_code_operation_rate_id: @rate.id)
    
        redirect_to company_invoice_path(@company, @invoice.id)
        
    end


    def save_ticket_invoice
        @company = Company.find(params[:company_id])

        @item = Item.find(params[:item_id])
        @item.update(item_description: params[:comment], net_amount: params[:net_amount], vat_amount: params[:vat_amount])
        @invoice = Invoice.find(params[:invoice_id])
        @transaction = Transaction.find(params[:transaction_id])
        @entity = Entity.find(@invoice.entity_id)
        quantity = params[:quantity].to_f
        net_amount = quantity * @item.net_amount
        vat_amount = quantity * @item.vat_amount

        previous_net_amount = @transaction.net_amount 
        previous_vat_amount = @transaction.vat_amount 

        # substract old amount 

        @country_tax_code = CountryTaxCode.where(country_id: @entity.country.id, tax_code_operation_location_id: @transaction.invoice.tax_code_operation_location.id, tax_code_operation_side_id: @transaction.invoice.tax_code_operation_side.id, tax_code_operation_rate_id: @transaction.item.tax_code_operation_rate.id, tax_code_operation_type_id: @transaction.item.tax_code_operation_type.id)[0]

        @entity_tax_code = EntityTaxCode.where(entity_id: @entity.id, country_tax_code_id: @country_tax_code.id)[0]

     
        box_informations = BoxInformation.where(tax_code_operation_location_id: @entity_tax_code.country_tax_code.tax_code_operation_location_id, tax_code_operation_rate_id: @entity_tax_code.country_tax_code.tax_code_operation_rate_id, tax_code_operation_side_id: @entity_tax_code.country_tax_code.tax_code_operation_side_id, tax_code_operation_type_id: @entity_tax_code.country_tax_code.tax_code_operation_type_id )
        
        box_informations.each do |box_information|
            return_box = ReturnBox.where(box_name_id: box_information.box_name_id)[0]
            amount = box_information.amount.name
            if amount == "Reporting Currency Taxable Basis"
                updated_amount = return_box.amount - previous_net_amount
                return_box = return_box.update(amount: updated_amount)
            elsif amount == "Reporting Currency VAT Amount"
                updated_amount = return_box.amount  - previous_vat_amount
                return_box = return_box.update(amount: updated_amount)
            elsif amount == "Reporting Currency Gross Amount"
                updated_amount = return_box.amount  - previous_net_amount - previous_vat_amount
                return_box = return_box.update(amount: updated_amount)
            end
        end


        # Add new amount 

        @new_country_tax_code = CountryTaxCode.where(country_id: @entity.country.id, tax_code_operation_location_id: @transaction.invoice.tax_code_operation_location.id, tax_code_operation_side_id: @transaction.invoice.tax_code_operation_side.id, tax_code_operation_rate_id: @item.tax_code_operation_rate.id, tax_code_operation_type_id: @item.tax_code_operation_type.id)[0]

        @new_entity_tax_code = EntityTaxCode.where(entity_id: @entity.id, country_tax_code_id: @new_country_tax_code.id)

        # if you don't have a tax code, you'll need to create one
        if @new_entity_tax_code.empty?
            name_tax_code = @transaction.invoice.tax_code_operation_location.name + " | " + @transaction.invoice.tax_code_operation_side.name + " | " + @transaction.item.tax_code_operation_type.name + " | " + @transaction.item.tax_code_operation_rate.name
            @new_entity_tax_code = EntityTaxCode.new(name: name_tax_code, entity_id: @entity.id, country_tax_code_id: @new_country_tax_code.id)
            @new_entity_tax_code.save

        end

        @new_entity_tax_code = EntityTaxCode.where(entity_id: @entity.id, country_tax_code_id: @new_country_tax_code.id)[0]

        box_informations = BoxInformation.where(tax_code_operation_location_id: @new_entity_tax_code.country_tax_code.tax_code_operation_location_id, tax_code_operation_rate_id: @new_entity_tax_code.country_tax_code.tax_code_operation_rate_id, tax_code_operation_side_id: @new_entity_tax_code.country_tax_code.tax_code_operation_side_id, tax_code_operation_type_id: @new_entity_tax_code.country_tax_code.tax_code_operation_type_id )
        

        box_informations.each do |box_information|
            return_box = ReturnBox.where(box_name_id: box_information.box_name_id)[0]
            amount = box_information.amount.name
            if amount == "Reporting Currency Taxable Basis"
                updated_amount = return_box.amount + net_amount 
                return_box = return_box.update(amount: updated_amount)
            elsif amount == "Reporting Currency VAT Amount"
                updated_amount = return_box.amount + vat_amount 
                return_box = return_box.update(amount: updated_amount)
            elsif amount == "Reporting Currency Gross Amount"
                updated_amount = return_box.amount + net_amount + vat_amount 
                return_box = return_box.update(amount: updated_amount)
            end
        end


        # will have to multiply quantity with what is specified
        @transaction.update!(vat_amount: vat_amount, net_amount: net_amount, comment: params[:comment], invoice_id: @invoice.id, :item_id => @item.id, :quantity => quantity)
    
        redirect_to company_invoice_path(@company, @invoice.id)

    end


    def delete_transaction
        @company = Company.find(params[:company_id])

        @transaction = Transaction.find(params[:transaction_id])
        @invoice = @transaction.invoice
        @entity = @invoice.entity
        @item = @transaction.item
        @return = Return.where(["begin_date <= ? and end_date >= ? and entity_id = ? and country_id = ?",   @invoice.invoice_date,  @invoice.invoice_date, @item.entity.id, 2])[0]

        # substract old amount 

        @country_tax_code = CountryTaxCode.where(country_id: @entity.country.id, tax_code_operation_location_id: @transaction.invoice.tax_code_operation_location.id, tax_code_operation_side_id: @transaction.invoice.tax_code_operation_side.id, tax_code_operation_rate_id: @transaction.item.tax_code_operation_rate.id, tax_code_operation_type_id: @transaction.item.tax_code_operation_type.id)[0]

        @entity_tax_code = EntityTaxCode.where(entity_id: @entity.id, country_tax_code_id: @country_tax_code.id)[0]
      
        @periodicity = @entity.periodicity
        @project_type = ProjectType.where(name: "VAT")[0]
     
        box_informations = BoxLogic.where(tax_code_operation_location_id: @entity_tax_code.country_tax_code.tax_code_operation_location_id, tax_code_operation_rate_id: @entity_tax_code.country_tax_code.tax_code_operation_rate_id, tax_code_operation_side_id: @entity_tax_code.country_tax_code.tax_code_operation_side_id, tax_code_operation_type_id: @entity_tax_code.country_tax_code.tax_code_operation_type_id, document_type_id: @invoice.document_type_id )
                

        box_informations.each do |box_information|

            # Check if box_name is the one from this periodicity
            if box_information.box.project_type_id == @project_type.id && box_information.box.periodicity_id == @periodicity.id
                return_box = ReturnBox.where(box_id: box_information.box_id, return: @return.id)[0]
                amount = box_information.amount.name
                if amount == "Reporting Currency Taxable Basis"
                    if box_information.operation_type.name == 'Add'

                        updated_amount = return_box.amount - @transaction.net_amount
                        return_box = return_box.update(amount: updated_amount)
                    else
                        updated_amount = return_box.amount + @transaction.net_amount
                        return_box = return_box.update(amount: updated_amount)

                    end
                elsif amount == "Reporting Currency VAT Amount"
                    if box_information.operation_type.name == 'Add'

                        updated_amount = return_box.amount - @transaction.vat_amount
                        return_box = return_box.update(amount: updated_amount)
                    else
                        updated_amount = return_box.amount + @transaction.vat_amount
                        return_box = return_box.update(amount: updated_amount)

                    end

                elsif amount == "Reporting Currency Gross Amount"
                    if box_information.operation_type.name == 'Add'

                        updated_amount = return_box.amount  -(@transaction.net_amount + @transaction.vat_amount)
                        return_box = return_box.update(amount: updated_amount)
                    else
                        updated_amount = return_box.amount + (@transaction.net_amount + @transaction.vat_amount)
                        return_box = return_box.update(amount: updated_amount)

                    end


                end
            end
        end

        @transaction.destroy
        redirect_to company_invoice_path(@company, @invoice.id)
        
    end

    # French

    def edit_transaction_french_invoice
        @transaction = Transaction.find(params[:transaction_id])
        @company = current_user.company
        @invoice = @transaction.invoice
        @item = @transaction.item
        @entity = @item.entity
        @items = @entity.items
    end

    def save_transaction_french_invoice
        @company = Company.find(params[:company_id])
        @item = Item.find(params[:item_id])
        @invoice = Invoice.find(params[:invoice_id])
        @transaction = Transaction.find(params[:transaction_id])
        quantity = params[:quantity].to_f
        net_amount = quantity * @item.net_amount
        vat_amount = quantity * @item.vat_amount

        # will have to multiply quantity with what is specified
        @transaction.update!(vat_amount: vat_amount, net_amount: net_amount, comment: params[:comment], invoice_id: @invoice.id, :item_id => @item.id, :quantity => quantity)
    
        path = '/entreprises/' + @company.id.to_s + '/factures/' + @invoice.id.to_s 
        redirect_to path

    end

    def delete_transaction_french
        @company = Company.find(params[:company_id])

        @transaction = Transaction.find(params[:transaction_id])
        @invoice = @transaction.invoice
        @entity = @invoice.entity
        @item = @transaction.item
        @return = Return.where(["begin_date <= ? and end_date >= ? and entity_id = ? and country_id = ?",   @invoice.invoice_date,  @invoice.invoice_date, @item.entity.id, 2])[0]

        # substract old amount 

        @country_tax_code = CountryTaxCode.where(country_id: @entity.country.id, tax_code_operation_location_id: @transaction.invoice.tax_code_operation_location.id, tax_code_operation_side_id: @transaction.invoice.tax_code_operation_side.id, tax_code_operation_rate_id: @transaction.item.tax_code_operation_rate.id, tax_code_operation_type_id: @transaction.item.tax_code_operation_type.id)[0]

        @entity_tax_code = EntityTaxCode.where(entity_id: @entity.id, country_tax_code_id: @country_tax_code.id)[0]
      
        @periodicity = @entity.periodicity
        @project_type = ProjectType.where(name: "VAT")[0]
     
        box_informations = BoxLogic.where(tax_code_operation_location_id: @entity_tax_code.country_tax_code.tax_code_operation_location_id, tax_code_operation_rate_id: @entity_tax_code.country_tax_code.tax_code_operation_rate_id, tax_code_operation_side_id: @entity_tax_code.country_tax_code.tax_code_operation_side_id, tax_code_operation_type_id: @entity_tax_code.country_tax_code.tax_code_operation_type_id, document_type_id: @invoice.document_type_id )
                

        box_informations.each do |box_information|

            # Check if box_name is the one from this periodicity
            if box_information.box.project_type_id == @project_type.id && box_information.box.periodicity_id == @periodicity.id
                return_box = ReturnBox.where(box_id: box_information.box_id, return: @return.id)[0]
                amount = box_information.amount.name
                if amount == "Reporting Currency Taxable Basis"
                    if box_information.operation_type.name == 'Add'

                        updated_amount = return_box.amount - @transaction.net_amount
                        return_box = return_box.update(amount: updated_amount)
                    else
                        updated_amount = return_box.amount + @transaction.net_amount
                        return_box = return_box.update(amount: updated_amount)

                    end
                elsif amount == "Reporting Currency VAT Amount"
                    if box_information.operation_type.name == 'Add'

                        updated_amount = return_box.amount - @transaction.vat_amount
                        return_box = return_box.update(amount: updated_amount)
                    else
                        updated_amount = return_box.amount + @transaction.vat_amount
                        return_box = return_box.update(amount: updated_amount)

                    end

                elsif amount == "Reporting Currency Gross Amount"
                    if box_information.operation_type.name == 'Add'

                        updated_amount = return_box.amount  -(@transaction.net_amount + @transaction.vat_amount)
                        return_box = return_box.update(amount: updated_amount)
                    else
                        updated_amount = return_box.amount + (@transaction.net_amount + @transaction.vat_amount)
                        return_box = return_box.update(amount: updated_amount)

                    end


                end
            end
        end
        @transaction.destroy

        path = '/entreprises/' + @company.id.to_s + '/factures/' + @invoice.id.to_s 
        redirect_to path

    end
    

    # French

    def index_french

        @return = Return.find(params_transaction[:return_id])
        @transactions = @return.transactions
        @company = Company.find(params[:company_id])
        @entity = @return.entity
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