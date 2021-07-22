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

    def add_item
        hjk
        
        html_string = render_to_string(partial: "select_country.html.erb", locals: {countries: []})
        render json: {html_string: html_string}
    end

    def render_add_item
        hjkl
    end

end