class EntitiesController < ApplicationController

    def new
        @company = Company.find(params[:company_id])
        @entity = Entity.new
        @countries = Country.order("name asc").all
        @periodicity = Periodicity.all
    end

    def index
        @company = Company.find(params[:company_id])
        @entities = @company.entities.order('name ASC')

    end

    def create
        @company = Company.find(params[:company_id])
        @entity = Entity.new(name: entity_params[:name], address: entity_params[:address], vat_number: entity_params[:vat_number], postal_code: entity_params[:postal_code], city: entity_params[:city], phone_number: entity_params[:phone_number], email: entity_params[:email], website: entity_params[:website], iban: entity_params[:iban], bic: entity_params[:bic], periodicity_id: params[:periodicity])
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
        @periodicity = Periodicity.all
    end

    def update
        @company = Company.find(params[:company_id])
        @entity = Entity.find(params[:id])
        @entity.update(name: entity_params[:name], address: entity_params[:address], vat_number: entity_params[:vat_number], postal_code: entity_params[:postal_code], city: entity_params[:city], phone_number: entity_params[:phone_number], email: entity_params[:email], website: entity_params[:website], iban: entity_params[:iban], bic: entity_params[:bic], periodicity_id: params[:periodicity])
        redirect_to company_path(@company.id)
    end
=begin
    def destroy
        @company = Company.find(params[:company_id])
        @entity = Entity.find(params[:id])
        redirect_to company_path(@company.id)
    end
=end    
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

    def render_select_country
        @country = Country.find(params[:country_id])
        @user = current_user
        # extract user entities access
        @user_accesses = UserAccessCompany.where(user_id: @user.id)
        @entity_ids = []
        @user_accesses.each do |user_access|
            @entity_ids += user_access.company.entity_ids
        end
        @entities = Entity.where(id: @entity_ids, country_id: @country.id)

        html_string = render_to_string(partial: "select_country.html.erb", locals: {countries: @entities})
        render json: {html_string: html_string}
    end
    

    def render_items_entity
        @entity = Entity.find(params[:entity_id])
        @items = @entity.items
        html_string = render_to_string(partial: "all_items_entity.html.erb", locals: {items: @items})
        render json: {html_string: html_string}
    end 

    # French 

    def show_french
        @entity = Entity.find(params[:entity_id])
        @declarations = @entity.returns.order("begin_date asc")
    end

    def edit_french
        @company = Company.find(params[:company_id])
        @entity = Entity.find(params[:entity_id])
        @countries = Country.order("name asc").all
    end

    def udpate_french
        @company = Company.find(update_french_params[:company_id])
        @entity = Entity.find(update_french_params[:entity_id])
        @entity.update(name: update_french_params[:name], address: update_french_params[:address], vat_number: update_french_params[:vat_number], postal_code: update_french_params[:postal_code], city: update_french_params[:city], phone_number: update_french_params[:phone_number], email: update_french_params[:email], website: update_french_params[:website], iban: update_french_params[:iban], bic: update_french_params[:bic])
        path = '/entreprises/' + @company.id.to_s + '/entites/' + @entity.id.to_s 
        redirect_to path

    end

    def new_french
        @company = Company.find(params[:company_id])
        @entity = Entity.new
        @countries = Country.order("name asc").all

    end

    def create_french
        @company = Company.find(params[:company_id])
        @entity = Entity.new(name: params_french[:name], address: params_french[:address], vat_number: params_french[:vat_number], postal_code: params_french[:postal_code], city: params_french[:city], phone_number: params_french[:phone_number], email: params_french[:email], website: params_french[:website], iban: params_french[:iban], bic: params_french[:bic])
        @entity.company = @company
        @country = Country.find(params_french[:country])
        @entity.country = @country
        path = '/entreprises/' + @company.id.to_s
        if @entity.save
            redirect_to path
        else
            render :new
        end
    end

    private

    def entity_params
        params.require(:entity).permit(:name, :address, :postal_code, :city, :vat_number, :country, :phone_number, :email, :website, :iban, :bic)
    end

    def update_french_params
        params.permit(:name, :address, :postal_code, :city, :vat_number, :phone_number, :iban, :bic, :company_id, :entity_id, :email)
    end

    def params_french
        params.permit(:name, :address, :postal_code, :city, :vat_number, :country, :phone_number, :email, :website, :iban, :bic)
    end
end