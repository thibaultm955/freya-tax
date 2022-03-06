class InvoicesController < ApplicationController

    def index
        @user = current_user
        @user_accesses = UserAccessCompany.where(user_id: @user.id)
        @entity_ids = []
        @user_accesses.each do |user_access|

            @entity_ids += user_access.company.entity_ids
        end
        @entities = Entity.where(id: @entity_ids)
        @invoices = Invoice.get_all_invoices_with_filter(params_query, @user)

    end

    def show
        # test = @invoice.author("Invoice Test updated", @invoice)
        @invoice = Invoice.find(params[:id])
        @transactions = @invoice.transactions
        @cloudinary_photos = @invoice.cloudinary_photos
    end

    def new
        @user = current_user
        @invoice = Invoice.new

        @company = Company.find(params[:company_id])
        @user_accesses = UserAccessCompany.where(user_id: @user.id)
        @entity_ids = []
        @company_ids = []

        @user_accesses.each do |user_access|
            @company_ids << user_access.company_id
            @entity_ids += user_access.company.entity_ids
        end
        @entities = Entity.where(id: @entity_ids)
        @customers = Customer.where(entity_id: @entity_ids)
        @sides = TaxCodeOperationSide.all
        @locations = TaxCodeOperationLocation.all
    end

    def create  
        @entity = Entity.find(params[:entity])
        @side = TaxCodeOperationSide.find(params[:side])
        @location = TaxCodeOperationLocation.find(params[:location])
        @customer = Customer.find(params[:customer])
        @european_countries = Country.where(is_eu: 1).ids
        # Check if it is a credit note or not
        if params[:credit_note].nil?
            @document_type = DocumentType.where(name: "Invoice")[0]
            @invoice = Invoice.new(invoice_date: params[:invoice][:invoice_date], invoice_name: params[:invoice][:invoice_name], payment_date: params[:invoice][:payment_date], invoice_number: params[:invoice][:invoice_number], customer_id: @customer.id, entity_id: @entity.id, tax_code_operation_side_id: @side.id, tax_code_operation_location_id: @location.id, document_type_id: @document_type.id )

        else
            @document_type = DocumentType.where(name: "Credit Note")[0]
            @invoice = Invoice.new(invoice_date: params[:invoice][:invoice_date], invoice_name: params[:invoice][:invoice_name], payment_date: params[:invoice][:payment_date], invoice_number: params[:invoice][:invoice_number], customer_id: @customer.id, entity_id: @entity.id, tax_code_operation_side_id: @side.id, tax_code_operation_location_id: @location.id, document_type_id: @document_type.id )

        end

        if @invoice.save!  
        # A transaction is linked to an invoice, so need to first create the invoice

            redirect_to invoices_path
        else
            render :new
        end

        
    end

    def edit
        @invoice = Invoice.find(params[:id])
        @transactions = @invoice.transactions
        @company = Company.find(params[:company_id])
        @entities = @company.entities
        @customers = Customer.where(entity_id: @entities)
    end

    def delete_invoice
        @company = Company.find(params[:company_id])
        @invoice = Invoice.find(params[:invoice_id])
        @transactions = @invoice.transactions
        # if you have transaction, you cannot remove the invoice
        if !@transactions.nil?
            redirect_to '/companies/' + @company.id.to_s + '/invoices'
            
        else
            @transactions.each do |transaction|
                amounts = Item.extract_amounts(transaction.quantity, transaction.item)
                Transaction.remove_and_take_out_amounts(transaction, amounts)
            end    
            @invoice.destroy
            redirect_to company_invoices_path(@company)
    
        end


    end


    def update
        @company = Company.find(params[:company_id])
        @invoice = Invoice.find(params[:id])
        if !params[:invoice][:photo].nil?
            result_cloudinary = Cloudinary::Uploader.upload(params[:invoice][:photo].tempfile, :public_id => params[:name_photo])
            @cloudinary_photo = CloudinaryPhoto.new(invoice_id: @invoice.id, api_key: result_cloudinary["api_key"], secure_url: result_cloudinary["secure_url"], name: result_cloudinary["public_id"])
            @cloudinary_photo.save
        end
        @invoice.update(:invoice_date => params[:invoice][:invoice_date], :payment_date => params[:invoice][:payment_date], :invoice_number => params[:invoice][:invoice_number], :invoice_name => params[:invoice][:invoice_name], :customer_id => params[:customer])
        
        # if it is a non english speaker, will route him in the French part
        if current_user.language.name == "English"
            redirect_to '/companies/' + @company.id.to_s + '/invoices/' + @invoice.id.to_s
        elsif current_user.language.name == "French"
            redirect_to '/entreprises/' + @company.id.to_s + '/factures/' + @invoice.id.to_s
        end
    end

    def add_transaction
        @invoice = Invoice.find(params[:invoice_id])
        @transactions = @invoice.transactions
        @company = Company.find(params[:company_id])
        @entity = @invoice.entity
        @entity_tax_codes = EntityTaxCode.where(entity_id: @entity.id)
        @items = @entity.items
        @customers = Customer.where(company_id: @company.id)
        @rates = TaxCodeOperationRate.all
        
    end

    def add_photo
        @invoice = Invoice.find(params[:invoice_id])
        @company = Company.find(params[:company_id])
        # It will go to save when click in the form to save

    end

    def save_transaction
        @company = Company.find(params[:company_id])
 
        @invoice = Invoice.find(params[:invoice_id]) 

        @item = Item.find(params[:item])
        @rate = @item.tax_code_operation_rate
        @entity = @invoice.entity   
        @country = Country.find(@entity.country.id)

        @return = Return.where(["begin_date <= ? and end_date >= ? and entity_id = ? and country_id = ?",   @invoice.invoice_date,  @invoice.invoice_date, @item.entity.id, @country.id])[0]

        @periodicity = @entity.periodicity
        @project_type = ProjectType.where(name: "VAT")[0]
        
        # if you don't have a return, you'll need to create it
        if @return.nil?

            @set_up_dates_return = Invoice.extract_dates_invoice(@periodicity, @invoice)
            last_day_month = @set_up_dates_return[0]
            from_date = @set_up_dates_return[1]
            to_date = @set_up_dates_return[2]
            @due_date = DueDate.where(periodicity_id: @periodicity.id, project_type_id: @project_type.id, country_id: @country.id, begin_date: from_date, end_date: to_date )[0]
            @return = Return.new(begin_date: from_date, end_date: to_date ,  periodicity_id: @periodicity.id, country_id: @entity.country.id, entity_id: @entity.id, due_date_id: @due_date.id, project_type_id: @project_type.id)

                                
            @return.save!
            # Can only put the box an amount if it is indeed created to get the id
            # will create the boxnames for the return based on the periodicity_to_project_type
            Box.create_box_names_for_return(@periodicity, @project_type, @country, @return)


        end

        rate = TaxCodeOperationRate.find(params[:rate])
        country_rate = CountryRate.where(country_id: @country.id, tax_code_operation_rate_id: rate.id)[0]

        
        # if credit note, you'll need to take the amount into account
        if @invoice.document_type.id == 2
            # Based on the Item selected & the quantity specified, extract amounts
            amounts = Item.extract_amounts_credit_note(params[:quantity].to_i, params[:price].to_f, country_rate)

            Transaction.create_from_invoice_credit_note(@return, @item, @entity, amounts, params[:comment], @invoice, @periodicity, @project_type, rate)
        else
            # Based on the Item selected & the quantity specified, extract amounts
            amounts = Item.extract_amounts(params[:quantity].to_i, @item, country_rate)

            # Here we will create the transaction & update the corresponding boxes from the return
            Transaction.create_from_invoice(@return, @item, @entity, amounts, params[:comment], @invoice, @periodicity, @project_type, rate)
        end
        


        redirect_to '/companies/' + @company.id.to_s + '/invoices/' + @invoice.id.to_s 
    end

    def paid
        @company = Company.find(params[:company_id])
        @invoice = Invoice.find(params[:invoice_id])

        if @invoice.is_paid == true
            @invoice.update(:is_paid => false)
        else
            @invoice.update(:is_paid => true)
        end
        path = '/companies/' + @company.id.to_s + '/invoices' 
        redirect_to path
    end

    def delete_transaction

        jhk
    end

    def add_ticket
        @company = Company.find(params[:company_id])
        @invoice = Invoice.find(params[:invoice_id])
        @entity = @invoice.entity
        @countries = LanguageCountry.where(language_id: 2).order("name asc")
        @type_of_ticket = TicketToTaxCode.all.order("name asc")
    end 


    def save_ticket

        @invoice = Invoice.find(params[:invoice_id])
        @entity = @invoice.entity
        @rate = (params[:vat_amount].to_f / params[:net_amount].to_f).round(2)
        @tax_code_operation_rate = TaxCodeOperationRate.where(rate: @rate)[0]
        @ticket_to_tax_code = TicketToTaxCode.find(params[:ticket_type])
        @item = Item.new(item_name: @ticket_to_tax_code.name, item_description: params[:comment], net_amount: params[:net_amount].to_f, vat_amount: params[:vat_amount], entity_id: @entity.id, tax_code_operation_rate_id: @tax_code_operation_rate.id, tax_code_operation_type_id: @ticket_to_tax_code.tax_code_operation_type_id, is_hidden: true)

        @item.save!


        @return = Return.where(["begin_date <= ? and end_date >= ? and entity_id = ? and country_id = ?",   @invoice.invoice_date,  @invoice.invoice_date, @item.entity.id, 2])[0]

        @periodicity = @entity.periodicity
        @periodicity_to_project_type = PeriodicityToProjectType.where(project_type_id: 1, periodicity_id: @periodicity.id, country_id: @entity.country.id)[0]


        # if you don't have a return, you'll need to create it
        if @return.nil?

            @set_up_dates_return = Invoice.extract_dates_invoice(@periodicity, @invoice)
            last_day_month = @set_up_dates_return[0]
            from_date = @set_up_dates_return[1]
            to_date = @set_up_dates_return[2]

            @return = Return.new(begin_date: from_date, end_date: to_date ,  periodicity_to_project_type_id: @periodicity_to_project_type.id, country_id: @entity.country.id, entity_id: @entity.id, due_date_id: @periodicity_to_project_type.due_date.id)
                                
            @return.save
            # Can only put the box an amount if it is indeed created to get the id
            # will create the boxnames for the return based on the periodicity_to_project_type
            BoxName.create_box_names_for_return(@periodicity_to_project_type, @return)


        end

        # Based on the Item selected & the quantity specified, extract amounts
        amounts = Item.extract_amounts(params[:quantity].to_f, @item)
                
        # Here we will create the transaction & update the corresponding boxes from the return
        Transaction.create_from_invoice(@return, @item, @entity, amounts, params[:comment], @invoice, @periodicity_to_project_type)

        path = '/companies/' + @entity.company.id.to_s + '/invoices' 
        redirect_to path
    end

    def render_add_item
        test = request.original_url
        testo = test.split("#")[1]
        # if you don't know the invoice_id (invoice is not created)
        if params[:invoice_id].nil?
            @entity = Entity.find(params[:entity_id])
            @entity_tax_codes = EntityTaxCode.where(entity_id: @entity.id)
            @items = @entity.items
        else
            @invoice = Invoice.find(params[:invoice_id])
            @entity = @invoice.entity
            @entity_tax_codes = EntityTaxCode.where(entity_id: @entity.id)
            @items = @entity.items
        end
        html_string = render_to_string(partial: "add_item.html.erb", locals: {entity_tax_codes: @entity_tax_codes, items: @items})
        render json: {html_string: html_string}
    end

    def render_get_item
        @rates = TaxCodeOperationRate.all
        @item = Item.find(params[:item_id])
        html_string = render_to_string(partial: "get_item.html.erb", locals: {item: @item, rates: @rates})
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
              total_net_amount = 0
              total_vat = 0

              footer_line_1 = @invoice.entity.name
              footer_line_2 = 'Email:  ' +   @invoice.entity.email + '   Website:  ' + @invoice.entity.website + '   VAT:  ' + @invoice.entity.vat_number
              footer_line_3 = 'IBAN:  ' + @invoice.entity.iban + '       BIC:  ' + @invoice.entity.bic

              i = 0
              # pagingation
              u = 1
              data = [["Items", "Comments", "Quantity", "Net Amount / Unit", "VAT Amount / Unit", "Total Price"]]
        
              if @transactions.count < 10
                @transactions.each do |transaction|
                    total_amount_transaction = transaction.net_amount.round(2)  + transaction.vat_amount.round(2) 
                    data += [[transaction.item.item_name, transaction.comment, transaction.quantity, transaction.item.net_amount.round(2) , transaction.vat_amount.round(2) / transaction.quantity , total_amount_transaction.round(2) ]]
                    total_amount += transaction.net_amount.round(2)  + transaction.vat_amount.round(2) 
                    total_vat += transaction.vat_amount.round(2) 
                    total_net_amount += transaction.net_amount.round(2)
                end
              else
                while i < @transactions.count - 1
                    i +=1
                    # For every 10 transactions, you'll create a new page
                    if ( i % 10 ) == 0
                        page_number = u.to_s + " / " + ( @transactions.count / 10 + 1).to_i.to_s 
                        pdf.table data, :position => :left, :column_widths => {0 => 115,1 => 160,2 => 60,3 => 60,4 => 60,5 => 85}
                        
                        pdf.text_box footer_line_1, :at => [-02, 60], :size => size_text, :align => :center
                        pdf.text_box footer_line_2, :at => [-02, 45], :size => size_text - 2, :align => :center
                        pdf.text_box footer_line_3, :at => [-02, 30], :size => size_text - 2, :align => :center
                        pdf.text_box page_number, :at => [-02, 15], :align => :center, :size => size_text

                        pdf.start_new_page
                        data = [["Items", "Comments", "Quantity", "Net Amount / Unit", "VAT Amount / Unit", "Total Price"]]
                        u += 1
                    else
                        total_amount_transaction = @transactions[i].net_amount.round(2)  + @transactions[i].vat_amount.round(2) 
                        data += [[@transactions[i].item.item_name, @transactions[i].comment, @transactions[i].quantity, @transactions[i].item.net_amount.round(2) , @transactions[i].vat_amount.round(2) / @transactions[i].quantity, total_amount_transaction.round(2) ]]
                        total_vat += @transactions[i].vat_amount.round(2)  
                        total_net_amount += @transactions[i].net_amount.round(2)
                        page_number = u.to_s + " / " + ( @transactions.count / 10 + 1).to_i.to_s 
                        pdf.text_box page_number, :at => [-02, 15], :align => :center, :size => size_text


                    end
                    
                end
                @transactions.each do |transaction|

                end
              end

              pdf.table data, :position => :left, :column_widths => {0 => 175,1 => 100,2 => 60,3 => 60,4 => 60,5 => 85}


              pdf.text ' '
              pdf.text ' '
              pdf.text ' '
              pdf.table [['Total Amount excl VAT ', total_net_amount.round(2) ], ['Total VAT', total_vat.round(2) ]]  
              pdf.text ' '
              pdf.text ' '
              pdf.table [['Amount Due (EUR)', total_amount.round(2)]]
              pdf.text_box footer_line_1, :at => [-02, 60], :size => size_text, :align => :center
              pdf.text_box footer_line_2, :at => [-02, 45], :size => size_text - 2, :align => :center
              pdf.text_box footer_line_3, :at => [-02, 30], :size => size_text - 2, :align => :center

              send_data pdf.render,
                filename: "export.pdf",
                type: 'application/pdf',
                disposition: 'inline'
            end
          end

    end


    # French

    def new_french
        @invoice = Invoice.new
        @company = current_user.company
        @entities = current_user.company.entities
        @customers = Customer.where(company_id: current_user.company)

    end

    def create_french
        @entity = Entity.find(params[:entity])
        @side = TaxCodeOperationSide.find(params[:side])
        @customer = Customer.find(params[:customer])
        @european_countries = Country.where(is_eu: 1).ids
        
        # Seting up the location based on where the customer is located
        @operation_location = Country.location_is_the_same(@entity.country, @customer.country, @european_countries)

        @invoice = Invoice.new(invoice_date: params[:invoice][:invoice_date], invoice_name: params[:invoice][:invoice_name], payment_date: params[:invoice][:payment_date], invoice_number: params[:invoice][:invoice_number], customer_id: @customer.id, entity_id: @entity.id, tax_code_operation_side_id: @side.id, tax_code_operation_location_id: @operation_location.id )

        i = 0
        # if you don't have a new transaction, don't need to do an update
        if !params[:comment].nil?
            transactions.each do |key, value| 
                @item = Item.find(params[:item][key].to_i)
                i += 1
                @return = Return.where(["begin_date <= ? and end_date >= ? and entity_id = ? and country_id = ?",   params[:invoice_date],  params[:invoice_date], @entity.id, 2])[0]
                # If return doesn't exist, need to create it
                if @return.nil?
                    
                    last_day_month = Time.days_in_month(params[:invoice_date][5..6].to_i, params[:invoice_date][0..3].to_i) 
                    from_date = Date.parse(params[:invoice_date][0..7] + "01")
                    to_date = Date.parse(params[:invoice_date][0..7] + last_day_month.to_s)
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
                    quantity = params[:quantity][key].to_f
                    net_amount = quantity * @item.net_amount
                    vat_amount = quantity * @item.vat_amount
                    total_amount = vat_amount + net_amount

                    # will have to multiply quantity with what is specified
                    @transaction = Transaction.new(vat_amount: vat_amount, net_amount: net_amount ,  comment: params[:comment][key], invoice_id: @invoice.id, item_id: @item.id, return_id: @return.id, :quantity => quantity)
                    @transaction.save!
                end
            end
        else
            @invoice.save!  
        end
        # A transaction is linked to an invoice, so need to first create the invoice
        path = '/entreprises/' + @company.id.to_s + '/factures/' + @invoice.id.to_s 
        redirect_to path

    end

    def index_french
        @user = current_user
        @user_accesses = UserAccessCompany.where(user_id: @user.id)
        @entity_ids = []
        @user_accesses.each do |user_access|

            @entity_ids += user_access.company.entity_ids
        end
        @entities = Entity.where(id: @entity_ids)
        @invoices = Invoice.get_all_invoices_with_filter(params_query, @user)

    end

    def show_french
        @invoice = Invoice.find(params[:id])
        @transactions = @invoice.transactions
        @cloudinary_photos = @invoice.cloudinary_photos
    end

    def add_transaction_french
        @invoice = Invoice.find(params[:invoice_id])
        @transactions = @invoice.transactions
        @company = Company.find(params[:company_id])
        @entity = @invoice.entity
        @entity_tax_codes = EntityTaxCode.where(entity_id: @entity.id)
        @items = @entity.items
        @customers = Customer.where(company_id: @company.id)
        @rates = TaxCodeOperationRate.all

    end

    def render_add_item_french
        test = request.original_url
        testo = test.split("#")[1]
        @invoice = Invoice.find(params[:invoice_id])
        @entity = @invoice.entity
        @entity_tax_codes = EntityTaxCode.where(entity_id: @entity.id)
        @items = @entity.items
        html_string = render_to_string(partial: "add_item_french.html.erb", locals: {entity_tax_codes: @entity_tax_codes, items: @items})
        render json: {html_string: html_string}
    end

    def save_transaction_french
        @company = Company.find(params[:company_id])
 
        @invoice = Invoice.find(params[:invoice_id]) 

        @item = Item.find(params[:item])
        @rate = @item.tax_code_operation_rate
        @entity = @invoice.entity   
        @country = Country.find(@entity.country.id)

        @return = Return.where(["begin_date <= ? and end_date >= ? and entity_id = ? and country_id = ?",   @invoice.invoice_date,  @invoice.invoice_date, @item.entity.id, @country.id])[0]

        @periodicity = @entity.periodicity
        @project_type = ProjectType.where(name: "VAT")[0]
        
        # if you don't have a return, you'll need to create it
        if @return.nil?

            @set_up_dates_return = Invoice.extract_dates_invoice(@periodicity, @invoice)
            last_day_month = @set_up_dates_return[0]
            from_date = @set_up_dates_return[1]
            to_date = @set_up_dates_return[2]
            @due_date = DueDate.where(periodicity_id: @periodicity.id, project_type_id: @project_type.id, country_id: @country.id, begin_date: from_date, end_date: to_date )[0]
            @return = Return.new(begin_date: from_date, end_date: to_date ,  periodicity_id: @periodicity.id, country_id: @entity.country.id, entity_id: @entity.id, due_date_id: @due_date.id, project_type_id: @project_type.id)

                                
            @return.save!
            # Can only put the box an amount if it is indeed created to get the id
            # will create the boxnames for the return based on the periodicity_to_project_type
            Box.create_box_names_for_return(@periodicity, @project_type, @country, @return)


        end

        rate = TaxCodeOperationRate.find(params[:rate])
        country_rate = CountryRate.where(country_id: @country.id, tax_code_operation_rate_id: rate.id)[0]

        
        # if credit note, you'll need to take the amount into account
        if @invoice.document_type.id == 2
            # Based on the Item selected & the quantity specified, extract amounts
            amounts = Item.extract_amounts_credit_note(params[:quantity].to_i, params[:price].to_f, country_rate)

            Transaction.create_from_invoice_credit_note(@return, @item, @entity, amounts, params[:comment], @invoice, @periodicity, @project_type, rate)
        else
            # Based on the Item selected & the quantity specified, extract amounts
            amounts = Item.extract_amounts(params[:quantity].to_i, @item, country_rate)

            # Here we will create the transaction & update the corresponding boxes from the return
            Transaction.create_from_invoice(@return, @item, @entity, amounts, params[:comment], @invoice, @periodicity, @project_type, rate)
        end

        path = '/entreprises/' + @company.id.to_s + '/factures/' + @invoice.id.to_s 
        redirect_to path
    end

    def edit_french
        @invoice = Invoice.find(params[:id])
        @transactions = @invoice.transactions
        @company = Company.find(params[:company_id])
        @entities = @company.entities
        @customers = Customer.where(entity_id: @entities)
        
    end

    def update_french
        @company = Company.find(params[:company_id])
        @customer = Customer.find(params_update_french[:customer].to_i)
        @invoice = Invoice.find(params[:invoice_id])
        @invoice.update(:invoice_date => params_update_french[:invoice_date], :payment_date => params_update_french[:payment_date], :invoice_number => params_update_french[:invoice_number], :invoice_name => params_update_french[:invoice_name], :customer_id => params_update_french[:customer].to_i)
        path = '/entreprises/' + @company.id.to_s + '/factures/' + @invoice.id.to_s 
        redirect_to path
    end

    def paid_french
        @company = Company.find(params[:company_id])
        @invoice = Invoice.find(params[:id])

        if @invoice.is_paid == true
            @invoice.update(:is_paid => false)
        else
            @invoice.update(:is_paid => true)
        end
        path = '/entreprises/' + @company.id.to_s + '/factures' 
        redirect_to path
    end

    def add_photo_french
        @invoice = Invoice.find(params[:invoice_id])
        @company = Company.find(params[:company_id])
        # It will go to save when click in the form to save

    end

    def delete_invoice_french
        @company = Company.find(params[:company_id])
        @invoice = Invoice.find(params[:invoice_id])
        @transactions = @invoice.transactions
        # if you have transaction, you cannot remove the invoice
        if !@transactions.nil?
            redirect_to '/entreprises/' + @company.id.to_s + '/factures'
            
        else
            @transactions.each do |transaction|
                amounts = Item.extract_amounts(transaction.quantity, transaction.item)
                Transaction.remove_and_take_out_amounts(transaction, amounts)
            end    
            @invoice.destroy
            redirect_to company_invoices_path(@company)
    
        end

    end

    def generate_french_pdf
        @invoice = Invoice.find(params[:invoice_id])
        @transactions = @invoice.transactions
        size_text = 12
        respond_to do |format|
            # some other formats like: format.html { render :show }
      
            format.pdf do
              pdf = Prawn::Document.new
              pdf.text 'Facture', :align => :right, :size => 32
              pdf.text ''
              # Entity Information
              pdf.text @invoice.entity.name, :align => :right, :size => size_text, :style => :bold
              pdf.text @invoice.entity.address, :align => :right, :size => size_text
              pdf.text @invoice.entity.city + ', ' + @invoice.entity.postal_code, :align => :right, :size => size_text 
              pdf.text @invoice.entity.phone_number, :align => :right, :size => size_text 
              country_entity = LanguageCountry.where( language_id: current_user.language.id, country_id: @invoice.entity.country.id)[0]
              pdf.text country_entity.name, :align => :right, :size => size_text 
              pdf.text ' '
              pdf.stroke_horizontal_rule
              pdf.text ' '

              pdf.text 'Client:', :align => :left, :size => size_text
              # Customer Information
              pdf.draw_text @invoice.customer.name, :at => [0, 562], :size => size_text, :style => :bold
              pdf.draw_text @invoice.customer.vat_number, :at => [0, 547], :size => size_text
              pdf.draw_text @invoice.customer.street, :at => [0, 532], :size => size_text
              pdf.draw_text @invoice.customer.city + ', ' + @invoice.customer.post_code, :at => [0, 517], :size => size_text
              country_customer = LanguageCountry.where( language_id: current_user.language.id, country_id: @invoice.customer.country.id)[0]
              pdf.draw_text country_customer.name, :at => [0, 502], :size => size_text
              # Invoice Information
              pdf.draw_text 'Nom de la Facture:', :at => [300, 577], :size => size_text, :style => :bold
              pdf.draw_text @invoice.invoice_name, :at => [430, 577], :size => size_text
              pdf.draw_text 'Numéro de la Facture:', :at => [300, 557], :size => size_text, :style => :bold
              pdf.draw_text @invoice.invoice_number, :at => [430, 557], :size => size_text
              pdf.draw_text 'Date de la Facture:', :at => [300, 537], :size => size_text, :style => :bold
              pdf.draw_text @invoice.invoice_date, :at => [430, 537], :size => size_text
              pdf.draw_text 'Date de Paiement:', :at => [300, 517], :size => size_text, :style => :bold
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
              if !@invoice.entity.website.nil?
                footer_line_2 = 'Email:  ' +   @invoice.entity.email + '   Site Web:  ' + @invoice.entity.website + '   Numéro de TVA:  ' + @invoice.entity.vat_number
              else
                footer_line_2 = 'Email:  ' +   @invoice.entity.email + '   Numéro de TVA:  ' + @invoice.entity.vat_number

              end
              footer_line_3 = 'IBAN:  ' + @invoice.entity.iban + '   BIC:  ' + @invoice.entity.bic

              i = 0
              # pagingation
              u = 1
              data = [["Articles", "Commentaires", "Quantité", "Montant Hors TVA / Unité", "Montant TVA / Unit", "Prix Total"]]
              size_table = 10
              if @transactions.count < 10
                @transactions.each do |transaction|
                    total_amount += transaction.net_amount + transaction.vat_amount
                    data += [[transaction.item.item_name, transaction.comment, transaction.quantity, transaction.net_amount, transaction.vat_amount, total_amount]]
                    total_amount += transaction.net_amount + transaction.vat_amount
                    total_vat += transaction.vat_amount 
                end
              else
                while i < @transactions.count - 1
                    i +=1
                    # For every 10 transactions, you'll create a new page
                    if ( i % 10 ) == 0
                        page_number = u.to_s + " / " + ( @transactions.count / 10 + 1).to_i.to_s 
                        pdf.table data, :position => :left, :column_widths => {0 => 115,1 => 150,2 => 60,3 => 70,4 => 60,5 => 85}
                        
                        pdf.text_box footer_line_1, :at => [-02, 60], :size => size_text, :align => :center
                        pdf.text_box footer_line_2, :at => [-02, 45], :size => size_text, :align => :center
                        pdf.text_box footer_line_3, :at => [-02, 30], :align => :center, :size => size_text
                        pdf.text_box page_number, :at => [-02, 15], :align => :center, :size => size_text

                        pdf.start_new_page
                        data = [["Items", "Comments", "Quantity", "Net Amount / Unit", "VAT Amount / Unit", "Total Price"]]
                        u += 1
                    else
                        total_amount += @transactions[i].net_amount + @transactions[i].vat_amount
                        data += [[@transactions[i].item.item_name, @transactions[i].comment, @transactions[i].quantity, @transactions[i].net_amount, @transactions[i].vat_amount, total_amount]]
                        total_vat += @transactions[i].vat_amount 
                        page_number = u.to_s + " / " + ( @transactions.count / 10 + 1).to_i.to_s 
                        pdf.text_box page_number, :at => [-02, 15], :align => :center, :size => size_text


                    end
                    
                end
                @transactions.each do |transaction|

                end
              end

              pdf.table data, :position => :left, :column_widths => {0 => 115,1 => 150,2 => 60,3 => 70,4 => 60,5 => 85}


              pdf.text ' '
              pdf.text ' '
              pdf.text ' '
              pdf.table [['Montant Total', total_amount], ['Total TVA', total_vat]]  

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

    def params_update_french
        params.permit(:invoice_date, :payment_date, :invoice_number, :invoice_name, :customer)
    end

    def params_query
        params.permit(:query_name, :from_date, :to_date)
    end

   

end