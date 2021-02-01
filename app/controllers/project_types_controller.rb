class ProjectTypesController < ApplicationController
    def render_select_periodicity
       
        @project_type = ProjectType.find(params[:project_type_id])
        
        @periodicity_to_project_type = PeriodicityToProjectType.where(project_type_id: @project_type.id)
        @periodicities = []
        @periodicity_to_project_type.each{|project| @periodicities << project.periodicity.id}
        @all_periodicities = Periodicity.where(id: @periodicity_to_project_type)
        html_string = render_to_string(partial: "select_periodicities.html.erb", locals: { periodicities: @all_periodicities})
        render json: {html_string: html_string}

    end
end