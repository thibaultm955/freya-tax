class DashboardController < ApplicationController

    def index_french
        @company = Company.find(params[:company_id])
        @entities = @company.entities
        @invoices_top_5 = Invoice.order("invoice_date asc").where(:entity_id => @entities.ids, is_paid: [false, nil])[0..4]
        @invoices = Invoice.where(:entity_id => @entities.ids)
        @data_count = [
                        {
                            name: "paid", 
                            data: []
                        },
                        {
                            name: "not_paid", 
                            data: []
                        }
                    ]
        @data_amount = [
                            {
                                name: "paid", 
                                data: []
                            },
                            {
                                name: "not_paid", 
                                data: []
                            }
                        ]
        @data_all = [
                            {
                                name: "revenues", 
                                data: []
                            }
                        ]
        @array_count = [["date", "paid", "not_paid"]]
        @array_amount = [["date", "amount_paid", "amount_not_paid"]]
        @not_paid_count = {"07-2021" => 0, "08-2021" => 0, "09-2021" => 0}
        @paid_count = {"07-2021" => 0, "08-2021" => 0, "09-2021" => 0}
        @not_paid_amount = {"07-2021" => 0, "08-2021" => 0, "09-2021" => 0}
        @paid_amount = {"07-2021" => 0, "08-2021" => 0, "09-2021" => 0}
        @all_amount = {"07-2021" => 0, "08-2021" => 0, "09-2021" => 0}
        array_iterate = ["07-2021", "08-2021", "09-2021" ]

        @array_count_paid = []
        @array_count_not_paid = []
        @array_amount_paid = []
        @array_amount_not_paid = []
        @array_amount_all = []

        @invoices.each do |invoice|
            # Extract sum
            total_amount = 0
            invoice.transactions.each do |transaction|
                total_amount += transaction.net_amount+ transaction.vat_amount
            end

            @all_amount[invoice.payment_date.strftime("%m-%Y")] += total_amount

            if invoice.is_paid == true
                @paid_count[invoice.payment_date.strftime("%m-%Y")] += 1
                @paid_amount[invoice.payment_date.strftime("%m-%Y")] += total_amount

            else
                @not_paid_count[invoice.payment_date.strftime("%m-%Y")] += 1
                @not_paid_amount[invoice.payment_date.strftime("%m-%Y")] += total_amount

            end 
        end

        array_iterate.each do |date|
            @array_count_paid << [date, @paid_count[date]]
            @array_count_not_paid << [date,  @not_paid_count[date]]
            @array_amount_paid << [date, @paid_amount[date]]
            @array_amount_not_paid << [date, @not_paid_amount[date]]
            @array_amount_all << [date, @all_amount[date]]

        end
        @data_count[0][:data] = @array_count_paid
        @data_count[1][:data] = @array_count_not_paid
        @data_amount[0][:data] = @array_amount_paid
        @data_amount[1][:data] = @array_amount_not_paid
        @data_all[0][:data] = @array_amount_all
    end
end