class TransactionsController < ApplicationController

    def index
        @return = Return.find(params_transaction[:return_id])
        @transactions = @return.transactions
        @company = current_user.company
        @entity = @return.entity
    end

    def new
        @return = Return.find(params[:return_id])
        @company = current_user.company
        @entity = @return.entity
        @transaction = Transaction.new
        @tax_codes = @entity.entity_tax_codes
    end

    def create
        @transaction = Transaction.new(invoice_number: params_new_transaction[:invoice_number], invoice_date: params_new_transaction[:invoice_date], vat_amount: params_new_transaction[:vat_amount], net_amount: params_new_transaction[:net_amount], total_amount: params_new_transaction[:total_amount], business_partner_name: params_new_transaction[:business_partner_name], business_partner_vat_number: params_new_transaction[:business_partner_vat_number])
        @return = Return.find(params[:return_id])
        @transaction.return = @return
        @tax_code = EntityTaxCode.find(params_tax_code[:tax_code_id])
        @transaction.entity_tax_code = @tax_code
        if @transaction.save!
            redirect_to company_entity_return_transactions_path(current_user.company.id, @return.entity.id, @return.id)
        else 
            render :new
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
        # if user didn't update the tax code
        if params_tax_code[:tax_code_id].empty?
            @transaction = @transaction.update(invoice_number: params_new_transaction[:invoice_number], invoice_date: params_new_transaction[:invoice_date], vat_amount: params_new_transaction[:vat_amount], net_amount: params_new_transaction[:net_amount], total_amount: params_new_transaction[:total_amount], business_partner_name: params_new_transaction[:business_partner_name], business_partner_vat_number: params_new_transaction[:business_partner_vat_number])
        else
            @tax_code = EntityTaxCode.find(params_tax_code[:tax_code_id])
            @transaction = @transaction.update(invoice_number: params_new_transaction[:invoice_number], invoice_date: params_new_transaction[:invoice_date], vat_amount: params_new_transaction[:vat_amount], net_amount: params_new_transaction[:net_amount], total_amount: params_new_transaction[:total_amount], business_partner_name: params_new_transaction[:business_partner_name], business_partner_vat_number: params_new_transaction[:business_partner_vat_number], entity_tax_code_id: @tax_code.id)
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
        params.require(:transaction).permit(:invoice_number, :invoice_date, :vat_amount, :net_amount, :total_amount, :business_partner_name, :business_partner_vat_number)
    end

    def params_tax_code
        params.permit(:tax_code_id)
    end
end