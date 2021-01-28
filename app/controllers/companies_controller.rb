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

=begin 
    
    # Attention, Destroy used to remove entities from company show screen
    def destroy
        @company = Company.find(current_user.company_id)
        @entity = Entity.find(params[:id])
        @entity.delete
        redirect_to company_path(@company.id)
    end 
=end

    private

    def params_company
        params.require(:company).permit(:name, :country)
    end
end