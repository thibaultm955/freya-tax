class Invoice < ApplicationRecord
    has_many :transactions
    accepts_nested_attributes_for  :transactions
    belongs_to :entity
    belongs_to :customer
    belongs_to :document_type
    belongs_to :tax_code_operation_side
    belongs_to :tax_code_operation_location
    has_many :cloudinary_photos
=begin
    def author(new_name, invoice)
        invoice.update(invoice_name: new_name)
        return true
    end
=end


    # Based on the params chose in the Index - Invoice, you'll filter or not
    def self.get_all_invoices_with_filter(params_query, user)

        user_accesses = UserAccessCompany.where(user_id: user.id)
        entity_ids = []
        user_accesses.each do |user_access|

            entity_ids += user_access.company.entity_ids
        end

        if params_query[:query_name].present? || params_query[:from_date].present? || params_query[:to_date].present?
            sql_query = "invoice_name ILIKE :query"
            if params_query[:query_name].present? & params_query[:from_date].present? & params_query[:to_date].present?
                invoices = Invoice.order("invoice_date asc").where(sql_query, query: "%#{params_query[:query_name]}%").where(["invoice_date >= ? and invoice_date <= ?",   params_query[:from_date],  params_query[:to_date]])
            elsif params_query[:query_name].present? & params_query[:from_date].present? 
                invoices = Invoice.order("invoice_date asc").where(sql_query, query: "%#{params_query[:query_name]}%").where(["invoice_date >= ?",   params_query[:from_date]])
            elsif params_query[:from_date].present? & params_query[:to_date].present?
                @invoices = Invoice.order("invoice_date asc").where(["invoice_date >= ? and invoice_date <= ?",   params_query[:from_date],  params_query[:to_date]])
            elsif params_query[:query_name].present? 
                invoices = Invoice.order("invoice_date asc").where(sql_query, query: "%#{params_query[:query_name]}%")
            elsif params_query[:from_date].present? 
                invoices = Invoice.order("invoice_date asc").where(["invoice_date >= ?",   params_query[:from_date]])
            elsif params_query[:to_date].present?
                invoices = Invoice.order("invoice_date asc").where(["invoice_date <= ?",   params_query[:to_date]])
            end
    
        else
            invoices = Invoice.order("invoice_date asc").where(entity_id: entity_ids)
    
        end
        
        return invoices
    end 


    def self.extract_dates_invoice(periodicity, invoice)

        if periodicity.name == "Monthly"

            from_date = Date.parse(invoice.invoice_date.to_s[0..6] + "-01")
            last_day_month = Time.days_in_month(invoice.invoice_date.to_s[5..6].to_i, invoice.invoice_date.to_s[2..3].to_i)
            to_date = Date.parse(invoice.invoice_date.to_s[0..7] + last_day_month.to_s)
        elsif periodicity.name == "Quarterly"
            if invoice.invoice_date.month < 4
                last_day_month = Time.days_in_month(3, invoice.invoice_date.to_s[2..3].to_i)
                from_date = Date.parse(invoice.invoice_date.to_s[0..3] + "-01" + "-01")
                to_date = Date.parse(invoice.invoice_date.to_s[0..3] + "-03-" + last_day_month.to_s)
            elsif invoice.invoice_date.month < 7
                last_day_month = Time.days_in_month(6, invoice.invoice_date.to_s[2..3].to_i)
                from_date = Date.parse(invoice.invoice_date.to_s[0..3] + "-04" + "-01")
                to_date = Date.parse(invoice.invoice_date.to_s[0..3] + "-06-" + last_day_month.to_s)
            elsif invoice.invoice_date.month < 10
                last_day_month = Time.days_in_month(9, invoice.invoice_date.to_s[2..3].to_i)
                from_date = Date.parse(invoice.invoice_date.to_s[0..3] + "-07" + "-01")
                to_date = Date.parse(invoice.invoice_date.to_s[0..3] + "-09-" + last_day_month.to_s)
            else
                last_day_month = Time.days_in_month(12, invoice.invoice_date.to_s[2..3].to_i)
                from_date = Date.parse(invoice.invoice_date.to_s[0..3] + "-10" + "-01")
                to_date = Date.parse(invoice.invoice_date.to_s[0..3] + "-12-" + last_day_month.to_s)
            end
            

        elsif periodicity.name == "Yearly"
            from_date = Date.parse(invoice.invoice_date.to_s[0..3] + "-01" + "-01")
            last_day_month = Time.days_in_month(invoice.invoice_date.to_s[5..6].to_i, invoice.invoice_date.to_s[2..3].to_i)
            to_date = Date.parse(invoice.invoice_date.to_s[0..7] + last_day_month.to_s)
        else
            # problem
        end
        return [last_day_month, from_date, to_date]
    end

end
