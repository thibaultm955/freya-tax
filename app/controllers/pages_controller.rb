class PagesController < ApplicationController
  def home
    @user = current_user
        @user_accesses = UserAccessCompany.where(user_id: @user.id)
        @entity_ids = []
        @user_accesses.each do |user_access|
            @entity_ids += user_access.company.entity_ids
        end
        @entities = Entity.where(id: @entity_ids)

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
        @not_paid_count = {}
        @paid_count = {}
        @not_paid_amount = {}
        @paid_amount = {}
        @all_amount = {}
        array_iterate = ["07-2021", "08-2021", "09-2021", "10-2021", "11-2021", "12-2021", "01-2022", "02-2022", "03-2022", "04-2022", "05-2022", "06-2022", "07-2022", "08-2022", "09-2022", "10-2022", "11-2022", "12-2022" ]

        array_iterate.each do |date|
            @all_amount[date] = 0
            @paid_amount[date] = 0
            @not_paid_amount[date] = 0
            @paid_count[date] = 0
            @not_paid_count[date] = 0

        end

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
