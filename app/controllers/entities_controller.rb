class EntitiesController < ApplicationController

    def new
        @company = Company.find(params[:company_id])
        @entity = Entity.new
        @countries = Country.order("name asc").all
    end

    def create
        @company = Company.find(params[:company_id])
        @entity = Entity.new(name: entity_params[:name], address: entity_params[:address], vat_number: entity_params[:vat_number], postal_code: entity_params[:postal_code], city: entity_params[:city])
        @entity.company = @company
        @country = Country.find(entity_params[:country])
        @entity.country = @country
        if @entity.save
            redirect_to company_path(@company.id)
        else
            render :new
        end
    end

    def edit
        @company = Company.find(params[:company_id])
        @entity = Entity.find(params[:id])
        @countries = Country.order("name asc").all
    end

    def update
        @company = Company.find(params[:company_id])
        @entity = Entity.find(params[:id])
        @entity.update(entity_params)
        redirect_to company_path(@company.id)
    end

    def destroy
        @company = Company.find(current_user.company_id)
        @entity = Entity.find(params[:id])
        redirect_to company_path(@company.id)
    end
    
    def show
        @entity = Entity.find(params[:id])
        @declarations = @entity.returns
    end

    def render_select_entities
        @entity = Entity.find(params[:entity_id])
        @entities = Entity.where(name: @entity.name)
        entity_country = []
        @entities.each {|entity| entity_country << entity.country.id}
        @countries = Country.where(id: entity_country)

        if @countries.count >= 2
            html_string = render_to_string(partial: "select_entities.html.erb", locals: {countries: @countries})
            render json: {html_string: html_string}
        else 
            @type_project = PeriodicityToProjectType.where(country_id: @entity.country)
            @projects_type = []
            @type_project.each{|project| @projects_type << project.project_type.id}
            @projects_type = @projects_type.uniq
            @all_project_type = ProjectType.where(id: @projects_type)
            html_string = render_to_string(partial: "select_entities.html.erb", locals: {countries: @countries, type_project: @all_project_type})
            render json: {html_string: html_string}
        end
        

    end

    

    private

    def entity_params
        params.require(:entity).permit(:name, :address, :postal_code, :city, :vat_number, :country)
    end
end