class DashboardController < ApplicationController

    def index_french
        @company = Company.find(params[:company_id])
        @entities = @company.entities
        @invoices_top_5 = Invoice.order("invoice_date asc").where(:entity_id => @entities.ids, is_paid: [false, nil])[0..4]
    end
end