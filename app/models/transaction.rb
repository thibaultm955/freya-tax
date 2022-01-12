class Transaction < ApplicationRecord
    belongs_to :return
    belongs_to :item
    belongs_to :invoice
    belongs_to :tax_code_operation_rate

    def self.create_from_invoice(return_specified, item, entity, amounts, comments, invoice, periodicity_to_project_type, rate)

        quantity = amounts[0]
        net_amount = amounts[1]
        vat_amount = amounts[2]

        # will have to multiply quantity with what is specified
        transaction = Transaction.new(vat_amount: vat_amount, net_amount: net_amount, comment: comments, invoice_id: invoice.id, return_id: return_specified.id, :item_id => item.id, :quantity => quantity, tax_code_operation_rate_id: rate.id)

        country_tax_code = CountryTaxCode.where(country_id: entity.country.id, tax_code_operation_location_id: transaction.invoice.tax_code_operation_location.id, tax_code_operation_side_id: transaction.invoice.tax_code_operation_side.id, tax_code_operation_rate_id: transaction.item.tax_code_operation_rate.id, tax_code_operation_type_id: transaction.item.tax_code_operation_type.id)[0]

        entity_tax_code = EntityTaxCode.where(entity_id: entity.id, country_tax_code_id: country_tax_code.id)

        # if you don't have a tax code, you'll need to create one
        if entity_tax_code.empty?
            name_tax_code = transaction.invoice.tax_code_operation_location.name + " | " + transaction.invoice.tax_code_operation_side.name + " | " + transaction.item.tax_code_operation_type.name + " | " + transaction.item.tax_code_operation_rate.name
            entity_tax_code = EntityTaxCode.new(name: name_tax_code, entity_id: entity.id, country_tax_code_id: country_tax_code.id)
            entity_tax_code.save

        end

        entity_tax_code = EntityTaxCode.where(entity_id: entity.id, country_tax_code_id: country_tax_code.id)[0]

        box_informations = BoxInformation.where(tax_code_operation_location_id: entity_tax_code.country_tax_code.tax_code_operation_location_id, tax_code_operation_rate_id: entity_tax_code.country_tax_code.tax_code_operation_rate_id, tax_code_operation_side_id: entity_tax_code.country_tax_code.tax_code_operation_side_id, tax_code_operation_type_id: entity_tax_code.country_tax_code.tax_code_operation_type_id )

        box_informations.each do |box_information|

            # Check if box_name is the one from this periodicity
            if box_information.box_name.periodicity_to_project_type_id == periodicity_to_project_type.id
                return_box = ReturnBox.where(box_name_id: box_information.box_name_id, return: return_specified.id)[0]
                amount = box_information.amount.name
                if amount == "Reporting Currency Taxable Basis"
                    updated_amount = return_box.amount + net_amount
                    return_box = return_box.update(amount: updated_amount)
                elsif amount == "Reporting Currency VAT Amount"
                    updated_amount = return_box.amount + vat_amount
                    return_box = return_box.update(amount: updated_amount)
                elsif amount == "Reporting Currency Gross Amount"
                    updated_amount = return_box.amount + net_amount + vat_amount
                    return_box = return_box.update(amount: updated_amount)
                end
            else

            end
        end

        transaction.save!
    end


    def self.remove_and_take_out_amounts(transaction, amounts)

        quantity = amounts[0]
        net_amount = amounts[1]
        vat_amount = amounts[2]

        country_tax_code = CountryTaxCode.where(country_id: transaction.invoice.entity.country.id, tax_code_operation_location_id: transaction.invoice.tax_code_operation_location.id, tax_code_operation_side_id: transaction.invoice.tax_code_operation_side.id, tax_code_operation_rate_id: transaction.item.tax_code_operation_rate.id, tax_code_operation_type_id: transaction.item.tax_code_operation_type.id)[0]

        entity_tax_code = EntityTaxCode.where(entity_id: transaction.invoice.entity.id, country_tax_code_id: country_tax_code.id)[0]

        periodicity_to_project_type = PeriodicityToProjectType.where(project_type_id: 1, periodicity_id: transaction.invoice.entity.periodicity.id, country_id: transaction.invoice.entity.country.id)[0]

        box_informations = BoxInformation.where(tax_code_operation_location_id: entity_tax_code.country_tax_code.tax_code_operation_location_id, tax_code_operation_rate_id: entity_tax_code.country_tax_code.tax_code_operation_rate_id, tax_code_operation_side_id: entity_tax_code.country_tax_code.tax_code_operation_side_id, tax_code_operation_type_id: entity_tax_code.country_tax_code.tax_code_operation_type_id )

        box_informations.each do |box_information|
            # Check if box_name is the one from this periodicity
            if box_information.box_name.periodicity_to_project_type_id == periodicity_to_project_type.id
                return_box = ReturnBox.where(box_name_id: box_information.box_name_id, return: transaction.return.id)[0]
                amount = box_information.amount.name
                if amount == "Reporting Currency Taxable Basis"
                    updated_amount = return_box.amount - net_amount
                    return_box = return_box.update(amount: updated_amount)
                elsif amount == "Reporting Currency VAT Amount"
                    updated_amount = return_box.amount - vat_amount
                    return_box = return_box.update(amount: updated_amount)
                elsif amount == "Reporting Currency Gross Amount"
                    updated_amount = return_box.amount - net_amount - vat_amount
                    return_box = return_box.update(amount: updated_amount)
                end
            else

            end
        end

        transaction.destroy
    end
end
