class CountriesController < ApplicationController
    def render_select_project
       
        @type_project = PeriodicityToProjectType.where(country_id: params[:country_id])
        @projects_type = []
        @type_project.each{|project| @projects_type << project.project_type.id}
        @projects_type = @projects_type.uniq
        @all_project_type = ProjectType.where(id: @projects_type)
        html_string = render_to_string(partial: "select_countries.html.erb", locals: { type_project: @all_project_type})
        render json: {html_string: html_string}

    end
end