class InvoicesController < ApplicationController

    def index
        @entities = current_user.company.entities
        @invoices = Invoice.order("invoice_date asc").where(entity_id: current_user.company.entities)
    end

    def new
        @invoice = Invoice.new
        @company = current_user.company
        @entities = current_user.company.entities
        @customers = Customer.where(company_id: current_user.company)
    end


end