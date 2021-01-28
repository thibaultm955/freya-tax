class ReturnsController < ApplicationController
    def index
        @company = current_user.company
        @entities = @company.entities
        @returns = Return.where(entity_id: @entities.ids).order("begin_date asc")[0..9]
    end

    def new
        @return = Return.new
        @company = Company.find(current_user.company.id)
        @entities = Company.find(current_user.company.id).entities.order("name asc")
        @jurisdictions = []
        @entities_name = []
        @entities.each do |entity|
            @entities_name << entity.name + " | " + entity.country.name
        end
    end

    def create
        @entity = Entity.where(name: params_declaration[:box_name].split("|")[0].strip, company_id: current_user.company_id)[0]
        last_day_month = Time.days_in_month(params_declaration[:end_date][5..6].to_i, params_declaration[:end_date][0..3].to_i)
        @declaration = Declaration.new(start_date: (params_declaration[:start_date][0..6] + "-01"), end_date: (params_declaration[:end_date][0..6] + "-"+last_day_month.to_s), type_of_project: params_declaration[:type_of_project])
        @declaration.entity = @entity
        @due_date = DueDate.where(start_date: (params_declaration[:start_date][0..6] + "-01"), end_date: (params_declaration[:end_date][0..6] + "-"+last_day_month.to_s), type_of_project: params_declaration[:type_of_project])[0]
        @declaration.due_date = @due_date
        if @declaration.save
            redirect_to company_declarations_path(current_user.company_id)
        else
            render :new
        end
    end

    def destroy
        @declaration = Declaration.find(params[:id])
        @declaration.destroy
        redirect_to company_declarations_path(current_user.company_id)
    end

    def edit
        @company = Company.find(current_user.id)
        @declaration = Declaration.find(params[:id])
        @entity = @declaration.entity
        
    end

    def update
        @declaration = Declaration.find(params[:id])
        last_day_month = Time.days_in_month(params_declaration[:end_date][5..6].to_i, params_declaration[:end_date][0..3].to_i)
        @declaration = @declaration.update(start_date: (params_declaration[:start_date][0..6] + "-01"), end_date: (params_declaration[:end_date][0..6] + "-"+last_day_month.to_s), type_of_project: params_declaration[:type_of_project])
        redirect_to company_declarations_path(current_user.company_id)
    end

    def show
        @declaration = Declaration.find(params[:id])
        @entity = @declaration.entity
        @transactions = @declaration.transactions
    end


    
    private
    
    def params_declaration
        params.require(:return).permit(:box_name, :start_date, :end_date, :type_of_project)
    end
end