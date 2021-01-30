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
        @entity = Entity.find(params[:entity])
        last_day_month = Time.days_in_month(params[:return][:end_date][0..1].to_i, params[:return][:end_date][3..4].to_i)
        from_date = Date.parse(params[:return][:begin_date][3..4] + "." +params[:return][:begin_date][0..1] + "." + "01")
        to_date = Date.parse(params[:return][:end_date][3..4] + "." +params[:return][:end_date][0..1] + "." + last_day_month.to_s)
        @declaration = Return.new(begin_date: first_date, end_date: to_date, type_of_project: params_declaration[:type_of_project])
        @declaration.entity = @entity
        @due_date = DueDate.where(start_date: (params_declaration[:start_date][0..6] + "-01"), end_date: (params_declaration[:end_date][0..6] + "-"+last_day_month.to_s), type_of_project: params_declaration[:type_of_project])[0]
        @declaration.due_date = @due_date
        hnjhjkl
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
        params.require(:return).permit(:box_name, :begin_date, :end_date, :type_of_project)
    end
end