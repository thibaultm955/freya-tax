class ItemsController < ApplicationController
    def new
        @item = Item.new
        @user = current_user
        @user_accesses = UserAccessCompany.where(user_id: @user.id)
        @entity_ids = []
        @user_accesses.each do |user_access|

            @entity_ids += user_access.company.entity_ids
        end
        @entities = Entity.where(id: @entity_ids)
        @tax_code_rates = TaxCodeOperationRate.all
        @types = TaxCodeOperationType.all
    end

    def create
        @entity = Entity.find(params_items_edit[:entity_id])
        @tax_code_rate = TaxCodeOperationRate.find(params_items_edit[:rate_id])
        @rate = CountryRate.where(country_id: @entity.country.id, tax_code_operation_rate_id: @tax_code_rate.id)[0]
        vat_amount = params[:net_amount].to_f * (@rate.rate / 100)
            # make sure we only have 2 number
        vat_amount = vat_amount.truncate(2)
        @item = Item.new(:item_name => params_items[:item_name], :item_description => params_items[:item_description], :net_amount => params_items[:net_amount].to_f, :entity_id => params_items_edit[:entity_id], :tax_code_operation_rate_id => params_items_edit[:rate_id], :vat_amount => vat_amount, tax_code_operation_type_id: params[:type])
        if @item.save!
            redirect_to items_path
        else
            render :new
        end
    end

    def index
        if current_user.nil?
            redirect_to root_path
        else
            @user = current_user
            @user_accesses = UserAccessCompany.where(user_id: @user.id)
            @entity_ids = []
            @user_accesses.each do |user_access|

                @entity_ids += user_access.company.entity_ids
            end
            @items = Item.order("item_name asc").where(entity_id: @entity_ids, is_hidden: [false, nil])
        end
    end

    def edit
        @company = Company.find(params[:company_id])
        @item = Item.find(params[:id])
        @entities = Entity.where(company_id: @company.id)
        @tax_code_rates = TaxCodeOperationRate.all
        @types = TaxCodeOperationType.all
    end

    def update_item
        @company = Company.find(params[:company_id])
        @item = Item.find(params_items_edit[:item_id])
        @entity = Entity.find(params_items_edit[:entity_id])
        @tax_code_rate = TaxCodeOperationRate.find(params_items_edit[:rate_id])
        @rate = CountryRate.where(country_id: @entity.country.id, tax_code_operation_rate_id: @tax_code_rate.id)[0]
        vat_amount = params[:net_amount].to_f * (@rate.rate / 100)
            # make sure we only have 2 number
        vat_amount = vat_amount.truncate(2)

        @item.update(:item_name => params_items_edit[:item_name], :item_description => params_items_edit[:item_description], :net_amount => params_items_edit[:net_amount].to_f, :entity_id => params_items_edit[:entity_id], :tax_code_operation_rate_id => params_items_edit[:rate_id], :vat_amount => vat_amount, tax_code_operation_type_id: params[:type])

        redirect_to company_items_path(@company)

    end

    # French
    def index_french
        if current_user.nil?
            redirect_to root_path
        else
            @user = current_user
            @user_accesses = UserAccessCompany.where(user_id: @user.id)
            @entity_ids = []
            @user_accesses.each do |user_access|

                @entity_ids += user_access.company.entity_ids
            end
            @items = Item.order("item_name asc").where(entity_id: @entity_ids, is_hidden: [false, nil])
        end
    end

    def new_french
        @item = Item.new
        @user = current_user
        @user_accesses = UserAccessCompany.where(user_id: @user.id)
        @entity_ids = []
        @user_accesses.each do |user_access|

            @entity_ids += user_access.company.entity_ids
        end
        @entities = Entity.where(id: @entity_ids)
        @tax_code_rates = TaxCodeOperationRate.all
        @types = TaxCodeOperationType.all

    end

    def create_french
        @entity = Entity.find(params_french[:entity_id])
        @tax_code_rate = TaxCodeOperationRate.find(params_french[:rate_id])
        @rate = CountryRate.where(country_id: @entity.country.id, tax_code_operation_rate_id: @tax_code_rate.id)[0]
        vat_amount = params_french[:net_amount].to_f * (@rate.rate / 100)
            # make sure we only have 2 number
        vat_amount = vat_amount.truncate(2)
        @item = Item.new(:item_name => params_french[:item_name], :item_description => params_french[:item_description], :net_amount => params_french[:net_amount].to_f, :entity_id => params_french[:entity_id], :tax_code_operation_rate_id => params_french[:rate_id].to_i, :vat_amount => vat_amount, tax_code_operation_type_id: params_french[:type])
        if @item.save!
            redirect_to '/entreprises/' + @entity.company.id + '/articles'
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
        params.permit(:item_name, :item_description, :net_amount, :entity_id, :rate_id, :company_id, :type)
    end

end  