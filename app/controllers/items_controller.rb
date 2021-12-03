class ItemsController < ApplicationController
    def new
        @item = Item.new
        @company = current_user.company
        @entities = @company.entities
        @tax_code_rates = TaxCodeOperationRate.all
        @types = TaxCodeOperationType.all
    end

    def create
        @entity = Entity.find(params_items_edit[:entity_id])
        @rate = TaxCodeOperationRate.find(params_items_edit[:rate_id])
        vat_amount = params_items[:net_amount].to_f * @rate.rate
        
        # make sure we only have 2 number
        vat_amount = vat_amount.truncate(2)
        @item = Item.new(:item_name => params_items[:item_name], :item_description => params_items[:item_description], :net_amount => params_items[:net_amount].to_f, :entity_id => params_items_edit[:entity_id], :tax_code_operation_rate_id => params_items_edit[:rate_id], :vat_amount => vat_amount, tax_code_operation_type_id: params[:type])
        if @item.save!
            redirect_to company_items_path(current_user.company)
        else
            render :new
        end
    end

    def index
        @entities = Entity.where(company_id: current_user.company.id)
        @items = Item.order("item_name asc").where(entity_id: @entities)
    end

    def edit
        @item = Item.find(params[:id])
        @entities = Entity.where(company_id: current_user.company.id)
        @tax_code_rates = TaxCodeOperationRate.all
        @types = TaxCodeOperationType.all
    end

    def update_item
        @item = Item.find(params_items_edit[:item_id])
        @entity = Entity.find(params_items_edit[:entity_id])
        @rate = TaxCodeOperationRate.find(params_items_edit[:rate_id])
        vat_amount = params_items_edit[:net_amount].to_f * @rate.rate
        
        # make sure we only have 2 number
        vat_amount = vat_amount.truncate(2)

        @item.update(:item_name => params_items_edit[:item_name], :item_description => params_items_edit[:item_description], :net_amount => params_items_edit[:net_amount].to_f, :entity_id => params_items_edit[:entity_id], :tax_code_operation_rate_id => params_items_edit[:rate_id], :vat_amount => vat_amount, tax_code_operation_type_id: params[:type])

        redirect_to company_items_path(current_user.company)

    end

    # French
    def index_french
        @entities = Entity.where(company_id: current_user.company.id)
        @items = Item.order("item_name asc").where(entity_id: @entities)
    end

    def new_french
        @item = Item.new
        @company = current_user.company
        @entities = @company.entities
        @tax_code_rates = TaxCodeOperationRate.all

    end

    def create_french
        @company = current_user.company
        @entity = Entity.find(params_french[:entity_id].to_i)
        @rate = TaxCodeOperationRate.find(params_french[:rate_id])

        vat_amount = params_french[:net_amount].to_f * @rate.rate
        
        # make sure we only have 2 number
        vat_amount = vat_amount.truncate(2)

        @item = Item.new(:item_name => params_french[:item_name], :item_description => params_french[:item_description], :net_amount => params_french[:net_amount].to_f, :entity_id => params_french[:entity_id], :tax_code_operation_rate_id => params_french[:rate_id], :vat_amount => vat_amount)
        path = '/entreprises/' + @company.id.to_s + '/articles'

        if @item.save!
            redirect_to path
        else
            render :new
        end
    end

    def edit_french
        @item = Item.find(params[:item_id])
        @entities = Entity.where(company_id: current_user.company.id)
        @tax_code_rates = TaxCodeOperationRate.all

    end

    def update_french
        @company = current_user.company
        @item = Item.find(params_items_edit[:item_id])
        @entity = Entity.find(params_items_edit[:entity_id])
        @rate = TaxCodeOperationRate.find(params_items_edit[:rate_id])
        vat_amount = params_items_edit[:net_amount].to_f * @rate.rate
        
        # make sure we only have 2 number
        vat_amount = vat_amount.truncate(2)
        @item.update(:item_name => params_items_edit[:item_name], :item_description => params_items_edit[:item_description], :net_amount => params_items_edit[:net_amount].to_f, :entity_id => params_items_edit[:entity_id], :tax_code_operation_rate_id => params_items_edit[:rate_id], :vat_amount => vat_amount)
        path = '/entreprises/' + @company.id.to_s + '/articles'
        redirect_to path
    end

    private

    def params_items
        params.require(:item).permit(:item_name, :item_description, :net_amount)
    end

    def params_items_edit
        params.permit(:item_name, :item_description, :net_amount, :entity_id, :rate_id, :company_id, :item_id)
    end

    def params_french
        params.permit(:item_name, :item_description, :net_amount, :entity_id, :rate_id, :company_id)
    end

end  