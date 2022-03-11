class CompaniesController < ApplicationController
   
    def new
        @company = Company.new
        @countries = Country.order("name asc").all
    end

    def index

        @user = current_user
        @user_accesses = UserAccessCompany.where(user_id: @user.id)
        @companies = []
        @user_accesses.each do |user_access|
            @companies << user_access.company
        end

    end

    def create
        @company = Company.new(name: params_company[:name])
        @country = Country.find(params_company[:country])
        @user = current_user
        @company.country = @country
        # As creator of a company, you'll be admin
        @access = Access.find(1)
        if @company.save 
            @user_access = UserAccessCompany.new(user_id: current_user.id, company_id: @company.id, access_id: @access.id)    
            @user_access.save
            redirect_to "/companies/" + @company.id.to_s
        else
            render :new
        end
    end

    def show
        @company = Company.find(params[:id])
        @entities = @company.entities.order('name ASC')
    end

    def edit
        @company = Company.find(params[:id])
        @countries = Country.order("name asc").all

    end

    def update
        @company = Company.find(params[:id])
        @company.update(name: params[:company][:name], country_id: params[:country])
        
        redirect_to '/companies'
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
        @company = Company.find(params[:id])
        @entities = @company.entities.order('name ASC')
    end

    def new_french
        @company = Company.new
        @countries = Country.order("name asc").all
    end


    private

    def params_company
        params.require(:company).permit(:name, :country)
    end
end