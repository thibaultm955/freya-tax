class AccessesController < ApplicationController

    def index
        @company = Company.find(params[:company_id]) 
        @user_access = UserAccessCompany.where(user_id: current_user.id, company_id: @company.id)[0]
        if @user_access.nil?
            # You don't have any access
            @no_access = "You don't have any access. Please contact your administrator / owner of the company account"
        # If you are admin, you can see who has access to your company
        elsif @user_access.access_id == 1
            @user_accesses = UserAccessCompany.where(company_id: @company.id)
        # If you are normal user, you can see what access you have
        else
            @user_accesses = UserAccessCompany.where(user_id: current_user.id)
        end

    end

    def new
        @accesses = Access.all
        @user = current_user
        @company = Company.find(params[:company_id])
        @user_access = UserAccessCompany.where(user_id: current_user.id, company_id: @company.id)[0]
        # Only if you are admin you can add a user
        if @user_access.access_id != 1
            path = '/company/' + @company.id.to_s + '/accesses'
            redirect_to path

        end

    end
end