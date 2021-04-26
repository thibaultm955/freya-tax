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
        from_date = Date.parse(params[:return][:begin_date][3..4] + "." + params[:return][:begin_date][0..1] + "." + "01")
        to_date = Date.parse(params[:return][:end_date][3..4] + "." + params[:return][:end_date][0..1] + "." + last_day_month.to_s)
        
        @periodicity_to_project_type = PeriodicityToProjectType.where(project_type_id: params[:project][:project_id], periodicity_id: params[:periodicity][:periodicity_id])[0]

        @return = Return.new(begin_date: from_date, end_date: to_date ,  periodicity_to_project_type_id: @periodicity_to_project_type.id, country_id: params[:countries][:country_id], entity_id: params[:entity], due_date_id: @periodicity_to_project_type.due_date.id)
        @return_boxes = []
    
        #language_id is hardcoded as not yet defined
        box_names = BoxName.where(periodicity_to_project_type_id: @periodicity_to_project_type.id, language_id: 2)
        
        
=begin 
        @due_date = DueDate.where(start_date: (params_declaration[:start_date][0..6] + "-01"), end_date: (params_declaration[:end_date][0..6] + "-"+last_day_month.to_s), type_of_project: params_declaration[:type_of_project])[0]
        @declaration.due_date = @due_date 
=end

        if @return.save!
            # Can only put the box an amount if it is indeed created to get the id
            box_names.each do |box_name|
                return_box = ReturnBox.new(return_id: @return.id, box_name_id: box_name.id, amount: 0)
                return_box.save!
            end
            
            redirect_to company_path(@entity.company)
        else
            render :new
        end
    end

    def destroy
        @return = Return.find(params[:id])
        @return.destroy
        redirect_to company_returns_path(params[:company_id])
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
        @return = Return.find(params[:id])
        @return_boxes = ReturnBox.where(return_id: @return.id)
        @entity = @return.entity
        @transactions = @return.transactions
    end

    
    private
    
    def params_declaration
        params.require(:return).permit(:box_name, :begin_date, :end_date, :type_of_project)
    end
end