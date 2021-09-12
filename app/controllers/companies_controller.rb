class CompaniesController < ApplicationController
   
    def new
        @company = Company.new
        @countries = Country.order("name asc").all
    end

    def create
        @company = Company.new(name: params_company[:name])
        @country = Country.find(params_company[:country])
        @user = current_user
        @company.country = @country
        @assignment = Assignment.new(function: "Admin")
        @assignment.user = @user
        if @company.save 
            @assignment.company = @company
            @assignment.save!
            redirect_to company_path(@company.id)
        else
            render :new
        end
    end

    def show
        @company = current_user.assignment.company
        @entities = @company.entities.order('name ASC')
    end

    def render_select_periodicity
       
        @project_type = ProjectType.find(params[:countries_project_id])
        
        @periodicity_to_project_type = PeriodicityToProjectType.where(project_type_id: @project_type.id)
        @periodicities = []
        @periodicity_to_project_type.each{|project| @periodicities << project.periodicity.id}
        @all_periodicities = Periodicity.where(id: @periodicity_to_project_type)
        html_string = render_to_string(partial: "select_periodicities.html.erb", locals: { periodicities: @all_periodicities})
        render json: {html_string: html_string}

    end


    # French
    def show_french
        @company = current_user.assignment.company
        @entities = @company.entities.order('name ASC')
    end


    private

    def params_company
        params.require(:company).permit(:name, :country)
    end
end