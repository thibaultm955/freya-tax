class InvoicesController < ApplicationController

    def index
        @entities = current_user.company.entities
        @invoices = Invoice.order("invoice_date asc").where(entity_id: current_user.company.entities)
    end

    def show
        @invoice = Invoice.find(params[:id])
        @transactions = @invoice.transactions

    end

    def new
        @invoice = Invoice.new
        @company = current_user.company
        @entities = current_user.company.entities
        @customers = Customer.where(company_id: current_user.company)
    end

    def create  
        @entity_tax_codes = EntityTaxCode.find(params[:entity_tax_codes][:entity_tax_codes_id])
        @entity = @entity_tax_codes.entity
        @invoice = Invoice.new(invoice_date: params[:invoice][:invoice_date], invoice_name: params[:invoice][:invoice_name], payment_date: params[:invoice][:payment_date], invoice_number: params[:invoice][:invoice_number], customer_id: params[:customer].to_i, entity_id: @entity_tax_codes.entity.id)
        transactions = params[:comment]
        i = 0
        transactions.each do |key, value| 
            i += 1
            @return = Return.where(["begin_date <= ? and end_date >= ? and entity_id = ? and country_id = ?",   params[:invoice][:invoice_date],  params[:invoice][:invoice_date], @entity_tax_codes.entity.id, 2])[0]
            # If return doesn't exist, need to create it
            if @return.nil?
                
                last_day_month = Time.days_in_month(params[:invoice][:invoice_date][5..6].to_i, params[:invoice][:invoice_date][0..3].to_i) 
                from_date = Date.parse(params[:invoice][:invoice_date][0..7] + "01")
                to_date = Date.parse(params[:invoice][:invoice_date][0..7] + last_day_month.to_s)
                # Set up Periodicity To Project Type as VAT Monthly
                @periodicity_to_project_type = PeriodicityToProjectType.where(project_type_id: 1, periodicity_id: 1)[0]
                # Set up country as Belgium = 2
                @return = Return.new(begin_date: from_date, end_date: to_date ,  periodicity_to_project_type_id: @periodicity_to_project_type.id, country_id: 2, entity_id: @entity.id, due_date_id: @periodicity_to_project_type.due_date.id)
                @return_boxes = []
            
                #language_id is hardcoded as not yet defined
                box_names = BoxName.where(periodicity_to_project_type_id: @periodicity_to_project_type.id, language_id: 2)
                
                @return.save!
                # Can only put the box an amount if it is indeed created to get the id
                box_names.each do |box_name|
                    return_box = ReturnBox.new(return_id: @return.id, box_name_id: box_name.id, amount: 0)
                    return_box.save!
                end
            end

            if @invoice.save!
                @item = Item.find(params[:item][key].to_i)
                net_amount = params[:net_amount][key].to_f
                vat_amount = params[:vat_amount][key].to_f
                total_amount = params[:vat_amount][key].to_f + params[:net_amount][key].to_f
                quantity = params[:quantity][key].to_i
                # will have to multiply quantity with what is specified
                @transaction = Transaction.new(vat_amount: vat_amount * quantity, net_amount: net_amount * quantity, total_amount: total_amount * quantity, comment: params[:comment][key], invoice_id: @invoice.id, entity_tax_code_id: @entity_tax_codes.id, return_id: @return.id)
                @transaction.save!
                @item_transaction = ItemTransaction.new(quantity: quantity, item_id: @item.id, transaction_id: @transaction.id, net_amount: net_amount, vat_amount: vat_amount)
                @item_transaction.save!
            end
        end
        # A transaction is linked to an invoice, so need to first create the invoice

        redirect_to company_invoices_path(current_user.company)

        
    end

    def edit
        @invoice = Invoice.find(params[:id])
        @transactions = @invoice.transactions
        @company = current_user.company
        @entities = current_user.company.entities
        @customers = Customer.where(company_id: current_user.company)
    end


    def update
        @invoice = Invoice.find(params[:id])
        @invoice.update(:invoice_date => params[:invoice][:invoice_date], :payment_date => params[:invoice][:payment_date], :invoice_number => params[:invoice][:invoice_number], :invoice_name => params[:invoice][:invoice_name], :customer_id => params[:customer])
        
        redirect_to company_invoice_path(current_user.company, @invoice.id)
    end

    def add_transaction
        @invoice = Invoice.find(params[:invoice_id])
        @transactions = @invoice.transactions
        @company = current_user.company
        @entities = current_user.company.entities
        @customers = Customer.where(company_id: current_user.company)
    end


    def save_transaction
 
        @invoice = Invoice.find(params[:invoice_id])

        # if you don't have a new transaction, don't need to do an update
        if !params[:entity_tax_codes].nil?
            @entity_tax_codes = EntityTaxCode.find(params[:entity_tax_codes][:entity_tax_codes_id])
            @entity = @entity_tax_codes.entity
            transactions = params[:comment]
            i = 0
            transactions.each do |key, value| 
                i += 1
                @return = Return.where(["begin_date <= ? and end_date >= ? and entity_id = ? and country_id = ?",   @invoice.invoice_date,  @invoice.invoice_date, @entity_tax_codes.entity.id, 2])[0]
                @item = Item.find(params[:item][key].to_i)
                net_amount = params[:net_amount][key].to_f
                vat_amount = params[:vat_amount][key].to_f
                total_amount = vat_amount + net_amount
                quantity = params[:quantity][key].to_f
                # will have to multiply quantity with what is specified
                @transaction = Transaction.new(vat_amount: vat_amount * quantity, net_amount: net_amount * quantity, total_amount: total_amount * quantity, comment: params[:comment][key], invoice_id: @invoice.id, entity_tax_code_id: @entity_tax_codes.id, return_id: @return.id)
                @transaction.save!
                @item_transaction = ItemTransaction.new(quantity: quantity, item_id: @item.id, transaction_id: @transaction.id, net_amount: net_amount, vat_amount: vat_amount)
                @item_transaction.save!

            end
        end

        redirect_to company_invoice_path(current_user.company, @invoice.id)
    end

    def render_add_item
        test = request.original_url
        testo = test.split("#")[1]
        @entity_tax_codes = EntityTaxCode.where(entity_id: params[:entity_id])
        @entity = Entity.find(params[:entity_id])
        @items = @entity.items
        html_string = render_to_string(partial: "add_item.html.erb", locals: {entity_tax_codes: @entity_tax_codes, items: @items})
        render json: {html_string: html_string}
    end

    def render_add_item_2
        test = request.original_url
        testo = test.split("#")[1]
        @entity_tax_codes = EntityTaxCode.where(entity_id: params[:entity_id])
        @entity = Entity.find(params[:entity_id])
        @items = @entity.items
        html_string = render_to_string(partial: "add_item.html.erb", locals: {entity_tax_codes: @entity_tax_codes, items: @items})
        render json: {html_string: html_string}
    end

    def generate_pdf
        @invoice = Invoice.find(params[:invoice_id])
        @transactions = @invoice.transactions
        size_text = 12
        respond_to do |format|
            # some other formats like: format.html { render :show }
      
            format.pdf do
              pdf = Prawn::Document.new
              pdf.text 'Invoice', :align => :right, :size => 32
              pdf.text ''
              # Entity Information
              pdf.text @invoice.entity.name, :align => :right, :size => size_text, :style => :bold
              pdf.text @invoice.entity.address, :align => :right, :size => size_text
              pdf.text @invoice.entity.city + ', ' + @invoice.entity.postal_code, :align => :right, :size => size_text 
              pdf.text @invoice.entity.phone_number, :align => :right, :size => size_text 
              pdf.text ' '
              pdf.stroke_horizontal_rule
              pdf.text ' '
              pdf.text ' '
              pdf.text 'Bill_To', :align => :left, :size => size_text
              # Customer Information
              pdf.draw_text @invoice.customer.name, :at => [0, 562], :size => size_text, :style => :bold
              pdf.draw_text @invoice.customer.vat_number, :at => [0, 547], :size => size_text
              pdf.draw_text @invoice.customer.street, :at => [0, 532], :size => size_text
              pdf.draw_text @invoice.customer.city + ', ' + @invoice.customer.post_code, :at => [0, 517], :size => size_text
              pdf.draw_text @invoice.customer.country.name, :at => [0, 502], :size => size_text
              # Invoice Information
              pdf.draw_text 'Invoice Name:', :at => [320, 577], :size => size_text, :style => :bold
              pdf.draw_text @invoice.invoice_name, :at => [430, 577], :size => size_text
              pdf.draw_text 'Invoice Number:', :at => [320, 557], :size => size_text, :style => :bold
              pdf.draw_text @invoice.invoice_number, :at => [430, 557], :size => size_text
              pdf.draw_text 'Invoice Date:', :at => [320, 537], :size => size_text, :style => :bold
              pdf.draw_text @invoice.invoice_date, :at => [430, 537], :size => size_text
              pdf.draw_text 'Payment Date:', :at => [320, 517], :size => size_text, :style => :bold
              pdf.draw_text @invoice.payment_date, :at => [430, 517], :size => size_text

              # need to do Amount Due
              pdf.text ' '
              pdf.text ' '
              pdf.text ' '
              pdf.text ' '
              pdf.text ' '
              pdf.text ' '
              pdf.text ' '
              pdf.text ' '
              total_amount = 0
              total_vat = 0

              footer_line_1 = @invoice.entity.name
              footer_line_2 = 'Email:  ' +   @invoice.entity.email + '   Website:  ' + @invoice.entity.website + '   VAT:  ' + @invoice.entity.vat_number
              footer_line_3 = 'IBAN:  ' + @invoice.entity.iban + '   BIC:  ' + @invoice.entity.bic

              i = 0
              # pagingation
              u = 1
              data = [["Items", "Comments", "Quantity", "Net Amount / Unit", "VAT Amount / Unit", "Total Price"]]
        
              if @transactions.count < 10
                @transactions.each do |transaction|
                    data += [[transaction.item_transaction.item.item_name, transaction.comment, transaction.item_transaction.quantity, transaction.item_transaction.net_amount, transaction.item_transaction.vat_amount, transaction.total_amount]]
                    total_amount += transaction.total_amount
                    total_vat += transaction.item_transaction.vat_amount * transaction.item_transaction.quantity
                end
                pdf.table data, :position => :left
              else
                while i < @transactions.count - 1
                    i +=1
                    # For every 10 transactions, you'll create a new page
                    if ( i % 10 ) == 0
                        page_number = u.to_s + " / " + ( @transactions.count / 10 + 1).to_i.to_s 
                        pdf.table data, :position => :left, :column_widths => {0 => 115,1 => 160,2 => 60,3 => 60,4 => 60,5 => 85}
                        
                        pdf.text_box footer_line_1, :at => [-02, 60], :size => size_text, :align => :center
                        pdf.text_box footer_line_2, :at => [-02, 45], :size => size_text, :align => :center
                        pdf.text_box footer_line_3, :at => [-02, 30], :align => :center, :size => size_text
                        pdf.text_box page_number, :at => [-02, 15], :align => :center, :size => size_text

                        pdf.start_new_page
                        data = [["Items", "Comments", "Quantity", "Net Amount / Unit", "VAT Amount / Unit", "Total Price"]]
                        u += 1
                    else
                        data += [[@transactions[i].item_transaction.item.item_name, @transactions[i].comment, @transactions[i].item_transaction.quantity, @transactions[i].item_transaction.net_amount, @transactions[i].item_transaction.vat_amount, @transactions[i].total_amount]]
                        total_amount += @transactions[i].total_amount
                        total_vat += @transactions[i].item_transaction.vat_amount * @transactions[i].item_transaction.quantity
                        page_number = u.to_s + " / " + ( @transactions.count / 10 + 1).to_i.to_s 
                        pdf.text_box page_number, :at => [-02, 15], :align => :center, :size => size_text


                    end
                    
                end
                @transactions.each do |transaction|

                end
              end

              pdf.table data, :position => :left, :column_widths => {0 => 115,1 => 160,2 => 60,3 => 60,4 => 60,5 => 85}


              pdf.text ' '
              pdf.text ' '
              pdf.text ' '
              pdf.table [['Total Amount', total_amount], ['Total VAT', total_vat]]  

              pdf.text_box footer_line_1, :at => [-02, 60], :size => size_text, :align => :center
              pdf.text_box footer_line_2, :at => [-02, 45], :size => size_text, :align => :center
              pdf.text_box footer_line_3, :at => [-02, 30], :align => :center, :size => size_text

              send_data pdf.render,
                filename: "export.pdf",
                type: 'application/pdf',
                disposition: 'inline'
            end
          end

    end


    private

    def params_add_item
        params.require(:invoice)
        
    end

end