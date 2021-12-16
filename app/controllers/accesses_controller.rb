class AccessesController < ApplicationController

    def index
        @user_accesses = UserAccessCompany.where(user_id: current_user.id)
        @all_user_accesses = []
        if @user_accesses.empty?
            # You don't have any access
            @no_access = "You don't have any access. Please contact your administrator / owner of the company account"
        else
            @user_accesses.each do |user_access|
                # If you are admin, you can see who has access to your company
                if user_access.access_id == 1
                    @all_user_accesses += UserAccessCompany.where(company_id: user_access.company.id)
                # If you are normal user, you can see what access you have
                else
                    @all_user_accesses += UserAccessCompany.where(user_id: current_user.id)
                end
            end
        end
    end

    def new
        @accesses = Access.all
        @user = current_user
        @user_owner_accesses = UserAccessCompany.where(user_id: current_user.id, access_id: 1)
        company_ids = []
        # Only if you are admin you can add a user
        if @user_owner_accesses.empty?
            path = '/accesses'
            redirect_to path
        else
            @user_owner_accesses.each do |access|
                company_ids << access.company_id
            end
            @companies = Company.where(id: company_ids)

        end

    end

    def create
        @company = Company.find(params[:company])
        @access_type = Access.find(params[:access_type])
        @receiving_user = User.where(email: params[:email])[0]
        @user = current_user
        @user_access = UserAccessCompany.where(user_id: current_user.id, company_id: @company.id)[0]
        
        # Only if you are admin you can add a user
        if @user_access.access_id == 1
            # check if user has already access to the company
            @receiving_user_access = UserAccessCompany.where(user_id: @receiving_user.id, company_id: @company.id)
            if @receiving_user_access.empty?
                @user_access = UserAccessCompany.new(user_id: @receiving_user.id, company_id: @company.id, access_id: @access_type.id)
                @user_access.save
            else
                @user_access = @receiving_user_access.update(access_id: @access_type.id)

            end

        end

        path = '/companies/' + @company.id.to_s + '/accesses'
        redirect_to path


    end

    def delete_access
        @user = current_user
        @user_access_company = UserAccessCompany.find(params[:access_id])
        @company_access = UserAccessCompany.where(company_id: @user_access_company.company_id, user_id: @user.id)
        # if user has admin rights can delete
        if @company_access[0].access_id == 1
            @user_access_company.destroy
        end
        path = '/accesses'
        redirect_to path

    end
end