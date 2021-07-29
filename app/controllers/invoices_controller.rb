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
                @transaction = Transaction.new(invoice_number: i, invoice_date: params[:invoice][:invoice_date], vat_amount: params[:vat_amount][key].to_i, net_amount: params[:net_amount][key].to_i, total_amount: (params[:vat_amount][key].to_i + params[:net_amount][key].to_i), comment: params[:comment][key], invoice_id: @invoice.id, entity_tax_code_id: @entity_tax_codes.id, return_id: @return.id)
                @transaction.save!
            end
        end
        # A transaction is linked to an invoice, so need to first create the invoice

        redirect_to company_invoices_path(current_user.company)

        
    end

    def render_add_item
        test = request.original_url
        testo = test.split("#")[1]
        @entity_tax_codes = EntityTaxCode.where(entity_id: params[:entity_id])
        html_string = render_to_string(partial: "add_item.html.erb", locals: {entity_tax_codes: @entity_tax_codes})
        render json: {html_string: html_string}
    end

    def show
        @invoice = Invoice.find(params[:invoice_id])
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
              pdf.draw_text 'Invoice Number:', :at => [340, 577], :size => size_text, :style => :bold
              pdf.draw_text @invoice.invoice_number, :at => [450, 577], :size => size_text
              pdf.draw_text 'Invoice Date:', :at => [340, 547], :size => size_text, :style => :bold
              pdf.draw_text @invoice.invoice_date, :at => [450, 547], :size => size_text
              pdf.draw_text 'Payment Date:', :at => [340, 517], :size => size_text, :style => :bold
              pdf.draw_text @invoice.payment_date, :at => [450, 517], :size => size_text

              # need to do AMount Due
              pdf.text ' '
              pdf.text ' '
              pdf.text ' '
              pdf.text ' '
              pdf.text ' '
              pdf.text ' '
              pdf.text ' '
              pdf.text ' '
              pdf.table([
                ["Base Price", "$275,99"],
                ["Canary Cozy Sound Isolation Blankey", "$11.00"]
              ])

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