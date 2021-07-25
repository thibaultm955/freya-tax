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
        ghujkl
    end

    def test
        html_string = render json: {html_string: 'test'}
    end

    def add_item
        hjk
        
        html_string = render_to_string(partial: "select_country.html.erb", locals: {countries: []})
        render json: {html_string: html_string}
    end

    def render_add_item
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

end