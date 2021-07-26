class InvoicesController < ApplicationController

    def index
        @entities = current_user.company.entities
        @invoices = Invoice.order("invoice_date asc").where(entity_id: current_user.company.entities)
    end

    def new
        @invoice = Invoice.new
        2.times { @invoice.transactions.build }
        @company = current_user.company
        @entities = current_user.company.entities
        @customers = Customer.where(company_id: current_user.company)
    end

    def create
        @entity_tax_codes = EntityTaxCode.find(params[:entity_tax_codes][:entity_tax_codes_id])
        @invoice = Invoice.new(invoice_date: params[:invoice][:invoice_date], invoice_name: params[:invoice][:invoice_name], payment_date: params[:invoice][:payment_date], customer_id: params[:customer].to_i, entity_id: @entity_tax_codes.entity.id)
        transactions = params[:comment]
        i = 0
        transactions.each do |key, value| 
            i += 1
            @return = Return.where(["begin_date <= ? and end_date >= ? and entity_id = ? and country_id = ?",   params[:invoice][:invoice_date],  params[:invoice][:invoice_date], @entity_tax_codes.entity.id, 2])
            # If return doesn't exist, need to create it
            if @return.empty?

            else

            end
            last_day_month = Time.days_in_month(params_declaration[:end_date][5..6].to_i, params_declaration[:end_date][0..3].to_i)
            hjk
            Return.where(["begin_date < ? and end_date > ?",   "2021-02-28",  "2021-02-27"])
            @transaction = Transaction.new(invoice_number: i, invoice_date: params[:invoice][:invoice_date], vat_amount: params[:vat_amount][key].to_i, net_amount: params[:net_amount][key].to_i, total_amount: (params[:vat_amount][key].to_i + params[:net_amount][key].to_i), comment: params[:comment][key], invoice_id: @invoice.id, entity_tax_code_id: @entity_tax_codes.id, return_id: 1)
            fghjkl
        end
        # A transaction is linked to an invoice, so need to first create the invoice
        if @invoice.save!
            @transaction = Transaction.new

        else

        end

        ghujkl
    end

    def test
        test = request.original_url
        testo = test.split("#")[1]
        @entity_tax_codes = EntityTaxCode.where(entity_id: params[:entity_id])
        html_string = render_to_string(partial: "add_item.html.erb", locals: {entity_tax_codes: @entity_tax_codes})
        render json: {html_string: html_string}
    end

    def add_item
        hjk
        
        html_string = render_to_string(partial: "select_country.html.erb", locals: {countries: []})
        render json: {html_string: html_string}
    end

    def render_add_item
        test = request.original_url
        testo = test.split("#")[1]
        hjk
        @entity_tax_codes = EntityTaxCode.all
        html_string = render_to_string(partial: "add_item.html.erb", locals: {entity_tax_codes: @entity_tax_codes})
        render json: {html_string: html_string}
=begin jjj
        html_string = render_to_string(partial: "select_country.html.erb", locals: {countries: @entities})
        render json: {html_string: html_string}
        @company = current_user.company
        render :json => { zzz:success => true,:product => @company.as_json() }
=end
    end


    private

    def params_add_item
        params.require(:invoice)
        
    end

end