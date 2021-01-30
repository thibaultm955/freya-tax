class CountriesController < ApplicationController
    def render_select_project
        @entity = Entity.find(params[:entity_id])
        @entities = Entity.where(name: @entity.name)
        entity_country = []
        @entities.each {|entity| entity_country << entity.country.id}
        @type_project = PeriodictyToProjectType.where(country_id: @entity.country)
        @projects_type = []
        @type_project.each{|project| @projects_type << project.project_type.id}
        @projects_type = @projects_type.uniq
        @all_project_type = ProjectType.where(id: @projects_type)
        html_string = render_to_string(partial: "select_countries.html.erb", locals: {countries: @countries, type_project: @all_project_type})
        render json: {html_string: html_string}

    end
end