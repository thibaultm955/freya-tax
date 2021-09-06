class ItemsController < ApplicationController
    def new
        @item = Item.new
        @company = current_user.company
        @entities = @company.entities
    end

    def create
        @entity = Entity.find(params[:entity])
        @item = Item.new(item_name: params_items[:item_name], item_description: params_items[:item_description], price: params_items[:price], entity_id: @entity.id)
        if @item.save!
            redirect_to new_company_invoice_path(current_user.company.id)
        else
            render :new
        end
    end

    def index
        @entities = Entity.where(company_id: current_user.company.id)
        @items = Item.where(entity_id: @entities)

    end

    def edit
        @item = Item.find(params[:id])
        @entities = Entity.where(company_id: current_user.company.id)

    end

    def update

        hjkl
    end

    private

    def params_items
        params.require(:item).permit(:item_name, :item_description, :price)
    end

end  